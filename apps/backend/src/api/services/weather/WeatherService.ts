import { BaseService } from '../BaseService';
import { Weather } from '@prisma/client';

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

export class WeatherService extends BaseService {
  /**
   * Fetch latest weather data from FMI API
   */
  async fetchFmiWeatherData(): Promise<WeatherData | null> {
    try {
      // Fetch current weather from Muonio Laukukero station (FMI Station ID: 101982)
      const url =
        'https://opendata.fmi.fi/wfs/fin?service=WFS&version=2.0.0&request=GetFeature&storedquery_id=fmi::observations::weather::timevaluepair&fmisid=101982&';

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
        stationId: '101982',
        stationName: 'Muonio Laukukero',
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
}
