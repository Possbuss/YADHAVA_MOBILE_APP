import 'dart:developer';

import 'package:Yadhava/features/customer/presentation/pages/customer_view/customer_create/widget/input_text.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_view/customer_create/widget/saveButton.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_view/customer_create/widget/textformfield.dart';
import 'package:Yadhava/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../../core/widget/custom_popup.dart';
import '../../../../../auth/data/login_model.dart';
import '../../../../../auth/domain/login_repo.dart';
import '../../../../data/client_model.dart';
import '../../../bloc/client_bloc/client_list_bloc.dart';
import '../../../bloc/client_create/client_create_bloc.dart';
import '../customer_view.dart';

class CustomerCreate extends StatefulWidget {
  const CustomerCreate({
    super.key,
  });

  @override
  State<CustomerCreate> createState() => _CustomerCreateState();
}

class _CustomerCreateState extends State<CustomerCreate> {
  // Controllers
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  // Form Key
  GetLoginRepo getLoginRepo = GetLoginRepo();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  double lat = 0;
  double lon = 0;

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  Future<void> _getCurrentLocationOld() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("Location permissions are denied");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitudeController.text = position.latitude.toString();
    longitudeController.text = position.longitude.toString();
    lat = double.parse(latitudeController.text) ?? 0;
    lon = double.parse(longitudeController.text) ?? 0;
    log("$lat======================arun");
    log("$lon======================arun");
  }

  Future<void> _getCurrentLocation() async {
    // 1️⃣ Check if location services (GPS) are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 🔔 Opens "Enable Location" screen
      await Geolocator.openLocationSettings();
      return;
    }

    // 2️⃣ Check permission status
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 3️⃣ If permanently denied → open app settings
    if (permission == LocationPermission.deniedForever) {
      // 🔔 Opens App Settings
      await Geolocator.openAppSettings();
      return;
    }

    if (permission == LocationPermission.denied) {
      // User denied again
      return;
    }

    // 4️⃣ Get location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitudeController.text = position.latitude.toString();
    longitudeController.text = position.longitude.toString();

    lat = position.latitude;
    lon = position.longitude;

    log("$lat ====================== arun");
    log("$lon ====================== arun");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Customer"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ClientCreateBloc, ClientCreateState>(
            builder: (context, state) {
              if (state is ClientCreateLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ClientCreateLoaded) {
                _showSuccessMessage(context);
              }
              if (state is ClientCreateError) {
                _showErrorMessage(context, state.msg);
              }
              return _buildForm(context);
            },
          ),
        ),
      ),
    );
  }

  // Build the customer creation form
  Widget _buildForm(BuildContext context) {
    const h20 = SizedBox(height: 20);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          h20,
          const InputLabel(label: "Shop Name"),
          CustomTextFormField(
            hintText: "Enter shop name",
            controller: shopNameController,
            validate: (value) => _validateRequiredField(value, "Shop name"),
          ),
          h20,
          const InputLabel(label: "Contact Person"),
          CustomTextFormField(
            hintText: "Enter contact person name",
            controller: contactPersonController,
            validate: (value) =>
                _validateRequiredField(value, "Contact person name"),
          ),
          h20,
          const InputLabel(label: "Phone"),
          CustomTextFormField(
            hintText: "Enter phone number",
            controller: phoneController,
            validate: _validatePhoneNumber,
          ),
          h20,

          //const InputLabel(label: "ID"),
          //CustomTextFormField(
          //  hintText: "Enter customer Id",
          //  controller: idController,
          //  validate: _validateId,
          //  keyboardType: TextInputType.number,
          //  inputFormatters: [
          //    FilteringTextInputFormatter.digitsOnly,
          //  ],
          //),


          SaveButton(
            onPress: () => _onSavePressed(context),
          ),
        ],
      ),
    );
  }

  // Handle form validation
  String? _validateRequiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return "Enter a valid 10-digit phone number";
    }
    return null;
  }

  String? _validateId(String? value) {
    if (value == null || value.isEmpty) {
      return "Id is required";
    } else if (!RegExp(r'^[0-9]{1,6}$').hasMatch(value)) {
      return "Enter a valid Id (1–6 digits)";
    }
    return null;
  }

  // Handle save button press
  void _onSavePressed(BuildContext context) async {

    if(lat == 0 || lon == 0 || lat == 0.0 || lon == 0.0){
      _getCurrentLocation();
    }
    else{
      LoginModel? loginModel = await getLoginRepo.getUserLoginResponse();
      if (_formKey.currentState?.validate() ?? false) {
        final clientModel = ClientModel(
            name: shopNameController.text,
            contactPersonName: contactPersonController.text,
            mobile: phoneController.text,
            //clientSortOrder: int.parse(idController.text == '' ? "0" : idController.text),
            clientSortOrder: 0,
            transactionYear: 2025,
            amount: 0.0,
            id: 0,
            latitude: lat,
            longitude: lon,
            routeId: loginModel?.routeId,
            companyId: loginModel?.companyId,
            routeName: loginModel!.routeName,
            salesmanId: loginModel!.employeeId,
            salesmanName: loginModel.employeeName);

        // Trigger the Bloc event
        //context.read<ClientCreateBloc>().add(PostClientCreate(clientModel,context.read<ClientListBloc>()));
        // ignore: use_build_context_synchronously
        context
            .read<ClientCreateBloc>()
            .add(PostClientCreate(clientModel));
        // ignore: use_build_context_synchronously

      } else {
        log("Form validation failed");
      }
    }




  }

  // Show success message and navigate back
  void _showSuccessMessage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAutoClosePopupAndNavigate(context);
    });
  }

  Future<void> _showAutoClosePopupAndNavigate(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from closing manually
      builder: (BuildContext context) {
        return const CustomPopup(message: "Created Successfully!");
      },
    );


    // Wait for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Close the popup
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop(); // Close the popup
    }

    if (!context.mounted) return;

    context.read<ClientCreateBloc>().add(ClientResetEvent());
    Navigator.pop(context, true); // Navigate back with result
  }

  // Show error message
  void _showErrorMessage(BuildContext context, String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    });
  }
}