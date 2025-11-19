import 'package:chat_app/core/utils/form_validator.dart';
import 'package:chat_app/features/auth/login/data/repositories/auth_repository.dart';
import 'package:chat_app/features/auth/login/presentation/viewmodel/login_viewm_model.dart';
import 'package:chat_app/features/auth/signup/data/repositories/user_repository.dart';
import 'package:chat_app/features/auth/signup/presentation/viewmodel/signup_view_model.dart';
import 'package:chat_app/features/chats/data/repositories/recent_chat_repository.dart';
import 'package:chat_app/features/chats/presentation/viewmodel/recent_chat_view_model.dart';
import 'package:chat_app/features/home/presentation/viewmodel/home_view_model.dart';
import 'package:chat_app/features/notifications/data/repositories/notification_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initLocator() async {
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  ); // Firebase auth
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Utility
  getIt.registerLazySingleton<FormValidator>(
    () => FormValidator(),
  ); // Form validator

  // Repositories
  getIt.registerLazySingleton(
    () => AuthRepository(getIt<FirebaseAuth>()),
  ); // Auth repository
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(),
  ); // User repository
  getIt.registerLazySingleton<RecentChatRepository>(
    () => RecentChatRepository(getIt<FirebaseFirestore>()),
  ); // Recent chat repository
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepository(
      baseUrl: "https://notification-server-y924.onrender.com",
    ),
  );

  // View models
  getIt.registerFactory(
    () => SignupViewModel(
      getIt<FormValidator>(),
      getIt<AuthRepository>(),
      getIt<UserRepository>(),
    ),
  ); // Signup view model

  getIt.registerFactory(
    () => LoginViewModel(
      getIt<FormValidator>(),
      getIt<AuthRepository>(),
      getIt<UserRepository>(),
    ),
  ); // Login view model

  getIt.registerFactory(
    () => HomeViewModel(getIt<AuthRepository>()),
  ); // Home view model

  getIt.registerFactory(
    () => RecentChatViewModel(getIt<RecentChatRepository>()),
  ); // Recent chat view model
}






// https://notification-server-y924.onrender.com