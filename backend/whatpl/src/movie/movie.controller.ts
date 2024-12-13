import { Controller, Get, Query } from '@nestjs/common';
import { MovieService } from './movie.service';
import { GetMovieQueryDto } from './dto/get-movie-query-dto.dto';

@Controller('api/movie')
export class MovieController {
  constructor(private readonly movieService: MovieService) {}

  @Get()
  async getMovie(@Query() query: GetMovieQueryDto) {
    const { title, language } = query;

    return await this.movieService.getMovieByTitleLanguage(title, language);
  }
}
