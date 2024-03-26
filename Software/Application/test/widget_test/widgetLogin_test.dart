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
      final MockAuthCubit authCubit = MockAuthCubit();

      await tester.pumpWidget(MaterialApp(
        home: LoginUI()));

      expect(find.text('Login'), findsOneWidget);

      //await tester.enterText(find.byKey(ValueKey('email_field')), validEmail);
      //await tester.enterText(find.byKey(ValueKey('password_field')), validPassword);

      //await tester.tap(find.byKey(ValueKey('login_button')));

      //await tester.pumpAndSettle();

      //verify(authCubit.loginWithEmailAndPassword(false, validEmail, validPassword)).called(1);

      expect(find.byKey(ValueKey('home_screen')), findsOneWidget);
    });
  });
}