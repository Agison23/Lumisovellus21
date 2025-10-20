import { Router } from 'express';
import healthRoutes from './health/healthRoutes';
import segmentsRoutes from './segments/segmentsRoutes';
import reviewsRoutes from './reviews/reviewsRoutes';
import usersRoutes from './users/usersRoutes';
import helpRoutes from './help/helpRoutes';

const apiRouter = Router();

// Mount all route modules
apiRouter.use('/', healthRoutes);
apiRouter.use('/', segmentsRoutes);
apiRouter.use('/', reviewsRoutes);
apiRouter.use('/', usersRoutes);
apiRouter.use('/', helpRoutes);

export default apiRouter;
