import { Controller, Get, Query } from '@nestjs/common';
import { GetSeriesQueryDto } from './dto/get-series-query.dto';
import { SeriesService } from './series.service';

@Controller('api/series')
export class SeriesController {
  constructor(private readonly seriesService: SeriesService) {}

  @Get('tmdb')
  async getSeries(@Query() query: GetSeriesQueryDto) {
    const csvData = await this.seriesService.readCsv();
    const { title, mediaType } = query;

    if (title && mediaType) {
      return await this.seriesService.getSeriesByTitleMediaType(
        title,
        mediaType,
        csvData,
      );
    }

    if (title) {
      return await this.seriesService.getSeriesByTitle(title, csvData);
    }

    if (mediaType) {
      return await this.seriesService.getSeriesByMediaType(mediaType, csvData);
    }

    return await this.seriesService.getSeries(csvData);
  }
}
