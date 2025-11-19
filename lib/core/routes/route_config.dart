import 'package:chat_app/core/routes/route_names.dart';
import 'package:chat_app/features/auth/login/presentation/pages/login_screen.dart';
import 'package:chat_app/features/auth/login/presentation/widgets/auth_wrapper.dart';
import 'package:chat_app/features/auth/signup/presentation/pages/signup_screen.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_screen.dart';
import 'package:chat_app/features/home/presentation/pages/home_screen.dart';
import 'package:chat_app/features/splash/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';

class RouteConfig {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteNames.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case RouteNames.chat:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            name: arguments['name'],
            receiverId: arguments['receiverId'],
          ),
        );

      case RouteNames.authWrapper:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("/Route Error"))),
        );
    }
  }
}
