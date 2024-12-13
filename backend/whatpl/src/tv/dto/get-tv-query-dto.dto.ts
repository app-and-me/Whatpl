import { IsString } from 'class-validator';

export class GetTvQueryDto {
  @IsString()
  title: string;

  @IsString()
  language: string;
}
