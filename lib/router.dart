import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supervisor/blocs/report/report_bloc.dart';
import 'package:supervisor/blocs/report/report_event.dart';
import 'package:supervisor/presentation/screens/home_screen.dart';
import 'package:supervisor/presentation/screens/report_detail_screen.dart';

/// Custom route observer that detects when navigating back to the home screen
class MyRouteObserver extends NavigatorObserver {
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    
    // If we're returning to the home screen
    if (previousRoute?.settings.name == '/' || 
        previousRoute?.settings.name == 'home') {
      // Get the context of the previous route
      final context = previousRoute?.navigator?.context;
      if (context != null) {
        // Reload the reports
        context.read<ReportBloc>().add(const LoadReports());
      }
    }
  }
}

/// Router configuration for the app
/// Defines all routes and their parameters
final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  observers: [MyRouteObserver()], // Add the custom observer
  routes: [
    // Home screen - shows list of reports
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        // Report detail screen - shows details of a specific report
        GoRoute(
          path: 'report/:reportId',
          name: 'report_detail',
          builder: (context, state) {
            final reportId = state.pathParameters['reportId']!;
            return ReportDetailScreen(reportId: reportId);
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);