import { Inject, Injectable } from '@nestjs/common';
import { CreateReviewDto } from './dto/create-review.dto';
import { UpdateReviewDto } from './dto/update-review.dto';
import { Review } from './entities/review.entity';
import { ResponseStrategy } from '../shared/strategies/response.strategy';
import { AppRepository } from 'src/app.repository';

@Injectable()
export class ReviewService {
  constructor(
    @Inject('REVIEW_REPOSITORY')
    private reviewRepository: AppRepository<Review>,
    private responseStrategy: ResponseStrategy,
  ) {}

  async create(createReviewDto: CreateReviewDto) {
    try {
      const review: Review = {
        ...createReviewDto,
        createdAt: new Date(),
        likeCount: 0,
        updatedAt: null,
      };
      const id = await this.reviewRepository.createById(review, review.id);
      return this.responseStrategy.success('Review created successfully', {
        id,
        ...review,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to create review', error);
    }
  }

  async findAll() {
    try {
      const reviews = await this.reviewRepository.findAll();
      return reviews.length === 0
        ? this.responseStrategy.noContent('No reviews found')
        : this.responseStrategy.success(
            'Reviews retrieved successfully',
            reviews,
          );
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve reviews', error);
    }
  }

  async findOne(id: string) {
    try {
      const review = await this.reviewRepository.findOne(id);
      return review
        ? this.responseStrategy.success('Review retrieved successfully', review)
        : this.responseStrategy.notFound('Review not found');
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve review', error);
    }
  }

  async update(id: string, updateReviewDto: UpdateReviewDto) {
    try {
      const existingReview = await this.reviewRepository.findOne(id);
      if (!existingReview) {
        return this.responseStrategy.notFound('Review not found');
      }
      const updatedReview: Partial<Review> = {
        ...updateReviewDto,
        updatedAt: new Date(),
      };
      await this.reviewRepository.update(id, updatedReview);
      return this.responseStrategy.success('Review updated successfully', {
        id,
        ...existingReview,
        ...updatedReview,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to update review', error);
    }
  }

  async remove(id: string) {
    try {
      const existingReview = await this.reviewRepository.findOne(id);
      if (!existingReview) {
        return this.responseStrategy.notFound('Review not found');
      }
      await this.reviewRepository.remove(id);
      return this.responseStrategy.success('Review deleted successfully');
    } catch (error) {
      return this.responseStrategy.error('Failed to delete review', error);
    }
  }
}
