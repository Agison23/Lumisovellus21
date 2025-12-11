import { BaseService } from '../BaseService.js';
import type { Weather } from '@prisma/client';

interface WeatherData {
  temperature: number | null;
  windSpeed: number | null;
  windDirection: number | null;
  airPressure: number | null;
  snowDepth: number | null;
  relativeHumidity: number | null;
  dewPoint: number | null;
  precipitation: number | null;
  visibility: number | null;
  cloudCover: number | null;
  stationId: string;
  stationName: string;
}

type WeatherValueKey = 'temperature' | 'windSpeed' | 'windDirection' | 'snowDepth';
type AverageWeatherItem = 'windSpeed' | 'windDirection';
type MaximumWeatherItem = 'temperature' | 'windSpeed';
type ChangeWeatherItem = 'snowDepth';

type WeatherRecord = Pick<Weather, WeatherValueKey | 'timestamp'>;

const WEATHER_LOCATION = {
  name: 'Pallastunturi',
  latitude: 68.066,
  longitude: 24.133,
};

const FMI_STATION_ID = process.env.FMI_STATION_ID ?? '101982';
const FMI_STATION_NAME = process.env.FMI_STATION_NAME ?? WEATHER_LOCATION.name;

export class WeatherService extends BaseService {
  get location(): typeof WEATHER_LOCATION {
    return WEATHER_LOCATION;
  }

  getPeriodRange(days: number): { start: Date; end: Date } {
    return this.createDateRange(days);
  }

  /**
   * Fetch latest weather data from FMI API
   */
  async fetchFmiWeatherData(): Promise<WeatherData | null> {
    try {
      const url = `https://opendata.fmi.fi/wfs/fin?service=WFS&version=2.0.0&request=GetFeature&storedquery_id=fmi::observations::weather::timevaluepair&fmisid=${FMI_STATION_ID}&`;

      const response = await global.fetch(url);
      if (!response.ok) {
        console.error('Failed to fetch weather data from FMI');
        return null;
      }

      const xmlText = await response.text();
      const { XMLParser } = await import('fast-xml-parser');
      const parser = new XMLParser({
        ignoreAttributes: false,
        attributeNamePrefix: '@_',
        textNodeName: '#text',
      });
      const jsonObj = parser.parse(xmlText);

      // Parse the weather data from XML response
      const weatherData = this.parseFmiXml(jsonObj);

      return {
        temperature: weatherData.temperature ?? null,
        windSpeed: weatherData.windSpeed ?? null,
        windDirection: weatherData.windDirection ?? null,
        airPressure: weatherData.airPressure ?? null,
        snowDepth: weatherData.snowDepth ?? null,
        relativeHumidity: weatherData.relativeHumidity ?? null,
        dewPoint: weatherData.dewPoint ?? null,
        precipitation: weatherData.precipitation ?? null,
        visibility: weatherData.visibility ?? null,
        cloudCover: weatherData.cloudCover ?? null,
        stationId: FMI_STATION_ID,
        stationName: FMI_STATION_NAME,
      };
    } catch (error) {
      console.error('Error fetching weather data:', error);
      return null;
    }
  }

