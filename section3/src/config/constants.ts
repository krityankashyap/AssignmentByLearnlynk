export const TASK_TYPES = ['call', 'email', 'review'] as const;

export const TASK_STATUS = {
  PENDING: 'pending',
  COMPLETED: 'completed',
} as const;

export type TaskType = typeof TASK_TYPES[number];
export type TaskStatus = typeof TASK_STATUS[keyof typeof TASK_STATUS];