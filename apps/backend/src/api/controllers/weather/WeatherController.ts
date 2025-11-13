import { Request, Response } from 'express';
import { WeatherService } from '../../services/weather/WeatherService';
import { ApiResponseHandler } from '../../middleware/responseHandler';
import { asyncHandler } from '../../middleware/errorHandler';

export class WeatherController {
  private weatherService: WeatherService;

  constructor() {
    this.weatherService = new WeatherService();
  }

  getLatestWeather = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const weather = await this.weatherService.getLatestWeather();
      ApiResponseHandler.success(res, weather);
    }
  );

  getWeatherHistory = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const limit = parseInt(req.query.limit as string) || 100;
      const weather = await this.weatherService.getWeatherHistory(limit);
      ApiResponseHandler.success(res, weather);
    }
  );

  updateWeatherNow = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const weather = await this.weatherService.updateWeatherData();
      ApiResponseHandler.success(res, weather);
    }
  );
}