  /**
   * Parse FMI XML response into weather data object
   */
  private parseFmiXml(jsonObj: any): Partial<WeatherData> {
    const data: Partial<WeatherData> = {};

    try {
      // Fast-xml-parser keeps namespace prefixes in keys
      const featureCollection = jsonObj['wfs:FeatureCollection'];
      if (!featureCollection) {
        console.error('No FeatureCollection found');
        return data;
      }

      const members = featureCollection?.['wfs:member'];
      if (!members) {
        console.error('No members found');
        return data;
      }

      // Handle array or single item
      const memberArray = Array.isArray(members) ? members : [members];

      for (const member of memberArray) {
        const observation = member['omso:PointTimeSeriesObservation'];
        if (!observation) continue;

        const omResult = observation?.['om:result'];
        const result = omResult?.['wml2:MeasurementTimeseries'];
        if (!result) continue;

        // Get the measurement ID (e.g., "obs-obs-1-1-t2m")
        const measurementId = result['@_gml:id'];
        const points = result?.['wml2:point'];

        if (!points || !measurementId) continue;

        // Get the latest value (last point in the array)
        const pointArray = Array.isArray(points) ? points : [points];
        const latestPoint = pointArray[pointArray.length - 1];
        const mtvp = latestPoint?.['wml2:MeasurementTVP'];
        const value = mtvp?.['wml2:value'];

        if (value === undefined || value === null || value === 'NaN') continue;

        const numValue = parseFloat(value);
        if (isNaN(numValue)) continue;

        // Map FMI observation IDs to our data fields
        switch (measurementId) {
          case 'obs-obs-1-1-t2m':
            data.temperature = numValue;
            break;
          case 'obs-obs-1-1-ws_10min':
            data.windSpeed = numValue;
            break;
          case 'obs-obs-1-1-wd_10min':
            data.windDirection = numValue;
            break;
          case 'obs-obs-1-1-p_sea':
            data.airPressure = numValue;
            break;
          case 'obs-obs-1-1-rh':
            data.relativeHumidity = numValue;
            break;
          case 'obs-obs-1-1-td':
            data.dewPoint = numValue;
            break;
          case 'obs-obs-1-1-r_1h':
            data.precipitation = numValue;
            break;
          case 'obs-obs-1-1-vis':
            data.visibility = numValue;
            break;
          case 'obs-obs-1-1-n_man':
            data.cloudCover = numValue;
            break;
          case 'obs-obs-1-1-snow_aws':
            data.snowDepth = numValue;
            break;
        }
      }
    } catch (error) {
      console.error('Error parsing FMI XML:', error);
    }

    return data;
  }

  /**
   * Store weather data in database
   */
  async saveWeatherData(weatherData: WeatherData): Promise<Weather | null> {
    try {
      const weather = await this.prisma.weather.create({
        data: {
          timestamp: new Date(),
          temperature: weatherData.temperature,
          windSpeed: weatherData.windSpeed,
          windDirection: weatherData.windDirection,
          airPressure: weatherData.airPressure,
          snowDepth: weatherData.snowDepth,
          relativeHumidity: weatherData.relativeHumidity,
          dewPoint: weatherData.dewPoint,
          precipitation: weatherData.precipitation,
          visibility: weatherData.visibility,
          cloudCover: weatherData.cloudCover,
          stationId: weatherData.stationId,
          stationName: weatherData.stationName,
        },
      });
      return weather;
    } catch (error) {
      console.error('Error saving weather data:', error);
      return null;
    }
  }

  /**
   * Get latest weather data from database
   */
  async getLatestWeather(): Promise<Weather | null> {
    try {
      const weather = await this.prisma.weather.findFirst({
        orderBy: { timestamp: 'desc' },
      });
      return weather;
    } catch (error) {
      console.error('Error fetching latest weather:', error);
      return null;
    }
  }

  /**
   * Get weather history
   */
  async getWeatherHistory(limit: number = 100): Promise<Weather[]> {
    try {
      const weather = await this.prisma.weather.findMany({
        take: limit,
        orderBy: { timestamp: 'desc' },
      });
      return weather;
    } catch (error) {
      console.error('Error fetching weather history:', error);
      return [];
    }
  }

  /**
   * Compute average for supported weather items.
   */
  async getAverageForItem(item: AverageWeatherItem, days: number): Promise<number | null> {
    const records = await this.getWeatherRecordsForPeriod(days);
    const values = this.extractNumericValues(records, item);
    if (!values.length) {
      return null;
    }

    if (item === 'windDirection') {
      return this.computeCircularMean(values);
    }

    return this.computeArithmeticMean(values);
  }

  async getMinimumForItem(days: number): Promise<number | null> {
    const records = await this.getWeatherRecordsForPeriod(days);
    const values = this.extractNumericValues(records, 'temperature');
    if (!values.length) {
      return null;
    }
    return Math.min(...values);
  }

