import { Module } from '@nestjs/common';
import { TvService } from './tv.service';
import { TvController } from './tv.controller';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';

@Module({
  controllers: [TvController],
  providers: [TvService, ResponseStrategy],
})
export class TvModule {}
