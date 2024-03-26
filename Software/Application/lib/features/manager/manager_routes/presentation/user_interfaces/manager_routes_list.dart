import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/components/custom_scaffold.dart';
import 'package:generic_project/core/constants/application_assets.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/cubits/cubit_factory.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/features/manager/manager_routes/presentation/business_components/manager_routes_cubit.dart';

class ManagerRoutesListUI extends StatefulWidget {
  const ManagerRoutesListUI({super.key});

  @override
  State<ManagerRoutesListUI> createState() => _ManagerRoutesListUIState();
}

class _ManagerRoutesListUIState extends State<ManagerRoutesListUI> {
  final _managerRoutesCubit = CubitFactory.managerRoutesCubit;
  List<RouteModel> routes = [];

  final _routesListViewScrollController = ScrollController();

  bool _isLoading = false;
  int _pageNum = 1;
  int _totalCount = 0;
  bool _isFirstFetch = true;
  bool _isLastPage = false;

  static const _pageSize = 10;

  @override
  void initState() {
    _managerRoutesCubit.getRoutes(nextPage: _pageNum, pageSize: _pageSize);
    super.initState();
  }

  @override
  void dispose() {
    _routesListViewScrollController.dispose();
    super.dispose();
  }

  void _routesListViewScrollListener(ScrollController sc) {
    sc.addListener(() {
      var nextPageTrigger = 0.8 * sc.position.maxScrollExtent;
      if (sc.position.pixels > nextPageTrigger) {
        if (!_isLastPage && !_isLoading) {
          _isLoading = true;
          _managerRoutesCubit.getRoutes(
              nextPage: _pageNum, pageSize: _pageSize);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: 'Gestor',
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
        showLeading: null,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.person_outline_rounded,
              color: Colors.black,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 16,
          )
        ],
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Listagem Caminhos'),
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocConsumer<ManagerRoutesCubit, ApplicationState>(
                  bloc: _managerRoutesCubit,
                  builder: (context, state) {
                    switch (state.runtimeType) {
                      case ManagerRoutesLoadingRoutesState:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ManagerRoutesSuccessState:
                        if (_isLoading || _isFirstFetch) {
                          routes.addAll(
                              (state as ManagerRoutesSuccessState).routes);
                          _isLoading = false;
                          _isFirstFetch = false;
                          _pageNum = state.nextPage;
                          _totalCount = state.totalCount;
                          _isLastPage = _totalCount <= routes.length;
                        }
                        break;
                      default:
                    }
                    return _buildState(state);
                  },
                  listener: (context, state) {},
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(16)),
                    onPressed: () {},
                    child: const Text('Criar Novos Caminhos')),
              ),
            )
          ],
        ));
  }

  Widget _buildState(ApplicationState state) {
    if (routes.isEmpty) {
      return Center(
        child: state is ManagerRoutesLoadingRoutesState
            ? const CircularProgressIndicator()
            : const Text('Não há rotas disponiveis'),
      );
    } else {
      _routesListViewScrollListener(_routesListViewScrollController);
      return Expanded(
        child: ListView.separated(
            controller: _routesListViewScrollController,
            itemBuilder: (context, index) {
              final route = routes[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                onTap: () async {},
                leading: Image.asset(ApplicationAssets.routeIcon),
                title: Text(route.name),
                subtitle:
                    Text('Distância - ${route.distance.toStringAsFixed(0)}km'),
                trailing: const Icon(Icons.chevron_right_rounded),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: routes.length),
      );
    }
  }
}
