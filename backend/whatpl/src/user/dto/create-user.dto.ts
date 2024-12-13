import { IsArray, IsString } from 'class-validator';

export class CreateUserDto {
  @IsString()
  id: string;

  @IsString()
  email: string;

  @IsArray()
  @IsString({ each: true })
  likeSeries: string[];
}
