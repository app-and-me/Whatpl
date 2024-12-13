import { Controller, Get, Query } from '@nestjs/common';
import { ImageService } from './image.service';
import { GetImageQueryDto } from './dto/get-image-query.dto';

@Controller('api/image')
export class ImageController {
  constructor(private readonly imageService: ImageService) {}

  @Get()
  async getImage(@Query() query: GetImageQueryDto) {
    const { title, language, type } = query;

    return await this.imageService.getImageByTitle(title, language, type);
  }
}
