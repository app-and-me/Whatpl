import { Injectable, OnModuleInit } from '@nestjs/common';
import * as admin from 'firebase-admin';
import { ConfigService } from '@nestjs/config';
import * as path from 'path';

@Injectable()
export class FirebaseService implements OnModuleInit {
  private defaultApp: admin.app.App;

  constructor(private configService: ConfigService) {}

  onModuleInit() {
    const serviceAccountPath = path.resolve(
      __dirname,
      '../../',
      this.configService.get<string>('FIREBASE_SERVICE_ACCOUNT_PATH'),
    );

    this.defaultApp = admin.initializeApp({
      credential: admin.credential.cert(serviceAccountPath),
    });
  }

  getFirestore() {
    return this.defaultApp.firestore();
  }
}
