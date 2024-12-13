import { Module } from '@nestjs/common';
import { ImageService } from './image.service';
import { ImageController } from './image.controller';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';
import { MovieService } from 'src/movie/movie.service';
import { TvService } from 'src/tv/tv.service';

@Module({
  controllers: [ImageController],
  providers: [ImageService, ResponseStrategy, MovieService, TvService],
})
export class ImageModule {}
