export interface CreateTaskRequest {
  application_id: string;
  task_type: string;
  due_at: string;
}

export interface Task {
  id: string;
  tenant_id: string;
  related_id: string;
  type: string;
  title: string;
  due_at: string;
  status: string;
  created_at: string;
  updated_at: string;
}

export interface Application {
  id: string;
  tenant_id: string;
}