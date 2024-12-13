import { Injectable } from '@nestjs/common';
import axios from 'axios';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';

@Injectable()
export class TvService {
  constructor(private responseStrategy: ResponseStrategy) {}

  async getTvByTitleLanguage(title: string, language: string) {
    try {
      const data = await axios
        .get(
          `https://api.themoviedb.org/3/search/tv?api_key=${process.env.TMDB_API_KEY}&query=${title}&language=${language}`,
        )
        .then((response) => {
          return response.data.results;
        });

      if (data.length === 0) {
        return this.responseStrategy.error('No tvs found', data);
      }

      return this.responseStrategy.success('Tvs fetched successfully', data[0]);
    } catch (error) {
      return this.responseStrategy.error('Failed to fetch tvs', error);
    }
  }
}
