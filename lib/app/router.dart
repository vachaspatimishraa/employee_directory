import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../routes/route_names.dart';
import '../features/auth/view/login_screen.dart';
import '../features/auth/provider/auth_provider.dart';
import '../features/employee/view/home_screen.dart';
import '../features/employee/view/employee_detail_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: RouteNames.home,
    redirect: (context, state) {
      final email = authRepo.getEmail();
      final isLoggedIn = email != null && email.isNotEmpty;
      final isLoggingIn = state.matchedLocation == RouteNames.login;

      if (!isLoggedIn) {
        return RouteNames.login;
      }

      if (isLoggedIn && isLoggingIn) {
        return RouteNames.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.employeeDetail,
        builder: (context, state) {
          final id = state.extra as int;
          return EmployeeDetailScreen(employeeId: id);
        },
      ),
    ],
  );
});
