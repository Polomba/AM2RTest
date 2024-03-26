import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/components/custom_input_field.dart';
import 'package:generic_project/core/components/custom_scaffold.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/cubits/cubit_factory.dart';
import 'package:generic_project/features/register/presentation/business_components/register_cubit.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _registerCubit = CubitFactory.registerCubit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: CustomScaffold(
          showLeading: const BackButton(
            color: Colors.black,
          ),
          title: 'AM2R',
          body: BlocConsumer<RegisterCubit, ApplicationState>(
            bloc: _registerCubit,
            listener: (context, state) {
              switch (state.runtimeType) {
                case RegisterSuccessState:
                  Navigator.of(context).pop();
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
                                labelText: 'Username',
                                inputController: _usernameController,
                                inputFieldType: InputFieldType.username,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              CustomInputField(
                                labelText: 'Email',
                                inputController: _emailController,
                                inputFieldType: InputFieldType.email,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              CustomInputField(
                                labelText: 'Password',
                                inputController: _passwordController,
                                inputFieldType: InputFieldType.password,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              CustomInputField(
                                labelText: 'Phone Number',
                                inputController: _phoneNumberController,
                                inputFieldType: InputFieldType.phoneNumber,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              CustomInputField(
                                labelText: 'Emergency Contact',
                                inputController: _emergencyContactController,
                                inputFieldType: InputFieldType.phoneNumber,
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              state is RegisterLoadingState
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _registerCubit
                                              .registerWithEmailAndPassword(
                                            name: _usernameController.text,
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            emergencyContact:
                                                _emergencyContactController
                                                    .text,
                                            phoneNumber:
                                                _phoneNumberController.text,
                                          );
                                        }
                                      },
                                      child: const Text('Register'),
                                    ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Fazer login'),
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
      ),
    );
  }
}
