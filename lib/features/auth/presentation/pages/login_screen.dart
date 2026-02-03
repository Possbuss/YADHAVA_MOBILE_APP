import 'dart:io';

import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:Yadhava/features/auth/presentation/widgets/custom_dropdown.dart';
import 'package:Yadhava/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:Yadhava/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/color.dart';
import '../../../home/presentation/pages/home_page.dart';
// import '../../../home/presentation/pages/home_screen.dart';

import '../../../splash/data/getall_company_model.dart';
import '../../../splash/domain/repository.dart';
import '../../domain/login_repo.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/route_bloc/route_bloc.dart';
import '../bloc/vehicle_bloc/vehicle_bloc.dart';
import '../widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? selectedRoute;
  String? selectedVehicle;
  String deviceId = "Fetching...";
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GetCompanyListRepo companyListRepo = GetCompanyListRepo();
  GetLoginRepo loginRepo = GetLoginRepo();
  int token = 0;
  int vehiclesId = 0;
  int routeId = 0;
  @override
  void initState() {

    super.initState();
    getDeviceId();

    //context.read<VehicleBloc>().add(GetVehicleList());
    //context.read<RouteBloc>().add(GetRouteEvent());
    //  GetAllCompanyModel? companyModel= companyListRepo.getCompanyListRepo() as GetAllCompanyModel?;
    // token=companyModel!.companyId;
  }

  //Future<int?> getFirstCompanyId() async {
  //  List<GetAllCompanyModel> companies =
  //      await companyListRepo.getStoredCompanyDetails();

  //  if (companies.isNotEmpty) {
  //    return companies.first.companyId;
  //  }
  //  return null;
  //}

  Future<GetAllCompanyModel?> _fetchCompanyData() async{
    var db = LocalDbHelper();
    var companies = await db.getAllCompany();
    if(companies.isNotEmpty){
      return companies.first;
    }
    else{
      return null;
    }
  }

  void onLoginPressed() async {
    final loginBloc = context.read<LoginBloc>(); // Cache context usage early
    // if (selectedRoute == null || selectedVehicle == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Please select both route and vehicle")),
    //   );
    //   return;
    // }
    GetAllCompanyModel? companyData = await _fetchCompanyData();
    final loginData = {
      "companyId": companyData?.companyId,
      "userName": usernameController.text,
      // "vehicleId": vehiclesId,
      // "routeId": routeId,
      "vehicleId": 0,
      "routeId": 0,
      "deviceId": deviceId,
      "userPassword": passwordController.text,
    };
    loginRepo.storeStringValue("USER_PSD", passwordController.text);
    loginBloc.add(LoginButtonPressed(loginData));
    ///print("Selected Route: $selectedRoute");
    //print("Selected Vehicle: $selectedVehicle");
  }

  Future<void> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String id = "Unknown";

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      id = androidInfo.id ?? "Unknown"; // Android ID
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      id = iosInfo.identifierForVendor ?? "Unknown"; // iOS Device ID
    }

    setState(() {
      deviceId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          resizeToAvoidBottomInset: true, // Allow automatic resizing

          backgroundColor: Colour.pBackgroundBlack,
          body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginLoading) {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (state is LoginLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Login successful'),
                ));
                Future.delayed(const Duration(milliseconds: 200), () {

                  if(context.mounted){
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                            (route) => false);
                  }


                });
              } else if (state is LoginError) {
                Navigator.pop(context); // Close loading dialog
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Login Failed"),
                ));
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back! 👋',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Welcome Back, You've been missed!",
                        style: TextStyle(
                          color: Colour.pGray,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomTextFormField(
                        controller: usernameController,
                        label: 'User name',
                        hintText: 'Enter user name',
                        isPassword: false,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: passwordController,
                        label: 'Password',
                        hintText: 'Enter password',
                        isPassword: true,
                      ),
                      // const SizedBox(height: 16),
                      // BlocBuilder<RouteBloc, RouteState>(
                      //   builder: (context, state) {
                      //     if (state is RouteLoading) {
                      //       return const CustomDropdown(
                      //         label: 'Route',
                      //         hint: 'Select Location',
                      //         options: [],
                      //       );
                      //     } else if (state is RouteLoaded) {
                      //       var data = state.route;
                      //       var routeIdList=state.routeIdList;
                      //       // List<String> route=[];
                      //       // for(int i=0;i<data.length;i++){
                      //       //   route.add(data[0].masterName);
                      //       // }
                      //       return CustomDropdown(
                      //         label: 'Route',
                      //         hint: 'Select Location',
                      //         options: data,
                      //         onChanged: (value) async{
                      //           SharedPreferences prefs = await SharedPreferences.getInstance();
                      //          setState(() {
                      //            selectedRoute = value;
                      //            prefs.setString('selected_route', value!);
                      //            int index = data.indexOf(selectedRoute!);
                      //            routeId=routeIdList[index];
                      //            print("Rrrrrrrrrrrrrrrrrrrrrrrr$selectedRoute");
                      //
                      //
                      //          });
                      //         },
                      //       );
                      //     } else if (state is RouteError) {
                      //       return const CustomDropdown(
                      //         label: 'Route',
                      //         hint: 'Select Location',
                      //         options: [],
                      //       );
                      //     } else {
                      //       return const CustomDropdown(
                      //         label: 'Route',
                      //         hint: 'Select Location',
                      //         options: [],
                      //       );
                      //     }
                      //   },
                      // ),
                      //
                      // const SizedBox(height: 16),
                      // BlocBuilder<VehicleBloc, VehicleState>(
                      //   builder: (context, state) {
                      //     if (state is VehicleLoading) {
                      //       return const CustomDropdown(
                      //         label: 'Vehicle',
                      //         hint: 'Loading vehicles...',
                      //         options: [],
                      //       );
                      //     } else if (state is VehicleLoaded) {
                      //       final vehicles = state.vehicles;
                      //       final vehicleId=state.vehicleId;
                      //       print('Vehicles Loaded: $vehicles');
                      //       return CustomDropdown(
                      //         label: 'Vehicle',
                      //         hint: 'Select Vehicle',
                      //         options: vehicles,
                      //         onChanged: (value) async{
                      //            SharedPreferences prefs = await SharedPreferences.getInstance();
                      //            setState(() {
                      //               prefs.setString('selected_vehicle', value!);
                      //            });
                      //
                      //           selectedVehicle = value;
                      //           int index = vehicles.indexOf(selectedVehicle!);
                      //            vehiclesId=vehicleId[index];
                      //         },
                      //       );
                      //     } else if (state is VehicleError) {
                      //       print('Error state: ${state.error}');
                      //       return const CustomDropdown(
                      //         label: 'Vehicle',
                      //         hint: 'Error loading vehicles',
                      //         options: ['No Items'],
                      //       );
                      //     } else {
                      //       return const CustomDropdown(
                      //         label: 'Vehicle',
                      //         hint: 'Select Vehicle',
                      //         options: [],
                      //       );
                      //     }
                      //   },
                      // ),
                      const SizedBox(height: 32),
                      LoginButton(
                        onPressed: onLoginPressed,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
