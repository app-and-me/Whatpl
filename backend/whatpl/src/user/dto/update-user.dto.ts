import { PartialType } from '@nestjs/mapped-types';
import { CreateUserDto } from './create-user.dto';
import { IsArray, IsString } from 'class-validator';

export class UpdateUserDto extends PartialType(CreateUserDto) {
  @IsArray()
  @IsString({ each: true })
  course: string[];

  @IsArray()
  @IsString({ each: true })
  likeSeries: string[];

  @IsArray()
  @IsString({ each: true })
  likePlaces: string[];

  @IsArray()
  @IsString({ each: true })
  likeCourses: string[];
}
