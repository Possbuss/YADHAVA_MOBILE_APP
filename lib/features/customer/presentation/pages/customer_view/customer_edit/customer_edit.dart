import 'package:Yadhava/features/customer/presentation/pages/customer_view/customer_create/widget/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../auth/data/login_model.dart';
import '../../../../../auth/domain/login_repo.dart';
import '../../../../data/client_model.dart';
import '../../../bloc/client_bloc/client_list_bloc.dart';
import '../../../bloc/client_update/client_update_bloc.dart';
import '../customer_create/widget/input_text.dart';
import '../customer_create/widget/saveButton.dart';

class CustomerEdit extends StatefulWidget {
  final ClientModel clientModel;
  const CustomerEdit({super.key, required this.clientModel});

  @override
  State<CustomerEdit> createState() => _CustomerEditState();
}

class _CustomerEditState extends State<CustomerEdit> {
  // Controllers
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  double lat = 0;
  double lon = 0;

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GetLoginRepo getLoginRepo = GetLoginRepo();

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

    //log("$lat ====================== arun");
    //log("$lon ====================== arun");
  }

  @override
  Widget build(BuildContext context) {
    shopNameController.text = widget.clientModel.name ?? "";
    contactPersonController.text = widget.clientModel.contactPersonName ?? "";
    phoneController.text = widget.clientModel.mobile ?? "";
    idController.text = widget.clientModel.clientSortOrder.toString() ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Customer"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<ClientUpdateBloc, ClientUpdateState>(
              builder: (context, state) {
                if (state is ClientUpdateLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ClientUpdateLoaded) {
                  _showSuccessMessage(context);
                }
                if (state is ClientUpdateError) {
                  _showErrorMessage(context, state.msg);
                }
                return _buildForm(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  // Build the customer creation form
  Widget _buildForm(BuildContext context) {
    const h20 = SizedBox(height: 20);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        h20,
        const InputLabel(label: "Shop Name"),
        CustomTextFormField(
          hintText: "Enter shop name",
          controller: shopNameController,
        ),
        h20,
        const InputLabel(label: "Contact Person"),
        CustomTextFormField(
          hintText: "Enter contact person name",
          controller: contactPersonController,
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
        //h20,
        SaveButton(
          onPress: () => _onSavePressed(context),
        ),
      ],
    );
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
            //clientSortOrder: int.parse(idController.text == '' ? "0" : idController.text),
            clientSortOrder : 0,
            mobile: phoneController.text,
            transactionYear: 2025,
            id: widget.clientModel.id,
            latitude: lat,
            longitude: lon,
            routeId: loginModel?.routeId,
            companyId: loginModel?.companyId,
            routeName: widget.clientModel.routeName,
            salesmanId: widget.clientModel.salesmanId,
            salesmanName: widget.clientModel.salesmanName);

        // Trigger the Bloc event
        context
            .read<ClientUpdateBloc>()
            .add(UpdateClient(clientModel));

      } else {
        print("Form validation failed");
      }

    }
  }

  // Show success message and navigate back
  void _showSuccessMessage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer updated successfully!")),
      );
      context.read<ClientUpdateBloc>().add(ClientUpdateResetEvent());
      Navigator.pop(context,true); // Navigate back
    });
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
