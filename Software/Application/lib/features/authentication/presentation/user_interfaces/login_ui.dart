import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/components/custom_input_field.dart';
import 'package:generic_project/core/components/custom_scaffold.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/cubits/cubit_factory.dart';
import 'package:generic_project/core/navigator/application_routes.dart';
import 'package:generic_project/features/authentication/presentation/business_components/auth_cubit.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _authCubit = CubitFactory.authCubit;

  bool _keepMeLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CustomScaffold(
        title: 'AM2R',
        body: BlocConsumer<AuthCubit, ApplicationState>(
          bloc: _authCubit,
          listener: (context, state) {
            switch (state.runtimeType) {
              case AuthAuthenticatedState:
                log('user authenticated');
                Navigator.of(context)
                    .pushReplacementNamed(ApplicationRoutes.homeScreen);
                break;
              default:
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomInputField(
                                labelText: 'Email',
                                inputController: _emailController,
                                inputFieldType: InputFieldType.email),
                            const SizedBox(
                              height: 16,
                            ),
                            CustomInputField(
                                labelText: 'Password',
                                inputController: _passwordController,
                                inputFieldType: InputFieldType.password),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                  value: _keepMeLoggedIn,
                                  onChanged: (value) {
                                    setState(() {
                                      _keepMeLoggedIn = !_keepMeLoggedIn;
                                    });
                                  },
                                ),
                                const Text('Keep me logged in'),
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _authCubit.loginWithEmailAndPassword(
                                      _keepMeLoggedIn,
                                      _emailController.text,
                                      _passwordController.text);
                                }
                              },
                              child: const Text('Login'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    ApplicationRoutes.registerScreen);
                              },
                              child: const Text('Criar uma conta'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
