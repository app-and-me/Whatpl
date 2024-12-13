import { PartialType } from '@nestjs/mapped-types';
import { CreateCourseDto } from './create-course.dto';
import { IsArray, IsString } from 'class-validator';

export class UpdateCourseDto extends PartialType(CreateCourseDto) {
  @IsString()
  content: string;

  @IsArray()
  @IsString({ each: true })
  places: string[];

  @IsString()
  series: string;
}
