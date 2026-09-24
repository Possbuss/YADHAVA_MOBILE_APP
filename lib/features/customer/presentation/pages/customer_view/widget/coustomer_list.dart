// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:intl/intl.dart';
// //
// // import 'package:url_launcher/url_launcher.dart';
// //
// // import '../../../../../../core/constants/color.dart';
// // import '../../../../../../core/util/format_rupees.dart';
// // import '../../../../../auth/data/login_model.dart';
// // import '../../../../../auth/domain/login_repo.dart';
// // import '../../../bloc/client_bloc/client_list_bloc.dart';
// // import '../../Invoice_pages/Invoice_page.dart';
// // import '../customer_edit/customer_edit.dart';
// // import '../customer_statement/customerstatemnt_view.dart';
// // import 'customer_card.dart';
// //
// // Widget customerCardList() {
// //   return Expanded(
// //     child: BlocBuilder<ClientListBloc, ClientListState>(
// //       builder: (context, state) {
// //         if (state is ClientListLoading || state is ClientListSearchLoading) {
// //           return indicator();
// //         } else if (state is ClientListLoaded) {
// //           final clientList = state.clientList;
// //
// //           if (clientList.isEmpty) {
// //             return const Center(
// //               child: Text(
// //                 "No customers found",
// //                 style: TextStyle(color: Colors.white, fontSize: 16),
// //               ),
// //             );
// //           }
// //
// //           return ListView.builder(
// //             itemCount: clientList.length,
// //             padding: const EdgeInsets.only(bottom: 10),
// //             itemBuilder: (context, index) {
// //               final client = clientList[index];
// //
// //               if (!state.locations.containsKey(index.toString()) &&
// //                   client.latitude != null &&
// //                   client.longitude != null &&
// //                   client.latitude != 0.0 &&
// //                   client.longitude != 0.0) {
// //
// //                 context.read<ClientListBloc>().add(FetchClientLocationEvent(
// //                       clientId: index.toString(),
// //                       latitude: client.latitude!.toDouble(),
// //                       longitude: client.longitude!.toDouble(),
// //                     ));
// //               } else {
// //               }
// //
// //               return GestureDetector(
// //                 onTap: () => Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context) => InvoicePage(
// //                         partyId: client.id!,
// //                         client: client,
// //                       ),
// //                     )), //InvoicePage
// //                 child: CustomerCard(
// //                   name: client.contactPersonName ?? "",
// //                   phoneNumber: client.mobile ?? "",
// //                   hotelName: client.name ?? "",
// //                   location: state.locations[index.toString()] ??
// //                       "Location not found",
// //                   currentBalance:
// //                       " ${formatRupees(client.amount!.toDouble()) ?? ''}",
// //                   avatarUrl: client.contactPersonName ?? "",
// //                   onTap1: () async {
// //                     LoginModel? storedResponse =
// //                         await GetLoginRepo().getUserLoginResponse();
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                           builder: (context) => CustomerStatement(
// //                                 acId: client.id ?? "",
// //                                 enddate: _getEndDate(),
// //                                 fromdate: _getFromDate(30),
// //                                 companyId: storedResponse!.companyId,
// //                                 client_name: client.contactPersonName ?? "",
// //                               )), //amount pdf
// //                     );
// //                   },
// //                   onTap2: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => CustomerEdit(clientModel: client),
// //                       ),
// //                     );
// //                   },
// //                   onTap3: () async {
// //                     final String latitude = client.latitude?.toString() ?? "0";
// //                     final String longitude =
// //                         client.longitude?.toString() ?? "0";
// //
// //                     if (latitude.isNotEmpty && longitude.isNotEmpty) {
// //                       final String googleMapsUrl =
// //                           "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
// //
// //                       if (await canLaunch(googleMapsUrl)) {
// //                         await launch(googleMapsUrl);
// //                       } else {
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           const SnackBar(
// //                               content: Text("Unable to open Google Maps")),
// //                         );
// //                       }
// //                     } else {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(content: Text("Invalid coordinates")),
// //                       );
// //                     }
// //                   },
// //                 ),
// //               );
// //             },
// //           );
// //         } else if (state is ClientListError) {
// //           return Center(
// //             child: Text("Something Went Wrong",style: TextStyle(color: Colour.pWhite),),
// //           );
// //         } else {
// //           context.read<ClientListBloc>().add(const ClientListGetEvent());
// //           return const SizedBox.shrink();
// //         }
// //       },
// //     ),
// //   );
// // }
// //
// // String _getEndDate() {
// //   DateTime now = DateTime.now();
// //   return DateFormat('yyyy-MM-dd').format(now);
// // }
// //
// // String _getFromDate(int daysAgo) {
// //   DateTime now = DateTime.now();
// //   DateTime fromDate = now.subtract(Duration(days: daysAgo));
// //   return DateFormat('yyyy-MM-dd').format(fromDate);
// // }
// //
// // Widget indicator() {
// //   return const Center(
// //     child: CircularProgressIndicator(
// //       color: Colors.white,
// //     ),
// //   );
// // }
//
// import 'dart:developer';
//
// import 'package:Yadhava/features/customer/presentation/pages/customer_details/detail_page.dart';
// import 'package:Yadhava/features/customer/presentation/pages/new_invoice/invoice_list.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../../../../core/constants/color.dart';
// import '../../../../../../core/util/format_rupees.dart';
// import '../../../../../auth/data/login_model.dart';
// import '../../../../../auth/domain/login_repo.dart';
// import '../../../bloc/client_bloc/client_list_bloc.dart';
// import '../../Invoice_pages/Invoice_page.dart';
// import '../customer_edit/customer_edit.dart';
// import '../customer_statement/customerstatemnt_view.dart';
// import 'customer_card.dart';
//
// // Widget customerCardList(context) {
// //   return Expanded(
// //     child: RefreshIndicator(
// //       onRefresh: () async {
// //         BlocProvider.of<ClientListBloc>(context).add(const ClientListGetEvent());
// //       },
// //       child: BlocBuilder<ClientListBloc, ClientListState>(
// //         builder: (context, state) {
// //           if (state is ClientListLoading || state is ClientListSearchLoading) {
// //             return indicator();
// //           } else if (state is ClientListLoaded) {
// //             final clientList = state.clientList;
// //
// //             if (clientList.isEmpty) {
// //               return const Center(
// //                 child: Text(
// //                   "No customers found",
// //                   style: TextStyle(color: Colors.white, fontSize: 16),
// //                 ),
// //               );
// //             }
// //
// //             return ListView.builder(
// //               itemCount: clientList.length,
// //               padding: const EdgeInsets.only(bottom: 10),
// //               itemBuilder: (context, index) {
// //                 final client = clientList[index];
// //
// //                 if (!state.locations.containsKey(index.toString()) &&
// //                     client.latitude != null &&
// //                     client.longitude != null &&
// //                     client.latitude != 0.0 &&
// //                     client.longitude != 0.0) {
// //                   context.read<ClientListBloc>().add(FetchClientLocationEvent(
// //                         clientId: index.toString(),
// //                         latitude: client.latitude!.toDouble(),
// //                         longitude: client.longitude!.toDouble(),
// //                       ));
// //                 }
// //
// //                 return GestureDetector(
// //                   onTap: () => Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => InvoicePage(
// //                           partyId: client.id!,
// //                           client: client,
// //                         ),
// //                       )), //InvoicePage
// //                   child: CustomerCard(
// //                     name: client.contactPersonName ?? "",
// //                     phoneNumber: client.mobile ?? "",
// //                     hotelName: client.name ?? "",
// //                     location: "${state.locations[index.toString()] ??""}${client.routeName??""}",
// //                     currentBalance:
// //                         " ${formatRupees(client.amount!.toDouble()) ?? ''}",
// //                     avatarUrl: client.contactPersonName ?? "",
// //                     salesManName:client.salesmanName ?? '',
// //                     onTap1: () async {
// //                       LoginModel? storedResponse =
// //                           await GetLoginRepo().getUserLoginResponse();
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                             builder: (context) => CustomerStatement(
// //                                   acId: client.id ?? "",
// //                                   enddate: _getEndDate(),
// //                                   fromdate: _getFromDate(30),
// //                                   companyId: storedResponse!.companyId,
// //                                   client_name: client.contactPersonName ?? "",
// //                                 )), //amount pdf
// //                       );
// //                     },
// //                     onTap2: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) =>
// //                               CustomerEdit(clientModel: client),
// //                         ),
// //                       );
// //                     },
// //                     onTap3: () async {
// //                       final String latitude =
// //                           client.latitude?.toString() ?? "0";
// //                       final String longitude =
// //                           client.longitude?.toString() ?? "0";
// //
// //                       if (latitude.isNotEmpty && longitude.isNotEmpty) {
// //                         final String googleMapsUrl =
// //                             "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
// //
// //                         if (await canLaunch(googleMapsUrl)) {
// //                           await launch(googleMapsUrl);
// //                         } else {
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             const SnackBar(
// //                                 content: Text("Unable to open Google Maps")),
// //                           );
// //                         }
// //                       } else {
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           const SnackBar(content: Text("Invalid coordinates")),
// //                         );
// //                       }
// //                     },
// //                   ),
// //                 );
// //               },
// //             );
// //           } else if (state is ClientListError) {
// //             return const Center(
// //               child: Text("Something Went Wrong",
// //                   style: TextStyle(color: Colour.pWhite)),
// //             );
// //           } else {
// //             context.read<ClientListBloc>().add(const ClientListGetEvent());
// //             return const SizedBox.shrink();
// //           }
// //         },
// //       ),
// //     ),
// //   );
// // }
//
// Widget customerCardList(BuildContext context, int companyId, int vehicleId, String fromDate, String toDate  ) {
//   return Expanded(
//     child: BlocListener<ClientListBloc, ClientListState>(
//       listenWhen: (previous, current) {
//         return current is ClientListLoaded; // Only listen when new data is loaded
//       },
//       listener: (context, state) {
//         if (state is ClientListLoaded) {
//           log("Customer List Loaded");
//         }
//       },
//       child: RefreshIndicator(
//         onRefresh: () async {
//           context.read<ClientListBloc>().add(const ClientListGetEvent());
//         },
//         child: BlocBuilder<ClientListBloc, ClientListState>(
//           builder: (context, state) {
//             if (state is ClientListLoading || state is ClientListSearchLoading) {
//               return indicator();
//             } else if (state is ClientListLoaded) {
//               final clientList = state.clientList;
//
//               if (clientList.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     "No customers found",
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 );
//               }
//
//               return ListView.builder(
//                 itemCount: clientList.length,
//                 padding: const EdgeInsets.only(bottom: 10),
//                 itemBuilder: (context, index) {
//                   final client = clientList[index];
//
//                   if (!state.locations.containsKey(client.id.toString()) &&
//                       client.latitude != null &&
//                       client.longitude != null &&
//                       client.latitude != 0.0 &&
//                       client.longitude != 0.0) {
//                     context.read<ClientListBloc>().add(FetchClientLocationEvent(
//                       clientId: client.id.toString(),
//                       latitude: client.latitude!.toDouble(),
//                       longitude: client.longitude!.toDouble(),
//                     ));
//                   }
//
//                   return GestureDetector(
//                     onTap: () =>   Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>InvoiceList(client: client, fromDate: fromDate, endDate: toDate, vehicleId: vehicleId, companyId: companyId, onOrderSaved: () {  },partyId: clientList[index].id,)
//
//                           //     CustomerDetails(
//                           //   client: client, onOrderSaved: () {  }, fromDate:fromDate, endDate: toDate, vehicleId: vehicleId, companyId: companyId,partyId: clientList[index].id,
//                           // ),
//                         )
//                     ),
//                     //     Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //       builder: (context) => InvoicePage(
//                     //         partyId: client.id!,
//                     //         client: client,
//                     //       ),
//                     //     )
//                     // ),
//                     child: CustomerCard(
//                       name: client.contactPersonName ?? "",
//                       phoneNumber: client.mobile ?? "",
//                       hotelName: client.name ?? "",
//                       location: "${state.locations[client.id.toString()] ?? ""}${client.routeName ?? ""}",
//                       currentBalance: " ${formatRupees(client.amount!.toDouble()) ?? ''}",
//                       avatarUrl: client.contactPersonName ?? "",
//                       salesManName: client.salesmanName ?? '',
//                       onTap1: () async {
//                         LoginModel? storedResponse =
//                         await GetLoginRepo().getUserLoginResponse();
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => CustomerStatement(
//                                 acId: client.id ?? "",
//                                 enddate: _getEndDate(),
//                                 fromdate: _getFromDate(30),
//                                 companyId: storedResponse!.companyId,
//                                 client_name: client.contactPersonName ?? "",
//                               )),
//                         );
//                       },
//                       onTap2: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 CustomerEdit(clientModel: client),
//                           ),
//                         );
//                       },
//                       onTap3: () async {
//                         final String latitude =
//                             client.latitude?.toString() ?? "0";
//                         final String longitude =
//                             client.longitude?.toString() ?? "0";
//
//                         if (latitude.isNotEmpty && longitude.isNotEmpty) {
//                           final String googleMapsUrl =
//                               "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
//
//                           if (await canLaunch(googleMapsUrl)) {
//                             await launch(googleMapsUrl);
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text("Unable to open Google Maps")),
//                             );
//                           }
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Invalid coordinates")),
//                           );
//                         }
//                       },
//                     ),
//                   );
//                 },
//               );
//             } else if (state is ClientListError) {
//               return const Center(
//                 child: Text("Something Went Wrong",
//                     style: TextStyle(color: Colour.pWhite)),
//               );
//             } else {
//               context.read<ClientListBloc>().add(const ClientListGetEvent());
//               return const SizedBox.shrink();
//             }
//           },
//         ),
//       ),
//     ),
//   );
// }
//
//
// String _getEndDate() {
//   DateTime now = DateTime.now();
//   return DateFormat('yyyy-MM-dd').format(now);
// }
//
// String _getFromDate(int daysAgo) {
//   DateTime now = DateTime.now();
//   DateTime fromDate = now.subtract(Duration(days: daysAgo));
//   return DateFormat('yyyy-MM-dd').format(fromDate);
// }
//
// Widget indicator() {
//   return const Center(
//     child: CircularProgressIndicator(
//       color: Colors.white,
//     ),
//   );
// }

import 'dart:io';
import 'dart:developer';

import 'package:Yadhava/core/constants/api_constants.dart';
import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:Yadhava/features/customer/presentation/pages/new_invoice/selected_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/constants/color.dart';
import '../../../../../../core/util/format_rupees.dart';
import '../../../../../auth/data/login_model.dart';
import '../../../../../auth/domain/login_repo.dart';
import '../../../bloc/client_bloc/client_list_bloc.dart';
import '../../../../data/client_model.dart';
import '../../../../domain/client_profile_picture_repo.dart';
import '../customer_edit/customer_edit.dart';
import '../customer_statement/customerstatemnt_view.dart';
import 'customer_card.dart';

class CustomerCardList extends StatefulWidget {
  final int companyId;
  final int vehicleId;
  final String fromDate;
  final String toDate;

  const CustomerCardList({
    super.key,
    required this.companyId,
    required this.vehicleId,
    required this.fromDate,
    required this.toDate,
  });

  @override
  State<CustomerCardList> createState() => _CustomerCardListState();
}

class _CustomerCardListState extends State<CustomerCardList> {
  final ImagePicker _imagePicker = ImagePicker();
  final ClientProfilePictureRepo _clientProfilePictureRepo =
      ClientProfilePictureRepo();
  final LocalDbHelper _localDbHelper = LocalDbHelper();
  final Set<int> _uploadingClientIds = <int>{};
  final Map<int, String> _localProfileImagePaths = <int, String>{};
  final Map<int, String> _remoteProfileImageUrls = <int, String>{};

  @override
  void initState() {
    super.initState();
    _loadSavedProfileImages();
  }

  Future<void> _refreshList() async {
    context.read<ClientListBloc>().add(const ClientListGetEvent());
    await _loadSavedProfileImages();
  }

  Future<void> _loadSavedProfileImages() async {
    final Map<int, String> savedPaths =
        await _localDbHelper.getClientLocalProfileImagePaths();
    final Map<int, String> existingPaths = <int, String>{};

    for (final entry in savedPaths.entries) {
      if (await File(entry.value).exists()) {
        existingPaths[entry.key] = entry.value;
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _localProfileImagePaths
        ..clear()
        ..addAll(existingPaths);
    });
  }

  Future<void> _openProfilePictureOptions(ClientModel client) async {
    if (client.id == null || client.companyId == null) {
      _showMessage('Client details are incomplete for image upload.');
      return;
    }

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Open Camera'),
                  onTap: () =>
                      Navigator.of(sheetContext).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Choose From Gallery'),
                  onTap: () =>
                      Navigator.of(sheetContext).pop(ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null || !mounted) {
      return;
    }

    final XFile? pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1600,
      maxHeight: 1600,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedFile == null || !mounted) {
      return;
    }

    await _uploadProfilePicture(client, pickedFile);
  }

  Future<void> _showProfilePreview(ClientModel client) async {
    final String profileImageUrl = _profileImageFor(client);
    final bool isLocalImage = _isLocalProfileImage(client);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ),
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white24, width: 3),
                  ),
                  child: ClipOval(
                    child: _buildProfilePreviewImage(
                      imagePath: profileImageUrl,
                      isLocalImage: isLocalImage,
                      avatarText: client.contactPersonName ?? '',
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  client.name?.isNotEmpty == true
                      ? client.name!
                      : (client.contactPersonName ?? 'Client'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if ((client.contactPersonName ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    client.contactPersonName!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      _openProfilePictureOptions(client);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff703BF7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Picture'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _uploadProfilePicture(ClientModel client, XFile file) async {
    final int? clientId = client.id;
    final int? companyId = client.companyId;
    if (clientId == null || companyId == null) {
      _showMessage('Client details are incomplete for image upload.');
      return;
    }

    final String savedLocalPath =
        await _saveProfileImageLocally(clientId: clientId, file: file);

    await _localDbHelper.saveClientProfileImage(
      clientId: clientId,
      localProfileImagePath: savedLocalPath,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _uploadingClientIds.add(clientId);
      _localProfileImagePaths[clientId] = savedLocalPath;
    });

    try {
      final result = await _clientProfilePictureRepo.uploadProfilePicture(
        companyId: companyId,
        clientId: clientId,
        file: file,
      );

      if (!mounted) {
        return;
      }

      if (result.profilePicUrl != null && result.profilePicUrl!.isNotEmpty) {
        _remoteProfileImageUrls[clientId] = result.profilePicUrl!;
        await _localDbHelper.saveClientProfileImage(
          clientId: clientId,
          localProfileImagePath: savedLocalPath,
          profilePicUrl: result.profilePicUrl,
        );
      }

      _showMessage('Client picture uploaded successfully.');
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage('Failed to upload client picture: $error');
    } finally {
      if (mounted) {
        setState(() {
          _uploadingClientIds.remove(clientId);
        });
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _profileImageFor(ClientModel client) {
    final int? clientId = client.id;
    if (clientId != null) {
      final String? localPath = _localProfileImagePaths[clientId];
      if (localPath != null && localPath.isNotEmpty) {
        return localPath;
      }

      final String? remotePath = _remoteProfileImageUrls[clientId];
      if (remotePath != null && remotePath.isNotEmpty) {
        return _resolveProfileImageUrl(remotePath);
      }
    }

    final String? persistedLocalPath = client.localProfileImagePath;
    if (persistedLocalPath != null && persistedLocalPath.isNotEmpty) {
      return persistedLocalPath;
    }

    return _resolveProfileImageUrl(client.profilePicUrl ?? '');
  }

  bool _isLocalProfileImage(ClientModel client) {
    final int? clientId = client.id;
    if (clientId == null) {
      return false;
    }

    final String? localPath = _localProfileImagePaths[clientId];
    if (localPath != null && localPath.isNotEmpty) {
      return true;
    }

    final String? persistedLocalPath = client.localProfileImagePath;
    return persistedLocalPath != null && persistedLocalPath.isNotEmpty;
  }

  Future<String> _saveProfileImageLocally({
    required int clientId,
    required XFile file,
  }) async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final Directory profileDirectory = Directory(
      path.join(appDirectory.path, 'client_profile_images'),
    );
    if (!await profileDirectory.exists()) {
      await profileDirectory.create(recursive: true);
    }

    final String extension = path.extension(file.path).isNotEmpty
        ? path.extension(file.path)
        : '.jpg';
    final String targetPath = path.join(
      profileDirectory.path,
      'client_$clientId$extension',
    );
    final File targetFile = File(targetPath);

    if (await targetFile.exists()) {
      await targetFile.delete();
    }

    await File(file.path).copy(targetPath);
    return targetPath;
  }

  Widget _buildProfilePreviewImage({
    required String imagePath,
    required bool isLocalImage,
    required String avatarText,
  }) {
    if (imagePath.isEmpty) {
      return _buildProfilePreviewFallback(avatarText);
    }

    if (isLocalImage) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildProfilePreviewFallback(avatarText),
      );
    }

    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildProfilePreviewFallback(avatarText),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const Center(
          child: CircularProgressIndicator(color: Color(0xff703BF7)),
        );
      },
    );
  }

  Widget _buildProfilePreviewFallback(String avatarText) {
    return Container(
      color: const Color(0xFFF4F1FF),
      alignment: Alignment.center,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'No Image',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4B2BBE),
          ),
        ),
      ),
    );
  }

  String _resolveProfileImageUrl(String path) {
    final String trimmed = path.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    final Uri? uri = Uri.tryParse(trimmed);
    if (uri != null && uri.hasScheme) {
      return trimmed;
    }

    final Uri baseUri = Uri.parse(ApiConstants.baseUrl);
    final String origin = '${baseUri.scheme}://${baseUri.host}'
        '${baseUri.hasPort ? ':${baseUri.port}' : ''}';

    if (trimmed.startsWith('/')) {
      return '$origin$trimmed';
    }

    final String normalizedBase = ApiConstants.baseUrl.endsWith('/')
        ? ApiConstants.baseUrl
        : '${ApiConstants.baseUrl}/';
    return '$normalizedBase$trimmed';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //context.read<ClientListBloc>().add(ClientListGetEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocListener<ClientListBloc, ClientListState>(
        listenWhen: (previous, current) => current is ClientListLoaded,
        listener: (context, state) {
          if (state is ClientListLoaded) {
            log("Customer List Loaded");
          }
        },
        child: RefreshIndicator(
          onRefresh: _refreshList,
          child: BlocBuilder<ClientListBloc, ClientListState>(
            builder: (context, state) {
              if (state is ClientListLoading ||
                  state is ClientListSearchLoading) {
                return indicator();
              } else if (state is ClientListLoaded) {
                final clientList = state.clientList;

                if (clientList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No customers found",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: clientList.length,
                  padding: const EdgeInsets.only(bottom: 10),
                  itemBuilder: (context, index) {
                    final client = clientList[index];

                    if (!state.locations.containsKey(client.id.toString()) &&
                        client.latitude != null &&
                        client.longitude != null &&
                        client.latitude != 0.0 &&
                        client.longitude != 0.0) {
                      context
                          .read<ClientListBloc>()
                          .add(FetchClientLocationEvent(
                            clientId: client.id.toString(),
                            latitude: client.latitude!.toDouble(),
                            longitude: client.longitude!.toDouble(),
                          ));
                    }

                    return GestureDetector(
                      onTap: () async {
                        final clientListBloc = context.read<ClientListBloc>();
                        final navigator = Navigator.of(context);
                        await Future.delayed(const Duration(seconds: 1));
                        if (!mounted) return;

                        await navigator.push(
                          MaterialPageRoute(
                            builder: (context) => SelectedItemList(
                              client: client,
                              partyId: client.id!,
                            ),
                          ),
                        );

                        if (!mounted) return;
                        clientListBloc.add(const ClientListGetEvent());
                      },
                      child: CustomerCard(
                        name: client.name ?? "",
                        sortOrder: client.clientSortOrder,
                        phoneNumber: client.mobile ?? "",
                        hotelName: client.contactPersonName ?? "",
                        createdDate: client.createdDate ?? "",
                        isActive: client.isActive ?? "",
                        latitude: client.latitude,
                        longitude: client.longitude,

                        /// both is interchanged but label not changed
                        // name: client.contactPersonName ?? "",
                        // hotelName: client.name ?? "",
                        location:
                            "${state.locations[client.id.toString()] ?? ""}${client.routeName ?? ""}",
                        currentBalance:
                            " ${formatRupees(client.amount!.toDouble())}",
                        avatarUrl: client.contactPersonName ?? '',
                        profileImageUrl: _profileImageFor(client),
                        profileImageIsLocal: _isLocalProfileImage(client),
                        isUploadingImage: client.id != null &&
                            _uploadingClientIds.contains(client.id),
                        salesManName: client.salesmanName == null
                            ? '${client.clientSortOrder}'
                            : '${client.contactPersonName} [${client.clientSortOrder}]',
                        onTap1: () async {
                          final navigator = Navigator.of(context);
                          LoginModel? storedResponse =
                              await GetLoginRepo().getUserLoginResponse();
                          if (!mounted || storedResponse == null) return;

                          navigator.push(
                            MaterialPageRoute(
                                builder: (context) => CustomerStatement(
                                      acId: client.id ?? "",
                                      enddate: _getEndDate(),
                                      fromdate: _getFromDate(15),
                                      companyId: storedResponse.companyId,
                                      clientName:
                                          client.contactPersonName ?? "",
                                    )),
                          );
                        },
                        onTap2: () async {
                          final clientListBloc = context.read<ClientListBloc>();
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomerEdit(clientModel: client),
                            ),
                          );

                          if (!mounted) return; // ✅ guard context use
                          if (result == true) {
                            clientListBloc.add(const ClientListGetEvent());
                          }
                        },
                        onProfileTap: () => _showProfilePreview(client),
                        onTap3: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final String latitude =
                              client.latitude?.toString() ?? "0";
                          final String longitude =
                              client.longitude?.toString() ?? "0";

                          if (latitude.isNotEmpty && longitude.isNotEmpty) {
                            final Uri googleMapsUri = Uri.parse(
                              "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
                            );

                            if (await canLaunchUrl(googleMapsUri)) {
                              await launchUrl(googleMapsUri);
                            } else {
                              if (!mounted) return;
                              messenger.showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Unable to open Google Maps")),
                              );
                            }
                          } else {
                            if (!mounted) return;
                            messenger.showSnackBar(
                              const SnackBar(
                                  content: Text("Invalid coordinates")),
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              } else if (state is ClientListError) {
                return const Center(
                  child: Text("Something Went Wrong",
                      style: TextStyle(color: Colour.pWhite)),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

String _getEndDate() {
  DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
}

String _getFromDate(int daysAgo) {
  DateTime now = DateTime.now();
  DateTime fromDate = now.subtract(Duration(days: daysAgo));
  return DateFormat('yyyy-MM-dd').format(fromDate);
}

Widget indicator() {
  return const Center(
    child: CircularProgressIndicator(
      color: Colors.white,
    ),
  );
}
