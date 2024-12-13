import { PartialType } from '@nestjs/mapped-types';
import { CreateReviewDto } from './create-review.dto';
import { IsArray, IsNumber, IsString, Max, Min } from 'class-validator';

export class UpdateReviewDto extends PartialType(CreateReviewDto) {
  @IsString()
  content: string;

  @IsArray()
  @IsString({ each: true })
  images: Array<string>;

  @IsNumber()
  @Min(1)
  @Max(5)
  rate: number;
}
