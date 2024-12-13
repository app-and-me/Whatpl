import { Injectable } from '@nestjs/common';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';
import { MovieService } from '../movie/movie.service';
import { TvService } from '../tv/tv.service';
import axios from 'axios';

@Injectable()
export class ImageService {
  constructor(
    private responseStrategy: ResponseStrategy,
    private movieService: MovieService,
    private tvService: TvService,
  ) {}

  async getImageByTitle(title: string, language: string, type: string) {
    try {
      const imageUrl =
        type === 'movie'
          ? await this.movieService
              .getMovieByTitleLanguage(title, language)
              .then((response) => {
                return response.data.poster_path;
              })
          : await this.tvService
              .getTvByTitleLanguage(title, language)
              .then((response) => {
                return response.data.poster_path;
              });

      if (!imageUrl) {
        return this.responseStrategy.error('No image found', imageUrl);
      }

      const image = await axios
        .get(
          `https://image.tmdb.org/t/p/original${imageUrl}?api_key=${process.env.TMDB_API_KEY}`,
        )
        .then((response) => {
          return response.config.url;
        });

      return image;
    } catch (error) {
      return this.responseStrategy.error('Failed to fetch image', error);
    }
  }
}
