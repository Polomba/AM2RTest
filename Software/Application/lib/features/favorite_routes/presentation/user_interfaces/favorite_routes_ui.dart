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
