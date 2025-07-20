import 'package:flutter/material.dart';
import 'styled_login_page.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';
import 'staff_dashboard.dart';
import 'staff_subpages.dart';
import 'admin_dashboard.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kyle’s Catering',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const StyledLoginPage(),
        '/signup': (context) => const SignupPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/staff-dashboard': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return KylesCateringApp(
            userName: args['userName'] ?? 'Unknown',
            userEmail: args['userEmail'] ?? 'unknown@gmail.com',
          );
        },
        '/admin-dashboard': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return AdminDashboardPage(
            userName: args['userName'] ?? 'Unknown',
            userEmail: args['userEmail'] ?? 'unknown@example.com',
          );
        },

        '/my-schedules': (context) => const MySchedulesPage(),
        '/availability': (context) => const AvailabilityPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/event-details': (context) => const EventDetailsPage(),
        '/calendar-view': (context) => const CalendarViewPage(),
        '/staff-list': (context) => const StaffListPage(),
      },
    );
  }
}
