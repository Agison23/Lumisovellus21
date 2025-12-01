import { Router } from 'express';
import healthRoutes from './health/healthRoutes.js';
import segmentsRoutes from './segments/segmentsRoutes.js';
import reviewsRoutes from './reviews/reviewsRoutes.js';
import usersRoutes from './users/usersRoutes.js';
import helpRoutes from './help/helpRoutes.js';
import authRoutes from './auth/authRoutes.js';
import weatherRoutes from './weather/weatherRoutes.js';
import snowTypesRoutes from './snowTypes/snowTypesRoutes.js';

const apiRouter = Router();

// Mount all route modules
apiRouter.use('/', healthRoutes);
apiRouter.use('/auth', authRoutes);
apiRouter.use('/', segmentsRoutes);
apiRouter.use('/', reviewsRoutes);
apiRouter.use('/', usersRoutes);
apiRouter.use('/', helpRoutes);
apiRouter.use('/', weatherRoutes);
apiRouter.use('/', snowTypesRoutes);

export default apiRouter;