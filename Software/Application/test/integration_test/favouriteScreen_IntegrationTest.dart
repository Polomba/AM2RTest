import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/features/favorite_routes/presentation/user_interfaces/favorite_routes_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('FavoriteRoutesUI Widget Tests', () {
    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: FavoriteRoutesUI(
          favRoutes: [],
        ),
      ));

      expect(find.text('Caminhos Favoritos'), findsOneWidget);

      expect(find.byType(BackButton), findsOneWidget);

      await tester.pumpAndSettle(Duration(seconds: 1)); // Wait for
    });

    testWidgets('Removing from favorites triggers UI update',
        (WidgetTester tester) async {
      final List<RouteModel> favoriteRoutes = [
        RouteModel(
            id: '1',
            name: 'Route 1',
            distance: 10,
            idStatus: '1',
            description: 'Teste1'),
        RouteModel(
            id: '2',
            name: 'Route 2',
            distance: 20,
            idStatus: '2',
            description: 'Teste2'),
      ];

      await tester.pumpWidget(MaterialApp(
        home: FavoriteRoutesUI(
          favRoutes: favoriteRoutes,
        ),
      ));

      expect(find.text('Route 1'), findsOneWidget);
      expect(find.text('Route 2'), findsOneWidget);

      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.byIcon(Icons.favorite).first);
      await tester.pump();

      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.text('Route 1'), findsNothing);
      expect(find.text('Route 2'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.favorite).first);
      await tester.pump();
    });
  });
}
