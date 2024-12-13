import { Module } from '@nestjs/common';
import { FirebaseService } from 'src/firebase/firebase.service';
import { AppRepository } from 'src/app.repository';
import { Course } from './entities/course.entity';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';
import { FirebaseModule } from 'src/firebase/firebase.module';
import { CourseController } from './course.controller';
import { CourseService } from './course.service';

@Module({
  imports: [FirebaseModule],
  controllers: [CourseController],
  providers: [
    CourseService,
    ResponseStrategy,
    {
      provide: 'COURSE_COLLECTION',
      useValue: 'Course',
    },
    {
      provide: 'COURSE_REPOSITORY',
      useFactory: (firebaseService: FirebaseService, collection: string) => {
        return new AppRepository<Course>(firebaseService, collection);
      },
      inject: [FirebaseService, 'COURSE_COLLECTION'],
    },
  ],
  exports: [CourseService],
})
export class CourseModule {}
