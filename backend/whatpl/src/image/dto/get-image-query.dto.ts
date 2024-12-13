import { IsString } from 'class-validator';

export class GetImageQueryDto {
  @IsString()
  title: string;

  @IsString()
  language: string;

  @IsString()
  type: 'drama' | 'movie';
}
