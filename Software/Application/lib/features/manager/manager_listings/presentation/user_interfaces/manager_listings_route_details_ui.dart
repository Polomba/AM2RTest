import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/components/custom_floating_button.dart';
import 'package:generic_project/core/components/custom_scaffold.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/cubits/cubit_factory.dart';
import 'package:generic_project/core/data/models/module/module_model.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/features/manager/manager_listings/presentation/business_components/manager_listings_cubit.dart';
import 'package:generic_project/features/manager/manager_listings/presentation/components/route_details_list_item.dart';
import 'package:generic_project/features/map/presentation/components/town_info_container.dart';

class ManagerListingsRouteDetailsUI extends StatefulWidget {
  final RouteModel route;
  const ManagerListingsRouteDetailsUI({super.key, required this.route});

  @override
  State<ManagerListingsRouteDetailsUI> createState() =>
      _ManagerListingsRouteDetailsUIState();
}

class _ManagerListingsRouteDetailsUIState
    extends State<ManagerListingsRouteDetailsUI> {
  final ManagerListingsCubit _listingsCubit = CubitFactory.managerListingsCubit;
  List<ModuleModel> detailedRouteModules = [];
  final ScrollController _scrollController = ScrollController();

  Map<String?, List<ModuleModel>> modulesByTown = {};

  @override
  void initState() {
    _listingsCubit.getRouteModules(widget.route.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: const Key('managerListingsRouteDetails'),
      padding: const EdgeInsets.all(0),
      title: 'Listagem Caminhos',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.chevron_left,
                    size: 24,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  widget.route.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          RouteDetailsListItem(
              leftText: 'Distância Total do Percurso',
              rightText: '${widget.route.distance.toStringAsFixed(0)}km'),
          const Divider(
            thickness: 2,
          ),
          const RouteDetailsListItem(
              leftText: 'Pessoas na via', rightText: '12 pessoas'),
          const Divider(
            thickness: 2,
          ),
          const RouteDetailsListItem(
              leftText: 'Número Total de Postes', rightText: '16 postes'),
          const Divider(
            thickness: 2,
          ),
          const RouteDetailsListItem(
              leftText: 'Postes com problemas', rightText: '5 postes'),
          const Divider(
            thickness: 2,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              'Freguesias',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          BlocConsumer<ManagerListingsCubit, ApplicationState>(
            bloc: _listingsCubit,
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              switch (state.runtimeType) {
                case ManagerListingsRouteDetailsModulesSuccessState:
                  modulesByTown = groupBy(
                      detailedRouteModules, (p0) => p0.idLocation!.town);
                  break;
                case ApplicationApiError:
                  return const Center(
                    child: Column(
                      children: [
                        Icon(Icons.warning),
                        Text('Erro ao buscar postes da rota')
                      ],
                    ),
                  );
                default:
              }
              return _buildRouteDetails(
                  widget.route, _scrollController, modulesByTown);
            },
          )
        ],
      ),
      floatingActionButton: CustomFloatingButton(
          onPressed: () {}, isLoading: false, text: 'Adicionar Poste'),
    );
  }

  Widget _buildRouteDetails(RouteModel route, ScrollController sc,
      Map<String?, List<ModuleModel>> modulesByTown) {
    return Expanded(
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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TownInfoContainer(
                  townName: townName ?? '',
                  numOfModules: modulesByTown[townName]!.length,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
