import 'package:go_router/go_router.dart';
import 'package:uni_life_rsvp_exam/features/auth/presentation/pages/login_page.dart';
import 'package:uni_life_rsvp_exam/features/auth/presentation/pages/sign_up_page.dart';
import 'package:uni_life_rsvp_exam/features/events/data/event.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/pages/event_page.dart';
import 'package:uni_life_rsvp_exam/features/home/presentation/pages/home_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: '/login',
        name: "login",
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/sign-up',
        name: "signUp",
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/',
        name: "home",
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/event',
        name: "event",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return EventPage(event: extra['event'] as Event);
        },
      ),
    ],
  );
}
