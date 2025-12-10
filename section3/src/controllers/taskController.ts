import { Request, Response, NextFunction } from 'express';
import supabase from '../config/db';
import { CreateTaskRequest, Task, Application } from '../model';

export const createTask = async (
  req: Request<{}, {}, CreateTaskRequest>,
  res: Response,
  next: NextFunction
) => {
  try {
    const { application_id, task_type, due_at } = req.body;

    // check if application exists
    const { data: app, error: appError } = await supabase
      .from('applications')
      .select('id, tenant_id')
      .eq('id', application_id)
      .single<Application>();

    if (appError || !app) {
      return res.status(404).json({ error: 'application not found' });
    }

    // create task
    const { data: task, error } = await supabase
      .from('tasks')
      .insert({
        related_id: application_id,
        type: task_type,
        title: `${task_type} task`,
        due_at,
        tenant_id: app.tenant_id,
      })
      .select()
      .single<Task>();

    if (error) throw error;

    // broadcast realtime event
    const channel = supabase.channel('tasks');
    await channel.send({
      type: 'broadcast',
      event: 'task.created',
      payload: { task_id: task.id, task_type }
    });

    res.json({ success: true, task_id: task.id });

  } catch (err) {
    next(err);
  }
};

export const getTasks = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { date } = req.query;
    
    let query = supabase.from('tasks').select('*');
    
    if (date && typeof date === 'string') {
      const start = new Date(date);
      start.setHours(0, 0, 0, 0);
      const end = new Date(start);
      end.setDate(end.getDate() + 1);
      
      query = query.gte('due_at', start.toISOString())
                   .lt('due_at', end.toISOString());
    }

    const { data, error } = await query;
    
    if (error) throw error;
    
    res.json({ tasks: data });
  } catch (err) {
    next(err);
  }
};