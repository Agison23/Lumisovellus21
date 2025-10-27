import { Router } from 'express';
import { WeatherController } from '../../controllers/weather/WeatherController';

const router = Router();
const weatherController = new WeatherController();

/**
 * @swagger
 * /api/v1/weather:
 *   get:
 *     tags:
 *       - Weather
 *     summary: Get latest weather data
 *     description: Returns the most recent weather data from the FMI API
 *     responses:
 *       200:
 *         description: Latest weather data
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   $ref: '#/components/schemas/Weather'
 */
router.get('/weather', weatherController.getLatestWeather);

/**
 * @swagger
 * /api/v1/weather/history:
 *   get:
 *     tags:
 *       - Weather
 *     summary: Get weather history
 *     description: Returns historical weather data
 *     parameters:
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 100
 *         description: Maximum number of records to return
 *     responses:
 *       200:
 *         description: Weather history
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Weather'
 */
router.get('/weather/history', weatherController.getWeatherHistory);

/**
 * @swagger
 * /api/v1/weather/update:
 *   post:
 *     tags:
 *       - Weather
 *     summary: Manually trigger weather update
 *     description: Fetches new weather data from FMI API and saves it to database
 *     responses:
 *       200:
 *         description: Weather data updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   $ref: '#/components/schemas/Weather'
 */
router.post('/weather/update', weatherController.updateWeatherNow);

export default router;