  async getMaximumForItem(item: MaximumWeatherItem, days: number): Promise<number | null> {
    const records = await this.getWeatherRecordsForPeriod(days);
    const values = this.extractNumericValues(records, item);
    if (!values.length) {
      return null;
    }
    return Math.max(...values);
  }

  async getChangeForItem(item: ChangeWeatherItem, days: number): Promise<number | null> {
    const records = await this.getWeatherRecordsForPeriod(days);
    const values = records
      .map((record) => ({
        timestamp: record.timestamp,
        value: record[item],
      }))
      .filter((entry): entry is { timestamp: Date; value: number } => typeof entry.value === 'number');

    if (values.length < 2) {
      return null;
    }

    const first = values[0].value;
    const last = values[values.length - 1].value;
    return last - first;
  }

  async getDaysWhereAverageTemperatureExceedsThreshold(
    days: number,
    threshold: number
  ): Promise<Array<{ date: string; averageTemperature: number }>> {
    const records = await this.getWeatherRecordsForPeriod(days);
    const grouped = new Map<string, number[]>();

    records.forEach((record) => {
      if (typeof record.temperature !== 'number') {
        return;
      }
      const dateKey = this.toIsoDate(record.timestamp);
      const list = grouped.get(dateKey) ?? [];
      list.push(record.temperature);
      grouped.set(dateKey, list);
    });

    const results: Array<{ date: string; averageTemperature: number }> = [];

    grouped.forEach((temperatures, dateKey) => {
      const average = this.computeArithmeticMean(temperatures);
      if (average !== null && average > threshold) {
        results.push({
          date: `${dateKey}T00:00:00.000Z`,
          averageTemperature: average,
        });
      }
    });

    return results.sort((a, b) => a.date.localeCompare(b.date));
  }

  /**
   * Update weather data - fetch from API and save to database
   */
  async updateWeatherData(): Promise<Weather | null> {
    const weatherData = await this.fetchFmiWeatherData();
    if (!weatherData) {
      console.log('Failed to fetch weather data from FMI API');
      return null;
    }

    const savedWeather = await this.saveWeatherData(weatherData);
    if (savedWeather) {
      console.log('Weather data updated successfully:', savedWeather.id);
    }
    return savedWeather;
  }

  private async getWeatherRecordsForPeriod(days: number): Promise<WeatherRecord[]> {
    const { start, end } = this.createDateRange(days);
    return this.prisma.weather.findMany({
      where: {
        timestamp: {
          gte: start,
          lte: end,
        },
      },
      orderBy: { timestamp: 'asc' },
      select: {
        timestamp: true,
        temperature: true,
        windSpeed: true,
        windDirection: true,
        snowDepth: true,
      },
    });
  }

  private extractNumericValues(records: WeatherRecord[], key: WeatherValueKey): number[] {
    return records
      .map((record) => record[key])
      .filter((value): value is number => typeof value === 'number' && !Number.isNaN(value));
  }

  private computeArithmeticMean(values: number[]): number | null {
    if (!values.length) {
      return null;
    }
    const total = values.reduce((sum, value) => sum + value, 0);
    return total / values.length;
  }

  private computeCircularMean(values: number[]): number | null {
    if (!values.length) {
      return null;
    }
    const radians = values.map((value) => (value * Math.PI) / 180);
    const sinSum = radians.reduce((sum, angle) => sum + Math.sin(angle), 0);
    const cosSum = radians.reduce((sum, angle) => sum + Math.cos(angle), 0);
    const meanAngle = Math.atan2(sinSum / values.length, cosSum / values.length);
    const degrees = (meanAngle * 180) / Math.PI;
    return degrees < 0 ? degrees + 360 : degrees;
  }

  private toIsoDate(date: Date): string {
    return date.toISOString().split('T')[0];
  }

  private createDateRange(days: number): { start: Date; end: Date } {
    const end = new Date();
    const start = new Date(end.getTime() - days * 24 * 60 * 60 * 1000);
    return { start, end };
  }
}
