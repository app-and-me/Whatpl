import { IsString, IsArray, IsNumber, Min, Max } from 'class-validator';

export class CreateReviewDto {
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
