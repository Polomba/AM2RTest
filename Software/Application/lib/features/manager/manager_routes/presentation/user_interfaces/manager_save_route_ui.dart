import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/components/custom_scaffold.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/cubits/cubit_factory.dart';
import 'package:generic_project/core/utils/kml_parser/kml_utils.dart';
import 'package:generic_project/features/manager/manager_routes/presentation/business_components/manager_routes_cubit.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';

class ManagerSaveRouteUI extends StatefulWidget {
  final List<Map<String, double>> coordinates;
  const ManagerSaveRouteUI({super.key, required this.coordinates});

  @override
  State<ManagerSaveRouteUI> createState() => _ManagerSaveRouteUIState();
}

class _ManagerSaveRouteUIState extends State<ManagerSaveRouteUI> {
  final _managerRoutesCubit = CubitFactory.managerRoutesCubit;

  final TextEditingController _routeFileNameController =
      TextEditingController();
  final TextEditingController _routeNameController = TextEditingController();
  bool changedRouteFile = false;

  double _routeDistance = 0;

  bool _isLoading = false;

  _createAndUploadRouteFileToFS() async {
    await KMLUtility().createKMLFile(
        '${_routeNameController.text.trim()}_v1', widget.coordinates);
    Directory directory = await getApplicationDocumentsDirectory();

    File file =
        File('${directory.path}/${_routeNameController.text.trim()}_v1.kml');
    _managerRoutesCubit.uploadRouteFile(file.path);
  }

  _getRouteDistance() async {
    if (widget.coordinates.isNotEmpty) {
      for (int i = 0; i < widget.coordinates.length - 1; i++) {
        var coord = widget.coordinates[i];
        var nextCoord = widget.coordinates[i + 1];
        setState(() {
          _routeDistance += const Distance().as(
            LengthUnit.Meter,
            LatLng(coord['latitude']!, coord['longitude']!),
            LatLng(nextCoord['latitude']!, nextCoord['longitude']!),
          );
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: CustomScaffold(
        body: BlocConsumer<ManagerRoutesCubit, ApplicationState>(
          bloc: _managerRoutesCubit,
          listener: (context, state) {
            if (state is ManagerCreateRouteSuccessState) {
              _createAndUploadRouteFileToFS();
            } else if (state is ManagerRouteFileUploadSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Route created successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop(true);
            }
          },
          builder: (context, state) {
            _isLoading = (state is ApplicationLoadingState);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: Colors.white,
                  width: double.infinity,
                  height: 100,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Caminho Concluído',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Icon(
                            Icons.close,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text('Caminho'),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        readOnly: true,
                        canRequestFocus: false,
                        controller: _routeFileNameController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.file_download_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.grey),
                          ),
                        ),
                        onTap: () {},
                      ),
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
                  child: ElevatedButton(
                    onPressed: changedRouteFile ? () async {} : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      fixedSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Atualizar Caminho'),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text('Nome do Caminho'),
                const SizedBox(
                  height: 14,
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _routeNameController.text = value;
                      _routeFileNameController.text = '${value}_v1.kml';
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Atribui um nome ao caminho',
                    suffixIcon: const Icon(Icons.edit),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.grey)),
                  ),
                  controller: _routeNameController,
                ),
              ],
            );
          },
        ),
        floatingActionButton: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: ElevatedButton(
              onPressed: (_routeNameController.text.isNotEmpty)
                  ? () async {
                      await _getRouteDistance();
                      var routeBody = {
                        'name': _routeNameController.text.trim(),
                        'distance': _routeDistance.toInt(),
                        'description': _routeNameController.text.trim(),
                        'filename': '${_routeNameController.text}_v1.kml',
                        'fileVersion': 1
                      };
                      _managerRoutesCubit.createRoute(routeBody);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                fixedSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Guardar Caminho'),
            ),
          ),
        ),
      ),
    );
  }
}
