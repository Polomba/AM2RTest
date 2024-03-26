import 'package:flutter/material.dart';
import 'package:generic_project/core/components/custom_scaffold.dart';
import 'package:generic_project/core/navigator/application_routes.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(ApplicationRoutes.mapScreen);
          },
          child: const Text('Map Page'),
        ),
      ],
    ));
  }
}
