import express from 'express';
import taskRoutes from './routes/taskRoutes';
import { errorHandler } from './middlewares/errorHandler';
import cors from 'cors';
import { PORT } from './config/db';

const app = express();

app.use(express.json());
app.use(cors());

app.use('/api', taskRoutes);


app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`Task service running on port ${PORT}`);
});

export default app;