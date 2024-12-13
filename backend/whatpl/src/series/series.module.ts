import { Module } from '@nestjs/common';
import { SeriesService } from './series.service';
import { SeriesController } from './series.controller';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';

@Module({
  controllers: [SeriesController],
  providers: [SeriesService, ResponseStrategy],
  exports: [SeriesService],
})
export class SeriesModule {}
