import { IsArray, IsString } from 'class-validator';

export class CreateCourseDto {
  @IsString()
  content: string;

  @IsArray()
  @IsString({ each: true })
  places: string[];

  @IsString()
  series: string;
}
