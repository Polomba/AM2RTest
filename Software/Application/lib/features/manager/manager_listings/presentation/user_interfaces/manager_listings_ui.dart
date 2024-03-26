import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/components/custom_floating_button.dart';
import 'package:generic_project/core/components/custom_scaffold.dart';
import 'package:generic_project/core/constants/application_assets.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/cubits/cubit_factory.dart';
import 'package:generic_project/core/data/models/module/module_model.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/core/navigator/application_routes.dart';
import 'package:generic_project/features/manager/manager_listings/presentation/business_components/manager_listings_cubit.dart';

class ManagerListingsUI extends StatefulWidget {
  const ManagerListingsUI({super.key});

  @override
  State<ManagerListingsUI> createState() => _ManagerListingsUIState();
}

class _ManagerListingsUIState extends State<ManagerListingsUI> {
  int dropdownMenuIndex = 1;
  List<RouteModel> routes = [];
  List<ModuleModel> modules = [];
  final ManagerListingsCubit _listingsCubit = CubitFactory.managerListingsCubit;

  final _listViewScrollController = ScrollController();

  bool _isLoading = false;
  int _pageNum = 1;
  int _totalCount = 0;
  bool _isFirstFetch = true;
  bool _isLastPage = false;

  static const _pageSize = 10;

  @override
  void initState() {
    _listingsCubit.getRoutes(_pageNum, _pageSize);
    super.initState();
  }

  @override
  void dispose() {
    _listViewScrollController.dispose();
    super.dispose();
  }

  void _listViewScrollListener(ScrollController sc) {
    sc.addListener(() {
      var nextPageTrigger = 0.8 * sc.position.maxScrollExtent;
      if (sc.position.pixels > nextPageTrigger) {
        if (!_isLastPage && !_isLoading) {
          _isLoading = true;
          dropdownMenuIndex == 1
              ? _listingsCubit.getRoutes(_pageNum, _pageSize)
              : _listingsCubit.getModules(_pageNum, _pageSize);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        padding: const EdgeInsets.all(0),
        actions: [
          Container(
            padding: const EdgeInsets.only(bottom: 4, right: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Icon(
                Icons.menu,
                color: Colors.black,
                size: 26,
              ),
            ),
          ),
        ],
        title: 'Listagens',
        body: BlocConsumer<ManagerListingsCubit, ApplicationState>(
          bloc: _listingsCubit,
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case ManagerListingsRoutesSuccessState:
                if (_isLoading || _isFirstFetch) {
                  routes.addAll(
                      (state as ManagerListingsRoutesSuccessState).routes);
                  _isLoading = false;
                  _isFirstFetch = false;
                  _pageNum = state.nextPage;
                  _totalCount = state.totalCount;
                  _isLastPage = _totalCount <= routes.length;
                }
                break;
              case ManagerListingsModulesSuccessState:
                if (_isLoading || _isFirstFetch) {
                  modules.addAll(
                      (state as ManagerListingsModulesSuccessState).modules);
                  _isLoading = false;
                  _isFirstFetch = false;
                  _pageNum = state.nextPage;
                  _totalCount = state.totalCount;
                  _isLastPage = _totalCount <= routes.length;
                }
                break;
              default:
            }
            return _buildSuccessState();
          },
        ),
        floatingActionButton: CustomFloatingButton(
            onPressed: () {}, isLoading: false, text: 'Criar Novos Caminhos'));
  }

  Column _buildSuccessState() {
    _listViewScrollListener(_listViewScrollController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<int>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            value: dropdownMenuIndex,
            isExpanded: true,
            elevation: 1,
            items: [
              DropdownMenuItem(
                child: const Text('Caminhos'),
                onTap: () => _listingsCubit.getRoutes(1, _pageSize),
                value: 1,
              ),
              DropdownMenuItem(
                child: const Text('Postes'),
                onTap: () => _listingsCubit.getModules(1, _pageSize),
                value: 2,
              )
            ],
            onChanged: (value) {
              setState(() {
                dropdownMenuIndex = value!;
                print(dropdownMenuIndex);
              });
            },
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
            child: ShaderMask(
          shaderCallback: (Rect rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.white],
              //set stops as par your requirement
              stops: [0.7, 0.85], // 50% transparent, 50% white
            ).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
          child: dropdownMenuIndex == 1
              ? _buildRoutesListView()
              : _buildModulesListView(),
        ))
      ],
    );
  }

  Widget _buildRoutesListView() {
    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(thickness: 2),
        controller: _listViewScrollController,
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final route = routes[index];
          return ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(
                  ApplicationRoutes.managerListingsRouteDetailsScreen,
                  arguments: route);
            },
            leading: (route.totalEvents ?? 0) > 0
                ? Image.asset(
                    ApplicationAssets.routeWithProblemsIcon,
                    height: 40,
                  )
                : Image.asset(
                    ApplicationAssets.routeIcon,
                    height: 40,
                  ),
            title: Text(
              route.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            subtitle: Row(
              children: [
                const Text(
                  '16 postes',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                  visible: (route.totalEvents ?? 0) > 0,
                  child: Text(
                    '${route.totalEvents} com problemas',
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          );
        });
  }

  Widget _buildModulesListView() {
    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(thickness: 2),
        controller: _listViewScrollController,
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return ListTile(
            leading: Image.asset(
              ApplicationAssets.moduleIcon,
              height: 40,
            ),
            title: Text(module.name ?? ''),
            subtitle: Text(
              module.idLocation?.town ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.chevron_right),
          );
        });
  }
}
