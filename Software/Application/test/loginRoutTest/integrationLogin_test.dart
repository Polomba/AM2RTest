import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:generic_project/core/components/custom_input_field.dart';
import 'package:generic_project/features/authentication/presentation/business_components/auth_cubit.dart';
import 'package:generic_project/features/authentication/presentation/user_interfaces/login_ui.dart';
import 'package:generic_project/features/home/presentation/user_interfaces/home_ui.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/mockito.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  group('LoginUI Widget Tests', () {
    testWidgets('Login with valid credentials', (WidgetTester tester) async {
      // Mock CubitFactory
      final MockAuthCubit authCubit = MockAuthCubit();

      // Pump the LoginUI widget with MaterialApp
      await tester.pumpWidget(MaterialApp(
        home: LoginUI()));

      expect(find.text('Login'), findsOneWidget);

      // Define valid email and password
      final String validEmail = 'test@example.com';
      final String validPassword = 'password';

      // Enter email and password using TextEditingController
      //await tester.enterText(find.byKey(ValueKey('email_field')), validEmail);
      //await tester.enterText(find.byKey(ValueKey('password_field')), validPassword);

      // Tap on the login button
      //await tester.tap(find.byKey(ValueKey('login_button')));

      // Wait for the UI to settle
      //await tester.pumpAndSettle();

      // Verify if the loginWithEmailAndPassword method was called with the correct arguments
      //verify(authCubit.loginWithEmailAndPassword(false, validEmail, validPassword)).called(1);

      // Verify if the user is navigated to the home screen upon successful login
      expect(find.byKey(ValueKey('home_screen')), findsOneWidget);
    });
  });
}