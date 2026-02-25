import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/models/role.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/admin_dashboard_screen.dart';
import '../../features/dashboard/presentation/instructor_dashboard_screen.dart';
import '../../features/dashboard/presentation/apprentice_dashboard_screen.dart';
import '../../features/student_health/presentation/student_health_screen.dart';
import '../../features/chatbot/presentation/chatbot_screen.dart';
import '../../features/news/presentation/news_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = user != null;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final index = _indexFromLocation(state.matchedLocation);
          return AppScaffold(
            selectedIndex: index,
            onDestinationSelected: (i) => _navigateToIndex(context, i),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) {
              final role = user?.role ?? Role.apprentice;
              switch (role) {
                case Role.admin:
                  return const AdminDashboardScreen();
                case Role.instructor:
                  return const InstructorDashboardScreen();
                case Role.apprentice:
                  return const ApprenticeDashboardScreen();
              }
            },
          ),
          GoRoute(
            path: '/student-health',
            builder: (context, state) => const StudentHealthScreen(),
          ),
          GoRoute(
            path: '/chatbot',
            builder: (context, state) => const ChatbotScreen(),
          ),
          GoRoute(
            path: '/news',
            builder: (context, state) => const NewsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});

int _indexFromLocation(String location) {
  switch (location) {
    case '/dashboard':
      return 0;
    case '/student-health':
      return 1;
    case '/chatbot':
      return 2;
    case '/news':
      return 3;
    case '/profile':
      return 4;
    default:
      return 0;
  }
}

void _navigateToIndex(BuildContext context, int index) {
  final routes = ['/dashboard', '/student-health', '/chatbot', '/news', '/profile'];
  if (index >= 0 && index < routes.length) {
    GoRouter.of(context).go(routes[index]);
  }
}
