import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:generic_project/core/constants/application_assets.dart';
import 'package:generic_project/core/constants/application_constants.dart';
import 'package:generic_project/core/utils/decoders/iqar_decoder.dart';
import 'package:generic_project/features/map/presentation/components/drawer_menu_button.dart';
import 'package:generic_project/features/map/presentation/components/map_filters_button.dart';
import 'package:generic_project/core/components/map_options_button.dart';
import 'package:generic_project/core/components/module_icon_button.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/cubits/cubit_factory.dart';
import 'package:generic_project/features/map/presentation/business_components/map_cubit.dart';
import 'package:generic_project/core/enums/routes_filter_type_enum.dart';
import 'package:generic_project/core/data/models/module/module_model.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/core/navigator/application_routes.dart';
import 'package:generic_project/features/map/presentation/components/map_search_bar.dart';
import 'package:generic_project/features/map/presentation/components/module_info_container.dart';
import 'package:generic_project/features/map/presentation/components/town_info_container.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum UserMode {
  technical,
  manager,
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _mapCubit = CubitFactory.mapCubit;
  List<ModuleModel> modules = [];
  Map<String, List<ModuleModel>> modulesGroupedByTown = {};
  List<RouteModel> routes = [];
  List<String> favRoutesIds = [];
  List<Marker> markers = [];
  List<Marker> clusterMarkers = [];
  List<Polyline> polylines = [];

  late Position _currentPosition;
  late StreamSubscription<Position> _positionStream;
  Marker? _userLocationMarker;
  final _mapController = MapController();

  PanelState _panelState = PanelState.CLOSED;
  final PanelController _panelController = PanelController();

  RoutesFilterType? filters;

  ModuleModel? _selectedModule;

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _pageNum = 1;
  int _totalCount = 0;
  bool _isFirstFetch = true;
  bool _isLastPage = false;

  static const _pageSize = 10;

  Timer? _debounce;

  bool shouldCluster = false;

  bool showDetails = false;

  RouteModel? detailedRoute;

  List<ModuleModel> detailedRouteModules = [];

  @override
  void initState() {
    _mapCubit.fetchFavoriteRoutes();
    _getRoutes();
    _requestLocationPermission();
    _listenToPositionChanges();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: Drawer(
        backgroundColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).maybePop();
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      )),
                ),
              ),
              const DrawerMenuButton(buttonText: 'Linguagens App'),
              DrawerMenuButton(
                onPressed: () async {
                  final favRoutes = routes
                      .where((element) => favRoutesIds.contains(element.id))
                      .toList();
                  final bool shouldUpdate = await Navigator.of(context)
                      .pushNamed(ApplicationRoutes.favRoutesScreen,
                          arguments: favRoutes) as bool;

                  if (shouldUpdate && mounted) {
                    _mapCubit.fetchFavoriteRoutes();
                  }
                },
                buttonText: l10n?.mapFiltersFavorites ?? '',
              ),
              DrawerMenuButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(ApplicationRoutes.moreInfoScreen);
                },
                buttonText: 'Mais Informação',
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomLeft,
                child: DrawerMenuButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                        ApplicationRoutes.tecnicianMapScreen);
                  },
                  buttonText: 'Acesso Gestor',
                  fontWeight: FontWeight.w600,
                ),
              ))
            ],
          ),
        ),
      ),
      drawerScrimColor: Colors.transparent,
      body: BlocConsumer<MapCubit, ApplicationState>(
        bloc: _mapCubit,
        listener: (context, state) {
          switch (state.runtimeType) {
            case MapRequestLocationPermissionSuccessState:
              if ((state as MapRequestLocationPermissionSuccessState)
                  .permissionGranted) {
                _mapCubit.getCurrentLocation();
              }
              break;
            case MapRequestLocationPermissionDeniedForeverState:
              _showPermissionDialog();
              break;
            case MapRequestLocationServiceDisabledState:
              _showEnableLocationService(context);
              break;
            case MapModulesErrorState:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error loading route modules'),
                  backgroundColor: Colors.red,
                ),
              );
              break;
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case MapDownloadRouteFileSuccessState:
              final List<LatLng> coords =
                  (state as MapDownloadRouteFileSuccessState)
                      .routeCoordinates
                      .map((e) => LatLng(e['latitude']!, e['longitude']!))
                      .toList();
              polylines.clear();
              polylines.add(
                Polyline(
                  points: coords,
                ),
              );
              _mapController.fitCamera(
                CameraFit.coordinates(
                    coordinates: coords, padding: const EdgeInsets.all(16)),
              );
              break;
            case MapUserLocationChangeState:
              _currentPosition = (state as MapUserLocationChangeState).position;
              _userLocationMarker = Marker(
                  key: const Key('userLocationMarker'),
                  point: LatLng(
                      _currentPosition.latitude, _currentPosition.longitude),
                  child: const Icon(Icons.person_pin));
              break;
            case MapGetModulesBetweenBoundsSuccessState:
              modules =
                  (state as MapGetModulesBetweenBoundsSuccessState).modules;
              _createModuleMarkers();
              _createClusters();
              break;
            case MapModulesSuccessState:
              modules = (state as MapModulesSuccessState).modules;
              markers = modules.map((module) {
                return Marker(
                    point: LatLng(module.idLocation!.latitude,
                        module.idLocation!.longitude),
                    child: ModuleIconButton(
                        markerColor:
                            IQArDecoder.decodeColor(module.iqAr ?? 6) ??
                                Colors.grey,
                        isSelected: (_selectedModule != null &&
                                _selectedModule?.id == module.id) ==
                            true,
                        onClick: () {
                          setState(() {
                            _selectedModule = module;
                          });
                        }));
              }).toList();
              modulesGroupedByTown = groupBy(modules,
                  (ModuleModel module) => module.idLocation!.town ?? '');
              modulesGroupedByTown.removeWhere(
                (key, value) => key == '',
              );
              _animateToRoute(modules);
              break;
            case MapRoutesSuccessState:
              if (_isLoading || _isFirstFetch) {
                routes.addAll((state as MapRoutesSuccessState).routes);
                _isLoading = false;
                _isFirstFetch = false;
                _pageNum = state.nextPage;
                _totalCount = state.totalCount;
                _isLastPage = _totalCount <= routes.length;
              }
              break;
            case MapFetchFavoriteRoutesSuccessState:
              favRoutesIds =
                  (state as MapFetchFavoriteRoutesSuccessState).favRoutes;
              break;
            case MapAddRouteToFavoritesSuccessState:
              favRoutesIds
                  .add((state as MapAddRouteToFavoritesSuccessState).routeId);
              break;
            case MapRemoveRouteFromFavoritesSuccessState:
              favRoutesIds.remove(
                  (state as MapRemoveRouteFromFavoritesSuccessState).routeId);
              break;
            case MapFetchLocationSucessState:
              _updateUserLocation(state);

              break;
            case MapModuleInfoSuccessState:
              _selectedModule = (state as MapModuleInfoSuccessState).module;
              break;

            case MapShowRouteDetailsState:
              showDetails = true;
              detailedRoute = (state as MapShowRouteDetailsState).route;
              detailedRouteModules = state.modules;
              break;

            default:
          }

          return _buildSuccessState(context, state, l10n);
        },
      ),
    );
  }

  _listenToPositionChanges() async {
    _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 10, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    )).listen((Position? position) {
      if (position != null) {
        _mapCubit.onUserLocationChange(position);
        getLocationDetails(position);
      }
    });
  }

  void listenToZoomChanges() async {
    if (_mapController.camera.zoom.floor() < 14) {
      shouldCluster = true;
    } else {
      shouldCluster = false;
    }
  }

  void getLocationDetails(Position position) async {
    var request = await Dio().request(
        ApplicationRequestPaths.reverseGeocodeSearch,
        queryParameters: {
          'format': 'json',
          'lat': position.latitude,
          'lon': position.longitude,
        });
  }

  void _routesListViewScrollListener(ScrollController sc) {
    sc.addListener(() {
      var nextPageTrigger = 0.8 * sc.position.maxScrollExtent;
      if (sc.position.pixels > nextPageTrigger) {
        if (!_isLastPage && !_isLoading) {
          _isLoading = true;
          _mapCubit.getRoutes(
              nextPage: _pageNum, pageSize: _pageSize, filterType: filters);
        }
      }
    });
  }

  _getRoutes() async {
    _mapCubit.getRoutes(nextPage: _pageNum, pageSize: _pageSize);
  }

  _requestLocationPermission() async {
    _mapCubit.requestLocationPermission();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _scrollController.dispose();
    super.dispose();
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
                  _mapCubit.openAppSettings();
                  if (mounted) {
                    Navigator.of(context).maybePop();
                    _mapCubit.getCurrentLocation();
                  }
                },
                child: const Text('Go to settings'))
          ],
        );
      },
    );
  }

  _animateToRoute(List<ModuleModel> modules) {
    _mapController.fitCamera(
      CameraFit.coordinates(
        maxZoom: 16,
        coordinates: modules
            .map((e) => LatLng(e.idLocation!.latitude, e.idLocation!.longitude))
            .toList(),
      ),
    );
  }

  _showEnableLocationService(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'To have this functionality, you must enable location service in settings.')));
  }

  Widget _buildSlidingPanelInfo(
      List<RouteModel> routes, ApplicationState state, ScrollController sc) {
    if (showDetails && detailedRoute != null) {
      final RouteModel route = detailedRoute!;
      final modulesByTown =
          groupBy(detailedRouteModules, (p0) => p0.idLocation!.town);
      return _buildRouteDetails(route, sc, modulesByTown);
    } else {
      _routesListViewScrollListener(sc);

      if (routes.isNotEmpty) {
        return _buildRoutesList(sc, routes);
      } else {
        return Center(
          child: state is MapRoutesLoadingState
              ? const CircularProgressIndicator()
              : const Text('Não há rotas disponiveis'),
        );
      }
    }
  }

  Expanded _buildRoutesList(ScrollController sc, List<RouteModel> routes) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(0),
        separatorBuilder: (context, index) => const Divider(
          thickness: 1,
        ),
        controller: sc,
        itemCount: routes.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == routes.length || routes.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final route = routes[index];
          return ListTile(
            onTap: () {
              /* if (route.filename != null && route.fileVersion != null) {
                  _mapCubit.downloadRouteFile(
                      route.filename!, route.fileVersion!);
                } */

              _mapCubit.showRouteDetails(route);
              _panelController.open();
            },
            leading: Image.asset(ApplicationAssets.routeIcon),
            title: Text(route.name),
            subtitle:
                Text('Distância - ${route.distance.toStringAsFixed(0)}km'),
            trailing: IconButton(
              onPressed: () {
                favRoutesIds.contains(route.id)
                    ? _mapCubit.removeRouteFromFavorites(route.id)
                    : _mapCubit.addRouteToFavorites(route.id);
              },
              icon: favRoutesIds.contains(route.id)
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
            ),
          );
        },
      ),
    );
  }

  Flexible _buildRouteDetails(RouteModel route, ScrollController sc,
      Map<String?, List<ModuleModel>> modulesByTown) {
    return Flexible(
      child: Column(
        children: [
          ListTile(
            leading: GestureDetector(
              onTap: () {
                _mapCubit.getRoutes();
                _panelController.close();
                showDetails = false;
              },
              child: const Icon(
                Icons.chevron_left,
                color: Colors.black,
              ),
            ),
            title: Text(route.name),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Distancia - ${route.distance.toStringAsFixed(0)}km'),
                const SizedBox(
                  width: 32,
                ),
                const Text('14 pessoas')
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                favRoutesIds.contains(route.id)
                    ? _mapCubit.removeRouteFromFavorites(route.id)
                    : _mapCubit.addRouteToFavorites(route.id);
              },
              icon: favRoutesIds.contains(route.id)
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
            ),
            horizontalTitleGap: 0,
          ),
          Expanded(
            child: Scrollbar(
              controller: sc,
              child: ListView.builder(
                itemCount: modulesByTown.keys.length,
                controller: sc,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  if (detailedRouteModules.isEmpty) {
                    return const Center(
                      child: Text('Não há postes nesta rota'),
                    );
                  } else {
                    final townName = modulesByTown.keys.elementAt(index);
                    var townIQAr = 6;
                    for (var module in modulesByTown[townName]!) {
                      if (townIQAr > (module.iqAr ?? 6)) {
                        townIQAr = module.iqAr ?? 6;
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: TownInfoContainer(
                        townIQArColor: IQArDecoder.decodeColor(townIQAr),
                        townName: townName ?? '',
                        numOfModules: modulesByTown[townName]!.length,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _createClusters() {
    modulesGroupedByTown =
        groupBy(modules, (ModuleModel module) => module.idLocation!.town ?? '');
    modulesGroupedByTown.removeWhere(
      (key, value) => key == '',
    );
    clusterMarkers.clear();
    for (var element in modulesGroupedByTown.keys) {
      double totalLatitude = 0.0;
      double totalLongitude = 0.0;
      var clusterIQArValue = 6;
      for (ModuleModel module in modulesGroupedByTown[element]!) {
        totalLatitude += module.idLocation!.latitude;
        totalLongitude += module.idLocation!.longitude;
        if (clusterIQArValue > (module.iqAr ?? 6)) {
          clusterIQArValue = module.iqAr ?? 6;
        }
      }

      double averageLatitude =
          totalLatitude / modulesGroupedByTown[element]!.length;
      double averageLongitude =
          totalLongitude / modulesGroupedByTown[element]!.length;

      clusterMarkers.add(
        Marker(
          rotate: true,
          height: 50,
          width: 75,
          point: LatLng(averageLatitude + 0.0005, averageLongitude),
          child: GestureDetector(
            onTap: () {
              _mapController.move(
                  LatLng(averageLatitude, averageLongitude), 15);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: IQArDecoder.decodeColor(
                    _mapController.camera.zoom < 14 ? clusterIQArValue : 6),
              ),
              child: Center(
                child: Text(
                  element,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  void _createModuleMarkers() {
    markers = modules.map((module) {
      return Marker(
          point:
              LatLng(module.idLocation!.latitude, module.idLocation!.longitude),
          child: ModuleIconButton(
              markerColor:
                  IQArDecoder.decodeColor(module.iqAr ?? 6) ?? Colors.grey,
              isSelected: (_selectedModule != null &&
                      _selectedModule?.id == module.id) ==
                  true,
              onClick: () {
                _mapController.move(
                    LatLng(module.idLocation!.latitude,
                        module.idLocation!.longitude),
                    16);
                setState(() {
                  _selectedModule = module;
                });
              }));
    }).toList();
  }

  void _updateUserLocation(ApplicationState state) {
    _currentPosition = (state as MapFetchLocationSucessState).position;
    _userLocationMarker = Marker(
      key: const Key('userLocationMarker'),
      point: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      child: const Icon(Icons.person_pin),
    );
    _mapController.move(
        LatLng((state).position.latitude, state.position.longitude), 15);
  }

  Widget _buildSuccessState(
      BuildContext context, ApplicationState state, AppLocalizations? l10n) {
    final minPanelSize = MediaQuery.sizeOf(context).height * 0.12;
    final maxPanelSize = MediaQuery.sizeOf(context).height * 0.4;

    return Stack(
      children: [
        FlutterMap(
          key: const Key('userMap'),
          mapController: _mapController,
          options: MapOptions(
            onPositionChanged: (position, hasGesture) {
              listenToZoomChanges();
              if (_debounce != null) {
                _debounce!.cancel();
              }
              _debounce = Timer(
                const Duration(milliseconds: 500),
                () {
                  _mapCubit.getModulesBetweenBounds(
                      minBounds: position.bounds!.southWest,
                      maxBounds: position.bounds!.northEast);
                },
              );
            },
            onTap: (tapPosition, point) {
              if (_selectedModule != null) {
                setState(() {
                  _selectedModule = null;
                });
              }
            },
            initialCenter: const LatLng(51.509364, -0.128928),
            initialZoom: 9.2,
          ),
          children: [
            TileLayer(
              retinaMode: RetinaMode.isHighDensity(context),
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            if (_userLocationMarker != null)
              MarkerLayer(markers: [_userLocationMarker!]),
            Visibility(
              visible: markers.isNotEmpty && !shouldCluster,
              child: MarkerLayer(
                markers: markers,
              ),
            ),
            Visibility(
                visible: clusterMarkers.isNotEmpty,
                child: MarkerLayer(markers: clusterMarkers)),
            PolylineLayer(polylines: polylines)
          ],
        ),
        SlidingUpPanel(
          controller: _panelController,
          backdropEnabled: true,
          minHeight: minPanelSize,
          maxHeight: maxPanelSize,
          defaultPanelState: _panelState,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          backdropOpacity: 0,
          onPanelOpened: () {
            setState(() {
              _panelState = PanelState.OPEN;
            });
          },
          onPanelClosed: () {
            setState(() {
              _panelState = PanelState.CLOSED;
            });
          },
          panelBuilder: (ScrollController sc) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 4,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(3)),
                  ),
                ),
              ),
              _buildSlidingPanelInfo(routes, state, sc),
            ],
          ),
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 86,
                ),
                child: SizedBox(
                  height: 42,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(left: 16),
                            children: [
                              MapOptionsButton(
                                isSelected: filters == RoutesFilterType.iqar,
                                onPressed: () {
                                  _onFiltersButtonPressed(
                                      RoutesFilterType.iqar);
                                },
                                text: l10n?.mapFiltersBetterAirQuality ?? '',
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              MapOptionsButton(
                                isSelected: filters == RoutesFilterType.traffic,
                                onPressed: () {
                                  _onFiltersButtonPressed(
                                      RoutesFilterType.traffic);
                                },
                                text: l10n?.mapFiltersLessTraffic ?? '',
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              MapOptionsButton(
                                  isSelected:
                                      filters == RoutesFilterType.distance,
                                  onPressed: () {
                                    _onFiltersButtonPressed(
                                        RoutesFilterType.distance);
                                  },
                                  text: l10n?.mapFiltersShortestRoute ?? ''),
                              const SizedBox(
                                width: 8,
                              ),
                              MapOptionsButton(
                                isSelected: filters ==
                                    RoutesFilterType.numOfOccurrences,
                                onPressed: () {
                                  _onFiltersButtonPressed(
                                      RoutesFilterType.numOfOccurrences);
                                },
                                text: 'Com menos ocorrências',
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        child: MapSearchBar(
                      builder: (context, p1) {
                        return Container();
                      },
                      onQueryChanged: (query) {},
                    )),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0, right: 8.0),
                      child: MapFiltersButton(
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                bottom: (_panelState == PanelState.CLOSED
                    ? minPanelSize + 16
                    : maxPanelSize + 16),
                right: 16,
                left: 16,
                child: ModuleInfoContainer(
                  module: _selectedModule,
                ),
              ),
              Visibility(
                visible: state is MapModulesLoadingState,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.5)),
                  child: const Center(
                      child: CircularProgressIndicator(color: Colors.grey)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _onFiltersButtonPressed(RoutesFilterType filterType) {
    routes.clear();
    _isFirstFetch = true;
    _pageNum = 1;
    if (filters != filterType) {
      filters = filterType;
      _mapCubit.getRoutes(
          nextPage: _pageNum, pageSize: _pageSize, filterType: filters);
    } else if (filters == filterType) {
      filters = null;
      _mapCubit.getRoutes();
    }
  }
}
