import { Injectable } from '@nestjs/common';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';
import { join } from 'path';
import * as fs from 'fs';
import * as csvParser from 'csv-parser';

@Injectable()
export class SeriesService {
  constructor(private responseStrategy: ResponseStrategy) {}

  private readonly filePath = join(__dirname, '../../', 'assets', 'data.csv');

  async readCsv(): Promise<any[]> {
    return new Promise((resolve, reject) => {
      const results = [];
      fs.createReadStream(this.filePath)
        .pipe(csvParser())
        .on('data', (data: any) => results.push(data))
        .on('end', () => resolve(results))
        .on('error', (error: any) => reject(error));
    });
  }

  async getSeriesByTitleMediaType(
    title: string,
    mediaType: string,
    data: any[],
  ) {
    return data.filter(
      (item) => item['제목'] === title && item['미디어타입'] === mediaType,
    );
  }
  async getSeriesByTitle(title: string, data: any[]) {
    try {
      data = data.filter((item) => item['제목'] === title);
      this.responseStrategy.success('Series retrieved successfully', data);
    } catch (error) {
      this.responseStrategy.error('Failed to retrieve series', error);
    }
  }

  async getSeriesByMediaType(mediaType: string, data: any[]) {
    try {
      data = data.filter((item) => item['미디어타입'] === mediaType);
      return this.responseStrategy.success(
        'Series retrieved successfully',
        data,
      );
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve series', error);
    }
  }

  async getSeries(data: any[]) {
    try {
      return this.responseStrategy.success(
        'Series retrieved successfully',
        data,
      );
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve series', error);
    }
  }
}
