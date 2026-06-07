import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_life_rsvp_exam/features/auth/presentation/pages/login_page.dart';
import 'package:uni_life_rsvp_exam/features/auth/presentation/pages/sign_up_page.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/pages/event_page.dart';
import 'package:uni_life_rsvp_exam/features/home/presentation/pages/home_page.dart';

class _GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _authSubscription;

  _GoRouterRefreshStream(Stream<dynamic> authStream) {
    notifyListeners();
    _authSubscription = authStream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static final router = GoRouter(
    initialLocation: "/",
    refreshListenable: _GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      final currentUser = FirebaseAuth.instance.currentUser;
      // ignore: avoid_print
      print('Current state: ${state.uri.path} - ${currentUser?.uid}');
      final isLoggedIn = currentUser != null;
      final isOnAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isLoggedIn) {
        if (!isOnAuthRoute) return '/auth';
        return null;
      }

      if (isLoggedIn && isOnAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        name: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: '/sign-up',
            name: SignUpPage.routeName,
            builder: (context, state) => const SignUpPage(),
          ),
        ],
      ),

      GoRoute(
        path: '/',
        name: HomePage.routeName,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/event',
        name: EventPage.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return EventPage(eventId: extra['eventId'] as String);
        },
      ),
    ],
  );
}
