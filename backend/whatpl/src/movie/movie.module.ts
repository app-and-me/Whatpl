import { Module } from '@nestjs/common';
import { MovieService } from './movie.service';
import { MovieController } from './movie.controller';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';

@Module({
  controllers: [MovieController],
  providers: [MovieService, ResponseStrategy],
})
export class MovieModule {}
