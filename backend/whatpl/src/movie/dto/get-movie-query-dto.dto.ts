import { IsOptional, IsString } from 'class-validator';

export class GetMovieQueryDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsString()
  language?: string;
}
