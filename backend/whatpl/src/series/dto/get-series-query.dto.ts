import { IsOptional, IsString } from 'class-validator';

export class GetSeriesQueryDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsString()
  mediaType?: string;
}
