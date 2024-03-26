
# Flutter Tests
### The Complete Guide to test a Flutter App:
![Flutter Image](https://github.com/Polomba/TripeirosEstate/assets/73592308/0dc4fd13-b41a-4f95-b6e3-7c2b8b119b05)


## Key Features

* Automated testing falls into a few categories:
  - A unit test tests a single function, method, or class.
  - A widget test (in other UI frameworks referred to as component 
  - An integration test tests a complete app or a large part of an app.

## Installation

After have [Flutter](https://flutter-ko.dev/get-started/install) installed on your computer. From your command line:

```bash
# Use this package as a library
$ https://pub.dev/packages/test/install

# Commando to instaal Flutter_test
$ flutter pub add dev:test

# Add this to your package's pubspec.yaml (and run an implicit dart pub get):
$ dev_dependencies:
  test: ^1.25.2

# Import this on your test.dart file
$ import 'package:test/test.dart';
```

> **Note**
> For more information [see this guide](https://docs.flutter.dev/testing/overview).

## Create a folder to create files for testing

If you dont have the file created, you can creat in the directory folder with the name "test" 
![TestFolder](https://github.com/Polomba/TripeirosEstate/assets/73592308/ebd0fc26-8ea2-474a-9b63-3116aeeb698b)

# Examples - UnitTesting (AM2R)
## Create a class to test
This class create a widget with a list of possible favorite routes.

```ruby
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/components/custom_scaffold.dart';
import 'package:generic_project/core/constants/application_assets.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/cubits/cubit_factory.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/features/favorite_routes/presentation/business_components/cubit/favorite_routes_cubit.dart';

class FavoriteRoutesUI extends StatefulWidget {
  final List<RouteModel> favRoutes;
  FavoriteRoutesUI({super.key, required this.favRoutes});

  @override
  State<FavoriteRoutesUI> createState() => _FavoriteRoutesUIState();
}

class _FavoriteRoutesUIState extends State<FavoriteRoutesUI> {
  final _favoriteRoutesCubit = CubitFactory.favoriteRoutesCubit;
  List<RouteModel> favRoutes = [];
  bool _didChanges = false;

  @override
  void initState() {
    favRoutes = widget.favRoutes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_didChanges);
        return true;
      },
      child: CustomScaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            const Text(
              'Caminhos Favoritos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<FavoriteRoutesCubit, ApplicationState>(
              bloc: _favoriteRoutesCubit,
              builder: (context, state) {
                return Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        final route = widget.favRoutes[index];
                        return ListTile(
                          leading: Image.asset(ApplicationAssets.routeIcon),
                          title: Text(route.name),
                          subtitle: Text(
                              'Distância - ${route.distance.toStringAsFixed(0)}km'),
                          trailing: IconButton(
                            onPressed: () {
                              _favoriteRoutesCubit
                                  .removeFromFavorites(route.id);
                            },
                            icon: const Icon(Icons.favorite),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                            thickness: 1,
                          ),
                      itemCount: widget.favRoutes.length),
                );
              },
              listener: (context, state) {
                switch (state.runtimeType) {
                  case FavoriteRoutesRemoveSuccessState:
                    favRoutes.removeWhere((element) =>
                        element.id ==
                        (state as FavoriteRoutesRemoveSuccessState).routeId);
                    _didChanges = true;
                    break;
                  default:
                }
              },
            )
          ],
        ),
        showLeading: BackButton(
          onPressed: () => Navigator.of(context).pop(_didChanges),
          color: Colors.black,
        ),
      ),
    );
  }
}

```

## Write a unit test for our class
This test add and remove a route from a list of favourite routes

```ruby
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/features/favorite_routes/presentation/user_interfaces/favorite_routes_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavoriteRoutesUI Widget Tests', () {
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

      await tester.tap(find.byIcon(Icons.favorite).first);
      await tester.pump();

      expect(find.text('Route 1'), findsNothing);
      expect(find.text('Route 2'), findsOneWidget);
    });
  });
}
```
# Examples - IntegrationTesting - (AM2R)
## Add integration dependencies to pubspec.yml 

```bash
integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter
```
## Create a class to test
Same example Unit Testing
This class create a widget with a list of possible favorite routes.
```ruby
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/components/custom_scaffold.dart';
import 'package:generic_project/core/constants/application_assets.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/cubits/cubit_factory.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/features/favorite_routes/presentation/business_components/cubit/favorite_routes_cubit.dart';

class FavoriteRoutesUI extends StatefulWidget {
  final List<RouteModel> favRoutes;
  FavoriteRoutesUI({super.key, required this.favRoutes});

  @override
  State<FavoriteRoutesUI> createState() => _FavoriteRoutesUIState();
}

class _FavoriteRoutesUIState extends State<FavoriteRoutesUI> {
  final _favoriteRoutesCubit = CubitFactory.favoriteRoutesCubit;
  List<RouteModel> favRoutes = [];
  bool _didChanges = false;

  @override
  void initState() {
    favRoutes = widget.favRoutes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_didChanges);
        return true;
      },
      child: CustomScaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            const Text(
              'Caminhos Favoritos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<FavoriteRoutesCubit, ApplicationState>(
              bloc: _favoriteRoutesCubit,
              builder: (context, state) {
                return Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        final route = widget.favRoutes[index];
                        return ListTile(
                          leading: Image.asset(ApplicationAssets.routeIcon),
                          title: Text(route.name),
                          subtitle: Text(
                              'Distância - ${route.distance.toStringAsFixed(0)}km'),
                          trailing: IconButton(
                            onPressed: () {
                              _favoriteRoutesCubit
                                  .removeFromFavorites(route.id);
                            },
                            icon: const Icon(Icons.favorite),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                            thickness: 1,
                          ),
                      itemCount: widget.favRoutes.length),
                );
              },
              listener: (context, state) {
                switch (state.runtimeType) {
                  case FavoriteRoutesRemoveSuccessState:
                    favRoutes.removeWhere((element) =>
                        element.id ==
                        (state as FavoriteRoutesRemoveSuccessState).routeId);
                    _didChanges = true;
                    break;
                  default:
                }
              },
            )
          ],
        ),
        showLeading: BackButton(
          onPressed: () => Navigator.of(context).pop(_didChanges),
          color: Colors.black,
        ),
      ),
    );
  }
}

```

## Write a integration test for our class
This test check if Text "Caminhos Favoritos" and Button are loaded, and add and remove a route from a list of favourite routes
```ruby
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
```

# Run tests using IntelliJ or VSCode
The Flutter plugins for IntelliJ and VSCode support running tests. This is often the best option while writing tests because it provides the fastest feedback and the ability to set breakpoints.

#### IntelliJ
```bash
Open the "name"_test.dart file
Go to Run > Run ‘tests in "name"_test.dart’. You can also press the appropriate keyboard shortcut for your platform.
```

#### VSCode
```bash
Open the "name"_test.dart file
Go to Run > Start Debugging. You can also press the appropriate keyboard shortcut for your platform.
```



# Unit tests Results
## What expect from terminal while executing Unit tests:
### Unit Testing:
![UnitTestResults](https://github.com/Polomba/TripeirosEstate/assets/73592308/4d4d2b34-c6b4-4213-8e30-448e13b26314)

#### If the tests after execution have no errors, this means that everything expected is loaded, it will be marked with a certain.

# Integration tests Results
#### Unlike unit and widgets tests, integrations tests test a large part of the application at once, but to do this it is necessary to have an emulator or a device ready to run the app in test mode as you can see in the following video:

![IntegrationTestResult-ezgif com-video-to-gif-converter](https://github.com/Polomba/TripeirosEstate/assets/73592308/116e92fb-27d5-4097-852d-4f25eb57e873)
