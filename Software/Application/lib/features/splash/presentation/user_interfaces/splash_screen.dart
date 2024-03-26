import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/features/authentication/presentation/business_components/auth_cubit.dart';

import '../../../../core/cubits/cubit_factory.dart';
import '../../../../core/navigator/application_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authCubit = CubitFactory.authCubit;

  //StreamSubscription<Map>? _branchSub;

  @override
  void initState() {
    //authCubit.checkAuthentication();
    //listenBranchSDKLinks();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        Navigator.of(context).pushReplacementNamed(ApplicationRoutes.mapScreen);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    //_branchSub?.cancel();
    super.dispose();
  }

/*
  void listenBranchSDKLinks() async {
    _branchSub = FlutterBranchSdk.initSession().listen((data) {
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        // This code will execute when a Branch link is clicked
        // Retrieve the link params from 'data' and navigate to the right page
        // Example: Navigator.of(context).pushNamed(data['\$deeplink_path']);
        if (data.containsKey('\$deeplink_path')) {
          if (data['\$deeplink_path'] == branchIOResetPasswordKey &&
              data.containsKey('oobCode')) {
            Navigator.of(context).pushNamed(
                ApplicationRoutes.resetPasswordScreen,
                arguments: data['oobCode']);
          }
        }
        log('Branch link clicked');
      }
    }, onError: (error, stacktrace) {
      log('Branch error: $error');
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, ApplicationState>(
      bloc: authCubit,
      listener: (context, state) {
        /* 
        if (state is AuthAuthenticatedState) {
          // User is authenticated, navigate to the home screen
          Navigator.of(context)
              .pushReplacementNamed(ApplicationRoutes.homeScreen);
        } else if (state is AuthUnauthenticatedState ||
            state is ApplicationApiError) {
          // User is not authenticated, navigate to the login screen
          Navigator.of(context)
              .pushReplacementNamed(ApplicationRoutes.loginScreen);
        } */
      },
      child: const Scaffold(
        backgroundColor: Colors.white, // Set your desired background color
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'AM2R',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
