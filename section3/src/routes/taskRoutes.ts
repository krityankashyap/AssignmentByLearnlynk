import { Router } from 'express';
import * as taskController from '../controllers/taskController';
import { validateTask } from '../middlewares/validator';

const router = Router();

router.post('/create-task', validateTask, taskController.createTask);
router.get('/tasks', taskController.getTasks);

export default router;