import { Router } from 'express';
import { WeatherController } from '../../controllers/weather/WeatherController.js';

const router = Router();
const weatherController = new WeatherController();

/**
 * @swagger
 * /api/v1/weather/average:
 *   get:
 *     tags:
 *       - Weather
 *     summary: Get average weather metric
 *     description: Returns the rolling average for supported weather items within the requested period.
 *     parameters:
 *       - in: query
 *         name: item
 *         schema:
 *           type: string
 *           enum: [windSpeed, windDirection]
 *         required: true
 *         description: Weather item to average.
 *       - in: query
 *         name: days
 *         schema:
 *           type: integer
 *           default: 3
 *         description: Number of whole days in the look-back window.
 *     responses:
 *       200:
 *         description: Average computed successfully.
 */
router.get('/weather/average', weatherController.getAverage);

/**
 * @swagger
 * /api/v1/weather/minimum:
 *   get:
 *     tags:
 *       - Weather
 *     summary: Get minimum weather metric
 *     description: Returns the rolling minimum temperature within the requested period.
 *     parameters:
 *       - in: query
 *         name: item
 *         schema:
 *           type: string
 *           enum: [temperature]
 *         required: true
 *         description: Weather item to inspect.
 *       - in: query
 *         name: days
 *         schema:
 *           type: integer
 *           default: 3
 *         description: Number of whole days in the look-back window.
 *     responses:
 *       200:
 *         description: Minimum temperature computed successfully.
 */
router.get('/weather/minimum', weatherController.getMinimum);

/**
 * @swagger
 * /api/v1/weather/maximum:
 *   get:
 *     tags:
 *       - Weather
 *     summary: Get maximum weather metric
 *     description: Returns the rolling maximum temperature or wind speed within the requested period.
 *     parameters:
 *       - in: query
 *         name: item
 *         schema:
 *           type: string
 *           enum: [temperature, windSpeed]
 *         required: true
 *         description: Weather item to get the maximum for.
 *       - in: query
 *         name: days
 *         schema:
 *           type: integer
 *           default: 3
 *         description: Number of whole days in the look-back window.
 *     responses:
 *       200:
 *         description: Maximum computed successfully.
 */
router.get('/weather/maximum', weatherController.getMaximum);

/**
 * @swagger
 * /api/v1/weather/change:
 *   get:
 *     tags:
 *       - Weather
 *     summary: Get change in snow depth
 *     description: Returns the change in snow depth between the start and end of the requested period.
 *     parameters:
 *       - in: query
 *         name: item
 *         schema:
 *           type: string
 *           enum: [snowDepth]
 *         required: true
 *         description: Weather item to calculate change for.
 *       - in: query
 *         name: days
 *         schema:
 *           type: integer
 *           default: 7
 *         description: Number of whole days in the look-back window.
 *     responses:
 *       200:
 *         description: Change computed successfully.
 */
router.get('/weather/change', weatherController.getChange);

/**
 * @swagger
 * /api/v1/weather/filterDays:
 *   get:
 *     tags:
 *       - Weather
 *     summary: Filter days by daily average temperature
 *     description: Returns the dates where the daily average temperature exceeds the provided threshold.
 *     parameters:
 *       - in: query
 *         name: item
 *         schema:
 *           type: string
 *           enum: [temperature]
 *         required: true
 *         description: Weather item used for filtering.
 *       - in: query
 *         name: threshold
 *         schema:
 *           type: number
 *           default: 0
 *         required: true
 *         description: Threshold temperature in Celsius.
 *       - in: query
 *         name: days
 *         schema:
 *           type: integer
 *           default: 3
 *         description: Number of whole days in the look-back window.
 *     responses:
 *       200:
 *         description: Filtered days returned successfully.
 */
router.get('/weather/filterDays', weatherController.filterDays);

export default router;
