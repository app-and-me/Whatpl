import { MiddlewareConsumer, Module } from '@nestjs/common';
import { UserModule } from './user/user.module';
import { CourseModule } from './course/course.module';
import { ReviewModule } from './review/review.module';
import { AuthMiddleware } from './auth.middleware';
import { ConfigModule } from '@nestjs/config';
import { FirebaseModule } from './firebase/firebase.module';
import { SeriesModule } from './series/series.module';
import { MovieModule } from './movie/movie.module';
import { TvModule } from './tv/tv.module';
import { ImageModule } from './image/image.module';
import { PlaceModule } from './place/place.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    FirebaseModule,
    UserModule,
    CourseModule,
    ReviewModule,
    SeriesModule,
    MovieModule,
    TvModule,
    ImageModule,
    PlaceModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {
  // configure(consumer: MiddlewareConsumer) {
  //   consumer.apply(AuthMiddleware).forRoutes('*');
  // }
}
