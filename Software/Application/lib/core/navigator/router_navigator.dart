import 'package:flutter/material.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/core/navigator/application_routes.dart';
import 'package:generic_project/features/authentication/presentation/user_interfaces/login_ui.dart';
import 'package:generic_project/features/favorite_routes/presentation/user_interfaces/favorite_routes_ui.dart';
import 'package:generic_project/features/manager/manager_add_module/presentation/user_interfaces/manager_add_module_ui.dart';
import 'package:generic_project/features/manager/manager_invites/presentation/user_interfaces/manager_invites_ui.dart';
import 'package:generic_project/features/manager/manager_listings/presentation/user_interfaces/manager_listings_route_details_ui.dart';
import 'package:generic_project/features/manager/manager_listings/presentation/user_interfaces/manager_listings_ui.dart';
import 'package:generic_project/features/manager/manager_routes/presentation/user_interfaces/manager_routes_list.dart';
import 'package:generic_project/features/manager/manager_routes/presentation/user_interfaces/manager_save_route_ui.dart';
import 'package:generic_project/features/map/presentation/user_interfaces/manager_map_ui.dart';
import 'package:generic_project/features/more_info/presentation/user_interfaces/more_info_ui.dart';
import 'package:generic_project/features/register/presentation/user_interfaces/register_ui.dart';
import 'package:generic_project/features/graphs/presentation/user_interfaces/graph_ui.dart';
import 'package:generic_project/features/home/presentation/user_interfaces/home_ui.dart';
import 'package:generic_project/features/map/presentation/user_interfaces/user_map_ui.dart';

class RouterNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static final RouteObserver<ModalRoute> routeObserver =
      RouteObserver<ModalRoute>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case ApplicationRoutes.loginScreen:
        return MaterialPageRoute(
            builder: (_) => const LoginUI(), settings: settings);
      case ApplicationRoutes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeUI());
      case ApplicationRoutes.registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterUI());
      case ApplicationRoutes.mapScreen:
        return MaterialPageRoute(builder: (_) => const MapPage());
      case ApplicationRoutes.graphsScreen:
        return MaterialPageRoute(builder: (_) => const GraphsPage());
      case ApplicationRoutes.moreInfoScreen:
        return MaterialPageRoute(builder: (_) => const MoreInfoUI());
      case ApplicationRoutes.favRoutesScreen:
        final List<RouteModel> favRoutes = args as List<RouteModel>;
        return MaterialPageRoute(
            builder: (_) => FavoriteRoutesUI(
                  favRoutes: favRoutes,
                ));
      case ApplicationRoutes.tecnicianRoutesScreen:
        return MaterialPageRoute(builder: (_) => const ManagerRoutesListUI());
      case ApplicationRoutes.tecnicianSaveRouteScreen:
        var coordinates = args as List<Map<String, double>>;
        return MaterialPageRoute(
            builder: (_) => ManagerSaveRouteUI(
                  coordinates: coordinates,
                ));
      case ApplicationRoutes.tecnicianMapScreen:
        return MaterialPageRoute(builder: (_) => const ManagerMapPage());
      case ApplicationRoutes.tecnicianAddModule:
        return MaterialPageRoute(builder: (_) => const ManagerAddModuleUI());
      case ApplicationRoutes.managerInvitesScreen:
        final userMode = args as UserMode;
        return MaterialPageRoute(
            builder: (_) => ManagerInvitesUI(userMode: userMode));
      case ApplicationRoutes.managerListingsScreen:
        return MaterialPageRoute(builder: (_) => const ManagerListingsUI());
      case ApplicationRoutes.managerAddModule:
        return MaterialPageRoute(builder: (_) => const ManagerAddModuleUI());
      case ApplicationRoutes.managerListingsRouteDetailsScreen:
        final route = args as RouteModel;
        return MaterialPageRoute(
            builder: (_) => ManagerListingsRouteDetailsUI(
                  route: route,
                ));
      default:
        return MaterialPageRoute(
            builder: (_) => const LoginUI(), settings: settings);
    }
  }
}
