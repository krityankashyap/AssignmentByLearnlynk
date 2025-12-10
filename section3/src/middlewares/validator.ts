import { Request, Response, NextFunction } from 'express';
import { TASK_TYPES } from '../config/constants';

export const validateTask = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const { application_id, task_type, due_at } = req.body;

  if (!application_id || !task_type || !due_at) {
    return res.status(400).json({ 
      error: 'missing required fields',
      required: ['application_id', 'task_type', 'due_at']
    });
  }

  if (!TASK_TYPES.includes(task_type as any)) {
    return res.status(400).json({ 
      error: 'invalid task_type',
      allowed: TASK_TYPES
    });
  }

  const dueDate = new Date(due_at);
  if (isNaN(dueDate.getTime()) || dueDate <= new Date()) {
    return res.status(400).json({ error: 'due_at must be valid future date' });
  }

  next();
};