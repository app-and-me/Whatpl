import { Injectable } from '@nestjs/common';
import axios from 'axios';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';

@Injectable()
export class MovieService {
  constructor(private responseStrategy: ResponseStrategy) {}

  async getMovieByTitleLanguage(title: string, language: string) {
    try {
      const data = await axios
        .get(
          `https://api.themoviedb.org/3/search/movie?api_key=${process.env.TMDB_API_KEY}&query=${title}&language=${language}`,
        )
        .then((response) => {
          return response.data.results;
        });

      if (data.length === 0) {
        return this.responseStrategy.error('No movies found', data[0]);
      }

      return this.responseStrategy.success(
        'Movies fetched successfully',
        data[0],
      );
    } catch (error) {
      return this.responseStrategy.error('Failed to fetch movies', error);
    }
  }
}
