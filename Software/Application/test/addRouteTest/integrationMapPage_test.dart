import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:generic_project/features/map/presentation/user_interfaces/user_map_ui.dart';


void main() {
  group('MapPage Widget Tests', () {
    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MapPage(),
      ));

      // Verify that the text "Caminhos Favoritos" is rendered
      expect(find.text('Acesso Gestor'), findsOneWidget);

      // Verify that the back button is rendered
      expect(find.byType(DrawerButton), findsOneWidget);
    });
  });
}