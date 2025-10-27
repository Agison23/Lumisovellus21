import * as cron from 'node-cron';
import { WeatherService } from '../api/services/weather/WeatherService';

/**
 * Weather Scheduler
 * Handles scheduled weather updates from FMI API
 */
export class WeatherScheduler {
  private weatherService: WeatherService;
  private cronJob: cron.ScheduledTask | null = null;

  constructor() {
    this.weatherService = new WeatherService();
  }

  /**
   * Start the weather update scheduler
   * Updates weather data every hour at the top of the hour
   */
  start(): void {
    console.log('Starting weather scheduler...');

    // Run every hour at minute 0 (e.g., 1:00, 2:00, 3:00)
    // Format: minute hour dayOfMonth month dayOfWeek
    this.cronJob = cron.schedule('0 * * * *', async () => {
      console.log('Running scheduled weather update...');
      try {
        await this.weatherService.updateWeatherData();
        console.log('Scheduled weather update completed successfully');
      } catch (error) {
        console.error('Error in scheduled weather update:', error);
      }
    });

    console.log('Weather scheduler started - updates will run every hour');

    // Also fetch weather data immediately on startup
    this.fetchInitialWeather();
  }

  /**
   * Stop the weather scheduler
   */
  stop(): void {
    if (this.cronJob) {
      this.cronJob.stop();
      console.log('Weather scheduler stopped');
    }
  }

  /**
   * Fetch initial weather data on startup
   */
  private async fetchInitialWeather(): Promise<void> {
    console.log('Fetching initial weather data...');
    try {
      // Check if we have recent weather data (within last hour)
      const latestWeather = await this.weatherService.getLatestWeather();

      if (latestWeather) {
        const now = new Date();
        const latestTime = new Date(latestWeather.timestamp);
        const diffInMinutes =
          (now.getTime() - latestTime.getTime()) / (1000 * 60);

        // If we have weather data from the last hour, use it
        if (diffInMinutes < 60) {
          console.log('Recent weather data found, skipping initial fetch');
          return;
        }
      }

      // Fetch new weather data
      await this.weatherService.updateWeatherData();
      console.log('Initial weather data fetched successfully');
    } catch (error) {
      console.error('Error fetching initial weather data:', error);
    }
  }

  /**
   * Manually trigger weather update (for testing/debugging)
   */
  async triggerUpdate(): Promise<void> {
    console.log('Manually triggering weather update...');
    try {
      await this.weatherService.updateWeatherData();
      console.log('Manual weather update completed successfully');
    } catch (error) {
      console.error('Error in manual weather update:', error);
      throw error;
    }
  }
}
