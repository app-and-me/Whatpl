import { Module } from '@nestjs/common';
import { FirebaseService } from 'src/firebase/firebase.service';
import { AppRepository } from 'src/app.repository';
import { User } from './entities/user.entity';
import { ResponseStrategy } from 'src/shared/strategies/response.strategy';
import { FirebaseModule } from 'src/firebase/firebase.module';
import { UserController } from './user.controller';
import { UserService } from './user.service';

@Module({
  imports: [FirebaseModule],
  controllers: [UserController],
  providers: [
    UserService,
    ResponseStrategy,
    {
      provide: 'USER_COLLECTION',
      useValue: 'User',
    },
    {
      provide: 'USER_REPOSITORY',
      useFactory: (firebaseService: FirebaseService, collection: string) => {
        return new AppRepository<User>(firebaseService, collection);
      },
      inject: [FirebaseService, 'USER_COLLECTION'],
    },
  ],
  exports: [UserService],
})
export class UserModule {}
