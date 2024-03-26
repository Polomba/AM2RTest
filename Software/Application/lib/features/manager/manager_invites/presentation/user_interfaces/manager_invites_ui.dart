import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:generic_project/core/components/custom_scaffold.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/features/map/presentation/user_interfaces/user_map_ui.dart';

class ManagerInvitesUI extends StatefulWidget {
  final UserMode userMode;
  const ManagerInvitesUI({super.key, required this.userMode});

  @override
  State<ManagerInvitesUI> createState() => _ManagerInvitesUIState();
}

class _ManagerInvitesUIState extends State<ManagerInvitesUI> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  RouteModel? _selectedRoute;

  List<RouteModel> routes = [];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title:
          'Criar ${widget.userMode == UserMode.technical ? 'Técnico' : 'Gestor'}',
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        )
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'E-mail',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'E-mail',
              suffixIcon: Icon(Icons.edit),
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
          Visibility(
            visible: widget.userMode == UserMode.technical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Caminhos com acesso',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 56,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<RouteModel>(
                      isExpanded: true,
                      hint: Text('Selecionar Caminho'),
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
              ],
            ),
          )
        ],
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
            child: const Text(
              'Enviar Convite',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
