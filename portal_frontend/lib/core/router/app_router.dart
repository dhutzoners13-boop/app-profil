import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_frontend/presentation/screens/shell_screen.dart';
import 'package:portal_frontend/presentation/screens/home/home_screen.dart';
import 'package:portal_frontend/presentation/screens/posts/posts_screen.dart';
import 'package:portal_frontend/presentation/screens/posts/post_detail_screen.dart';
import 'package:portal_frontend/presentation/screens/pages/page_detail_screen.dart';
import 'package:portal_frontend/presentation/screens/faq/faq_screen.dart';
import 'package:portal_frontend/presentation/screens/questions/questions_screen.dart';
import 'package:portal_frontend/presentation/screens/questions/question_detail_screen.dart';
import 'package:portal_frontend/presentation/screens/questions/create_question_screen.dart';
import 'package:portal_frontend/presentation/screens/settings/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Branch 1: Posts
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/posts',
                builder: (context, state) => const PostsScreen(),
              ),
            ],
          ),
          // Branch 2: Public Questions & Inquiries
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/questions',
                builder: (context, state) => const QuestionsScreen(),
              ),
            ],
          ),
          // Branch 3: FAQ
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/faqs',
                builder: (context, state) => const FaqScreen(),
              ),
            ],
          ),
        ],
      ),
      // Standalone & Detail Routes
      GoRoute(
        path: '/posts/:slug',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return PostDetailScreen(slug: slug);
        },
      ),
      GoRoute(
        path: '/pages/:slug',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return PageDetailScreen(slug: slug);
        },
      ),
      GoRoute(
        path: '/questions/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateQuestionScreen(),
      ),
      GoRoute(
        path: '/questions/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final idStr = state.pathParameters['id'] ?? '0';
          final id = int.tryParse(idStr) ?? 0;
          return QuestionDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
