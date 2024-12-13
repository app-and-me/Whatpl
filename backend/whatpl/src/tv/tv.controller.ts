import { Controller, Get, Query } from '@nestjs/common';
import { TvService } from './tv.service';
import { GetTvQueryDto } from './dto/get-tv-query-dto.dto';

@Controller('api/tv')
export class TvController {
  constructor(private readonly tvService: TvService) {}

  @Get()
  async getTv(@Query() query: GetTvQueryDto) {
    const { title, language } = query;

    return await this.tvService.getTvByTitleLanguage(title, language);
  }
}
