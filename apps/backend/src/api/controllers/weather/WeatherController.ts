import { Request, Response } from 'express';
import { WeatherService } from '../../services/weather/WeatherService';
import { ApiResponseHandler } from '../../middleware/responseHandler';
import { asyncHandler } from '../../middleware/errorHandler';
import {
  weatherAverageQuerySchema,
  weatherChangeQuerySchema,
  weatherFilterDaysQuerySchema,
  weatherMaximumQuerySchema,
  weatherMinimumQuerySchema,
} from '../../middleware/validation';
import { z } from 'zod';

type WeatherMetricType = 'average' | 'minimum' | 'maximum' | 'change';

const WEATHER_UNITS: Record<string, string> = {
  temperature: 'celsius',
  windSpeed: 'metersPerSecond',
  windDirection: 'degrees',
  snowDepth: 'centimeters',
};

export class WeatherController {
  private weatherService: WeatherService;

  constructor() {
    this.weatherService = new WeatherService();
  }

  getAverage = asyncHandler(async (req: Request, res: Response) => {
    const parsed = weatherAverageQuerySchema.safeParse(req.query);

    if (!parsed.success) {
      this.handleValidationError(res, parsed.error);
      return;
    }

    const { item, days } = parsed.data;
    const value = await this.weatherService.getAverageForItem(item, days);

    if (value === null) {
      ApiResponseHandler.notFound(res, 'No weather data available for the requested period');
      return;
    }

    ApiResponseHandler.success(res, this.buildMetricResponse('average', item, value, days));
  });

  getMinimum = asyncHandler(async (req: Request, res: Response) => {
    const parsed = weatherMinimumQuerySchema.safeParse(req.query);

    if (!parsed.success) {
      this.handleValidationError(res, parsed.error);
      return;
    }

    const { item, days } = parsed.data;
    const value = await this.weatherService.getMinimumForItem(days);

    if (value === null) {
      ApiResponseHandler.notFound(res, 'No weather data available for the requested period');
      return;
    }

    ApiResponseHandler.success(res, this.buildMetricResponse('minimum', item, value, days));
  });

  getMaximum = asyncHandler(async (req: Request, res: Response) => {
    const parsed = weatherMaximumQuerySchema.safeParse(req.query);

    if (!parsed.success) {
      this.handleValidationError(res, parsed.error);
      return;
    }

    const { item, days } = parsed.data;
    const value = await this.weatherService.getMaximumForItem(item, days);

    if (value === null) {
      ApiResponseHandler.notFound(res, 'No weather data available for the requested period');
      return;
    }

    ApiResponseHandler.success(res, this.buildMetricResponse('maximum', item, value, days));
  });

  getChange = asyncHandler(async (req: Request, res: Response) => {
    const parsed = weatherChangeQuerySchema.safeParse(req.query);

    if (!parsed.success) {
      this.handleValidationError(res, parsed.error);
      return;
    }

    const { item, days } = parsed.data;
    const value = await this.weatherService.getChangeForItem(item, days);

    if (value === null) {
      ApiResponseHandler.notFound(res, 'No weather data available for the requested period');
      return;
    }

    ApiResponseHandler.success(res, this.buildMetricResponse('change', item, value, days));
  });

  filterDays = asyncHandler(async (req: Request, res: Response) => {
    const parsed = weatherFilterDaysQuerySchema.safeParse(req.query);

    if (!parsed.success) {
      this.handleValidationError(res, parsed.error);
      return;
    }

    const { item, days, threshold } = parsed.data;
    const matches = await this.weatherService.getDaysWhereAverageTemperatureExceedsThreshold(
      days,
      threshold
    );

    ApiResponseHandler.success(res, {
      item,
      threshold,
      days,
      period: this.createPeriod(days),
      location: this.weatherService.location,
      matches,
    });
  });

  private buildMetricResponse(
    type: WeatherMetricType,
    item: string,
    value: number,
    days: number
  ) {
    return {
      type,
      item,
      value,
      unit: WEATHER_UNITS[item] ?? 'unknown',
      days,
      period: this.createPeriod(days),
      location: this.weatherService.location,
    };
  }

  private createPeriod(days: number) {
    const { start, end } = this.weatherService.getPeriodRange(days);
    return {
      start: start.toISOString(),
      end: end.toISOString(),
    };
  }

  private handleValidationError(res: Response, error: z.ZodError) {
    ApiResponseHandler.validationError(res, 'Invalid query parameters', error.format());
  }
}
