import 'package:go_router/go_router.dart';
// Gerçek ekran dosyalarımızı içeri aktarıyoruz
import '../../features/auth/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);