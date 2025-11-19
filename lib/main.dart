import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/di/locator.dart';
import 'package:chat_app/core/routes/route_config.dart';
import 'package:chat_app/core/routes/route_names.dart';
import 'package:chat_app/features/notifications/data/datasources/notification_service.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initLocator(); // locator

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  await NotificationService.init();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;

    if (notification != null) {
      NotificationService.showNotification(
        title: notification.title ?? "New Message",
        body: notification.body ?? "",
      );
    }
  });

  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      //minTextAdapt: true,
      designSize: const Size(402, 874),
      builder: (context, _) => MaterialApp(
        // theme: AppThemes.lightTheme,
        // themeMode: ThemeMode.light,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.white,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          appBarTheme: const AppBarTheme(
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.white,
          ),
        ),
        initialRoute: RouteNames.splash,
        onGenerateRoute: RouteConfig.generateRoute,
      ),
    );
  }
}
