import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/components/custom_scaffold.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/cubits/cubit_factory.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/features/manager/manager_add_module/presentation/business_components/manager_add_module_cubit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:geolocator/geolocator.dart';

class ManagerAddModuleUI extends StatefulWidget {
  const ManagerAddModuleUI({super.key});

  @override
  State<ManagerAddModuleUI> createState() => _ManagerAddModuleUIState();
}

class _ManagerAddModuleUIState extends State<ManagerAddModuleUI> {
  final ManagerAddModuleCubit _managerAddModuleCubit =
      CubitFactory.managerAddModuleCubit;
  List<RouteModel> routes = [];

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _pageNum = 1;
  int _totalCount = 0;
  bool _isFirstFetch = true;
  bool _isLastPage = false;

  static const _pageSize = 10;

  RouteModel? _selectedRoute;

  Position? _currentPosition;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _moduleIdentificationController =
      TextEditingController();
  final TextEditingController _moduleNameController = TextEditingController();
  final TextEditingController _locationLatitudeController =
      TextEditingController();
  final TextEditingController _locationLongitudeController =
      TextEditingController();

  @override
  void initState() {
    _managerAddModuleCubit.loadRoutes(_pageNum, _pageSize);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CustomScaffold(
        title: 'Adicionar Poste',
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ],
        body: BlocConsumer<ManagerAddModuleCubit, ApplicationState>(
          bloc: _managerAddModuleCubit,
          listener: (context, state) {
            switch (state.runtimeType) {
              case ManagerAddModuleLocationPermissionSuccessState:
                if ((state as ManagerAddModuleLocationPermissionSuccessState)
                    .permissionGranted) {
                  _managerAddModuleCubit.getCurrentLocation();
                }
                break;
              case ManagerAddModuleLocationPermissionDeniedForeverState:
                _showPermissionDialog();
                break;
              case ManagerAddModuleLocationServiceDisabledState:
                _showEnableLocationService(context);
                break;
              default:
            }
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case ManagerAddModuleLoadedRoutesState:
                if (_isLoading || _isFirstFetch) {
                  routes.addAll(
                      (state as ManagerAddModuleLoadedRoutesState).routes);
                  _isLoading = false;
                  _isFirstFetch = false;
                  _pageNum = state.nextPage;
                  _totalCount = state.totalCount;
                  _isLastPage = _totalCount <= routes.length;
                }
                break;
              case ManagerAddModuleLocationSuccessState:
                _currentPosition =
                    (state as ManagerAddModuleLocationSuccessState).position;
                _locationLatitudeController.text =
                    _currentPosition?.latitude.toString() ?? '';
                _locationLongitudeController.text =
                    _currentPosition?.longitude.toString() ?? '';

                break;
              default:
            }

            return _buildSuccessState(state);
          },
        ),
        floatingActionButton: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                fixedSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Adicionar Poste'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState(ApplicationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 12,
        ),
        const Text('Caminho'),
        const SizedBox(
          height: 14,
        ),
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<RouteModel>(
              isExpanded: true,
              dropdownSearchData: DropdownSearchData(
                searchInnerWidget: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.all(16))),
                searchInnerWidgetHeight: 100,
                searchController: _searchController,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: MediaQuery.sizeOf(context).height * 0.3,
              ),
              value: _selectedRoute,
              items: routes.isNotEmpty
                  ? routes
                      .map(
                        (route) => DropdownMenuItem<RouteModel>(
                          value: route,
                          child: Text(route.name),
                        ),
                      )
                      .toList()
                  : [],
              onChanged: (value) {
                setState(() {
                  _selectedRoute = value;
                });
              },
            ),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        const Text('Identificação do Poste'),
        const SizedBox(
          height: 14,
        ),
        TextFormField(
          controller: _moduleIdentificationController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(width: 2, color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(width: 2, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        const Text('Nome do Poste'),
        const SizedBox(
          height: 14,
        ),
        TextFormField(
          controller: _moduleNameController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(width: 2, color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(width: 2, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        const Text('Coordenadas'),
        const SizedBox(
          height: 14,
        ),
        ElevatedButton(
          onPressed: () {
            _managerAddModuleCubit.getCurrentLocation();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              fixedSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              )),
          child: state is ManagerAddModuleLocationLoadingState
              ? const CircularProgressIndicator(
                  color: Colors.grey,
                )
              : const Text('Preencher com a minha localização'),
        ),
        const SizedBox(
          height: 14,
        ),
        Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Latitude'),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: _locationLatitudeController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.grey),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Longitude'),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: _locationLongitudeController,
                    decoration: InputDecoration(
                      focusColor: Colors.grey,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.grey),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  _showEnableLocationService(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'To have this functionality, you must enable location service in settings.')));
  }

  _showPermissionDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location permission denied forever'),
          content: const Text(
              'To get location functionality, you must change location permissions in settings.'),
          actions: [
            TextButton(
                onPressed: () async {
                  _managerAddModuleCubit.openAppSettings();
                  if (mounted) {
                    Navigator.of(context).maybePop();
                    _managerAddModuleCubit.getCurrentLocation();
                  }
                },
                child: const Text('Go to settings'))
          ],
        );
      },
    );
  }
}
