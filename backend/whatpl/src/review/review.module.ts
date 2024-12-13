import { Module } from '@nestjs/common';
import { FirebaseService } from 'src/firebase/firebase.service';
import { AppRepository } from 'src/app.repository';
import { Review } from './entities/review.entity';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';
import { FirebaseModule } from 'src/firebase/firebase.module';
import { ReviewController } from './review.controller';
import { ReviewService } from './review.service';

@Module({
  imports: [FirebaseModule],
  controllers: [ReviewController],
  providers: [
    ReviewService,
    ResponseStrategy,
    {
      provide: 'REVIEW_COLLECTION',
      useValue: 'Review',
    },
    {
      provide: 'REVIEW_REPOSITORY',
      useFactory: (firebaseService: FirebaseService, collection: string) => {
        return new AppRepository<Review>(firebaseService, collection);
      },
      inject: [FirebaseService, 'REVIEW_COLLECTION'],
    },
  ],
  exports: [ReviewService],
})
export class ReviewModule {}
