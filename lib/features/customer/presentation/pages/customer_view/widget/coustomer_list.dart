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

import 'dart:developer';
import 'package:Yadhava/features/customer/presentation/pages/new_invoice/selected_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/constants/color.dart';
import '../../../../../../core/util/format_rupees.dart';
import '../../../../../auth/data/login_model.dart';
import '../../../../../auth/domain/login_repo.dart';
import '../../../bloc/client_bloc/client_list_bloc.dart';
import '../customer_edit/customer_edit.dart';
import '../customer_statement/customerstatemnt_view.dart';
import 'customer_card.dart';

class CustomerCardList extends StatefulWidget {
  final int companyId;
  final int vehicleId;
  final String fromDate;
  final String toDate;

  const CustomerCardList({
    Key? key,
    required this.companyId,
    required this.vehicleId,
    required this.fromDate,
    required this.toDate,
  }) : super(key: key);

  @override
  _CustomerCardListState createState() => _CustomerCardListState();
}

class _CustomerCardListState extends State<CustomerCardList> {
  @override
  void initState() {
    super.initState();
    //context.read<ClientListBloc>().add(const ClientListGetEvent());
  }

  Future<void> _refreshList() async {
    context.read<ClientListBloc>().add(const ClientListGetEvent());
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
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectedItemList(client: client)));
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectedItemList(
                                    client: client, partyId: client.id!)),
                          ).then((_) {
                            context
                                .read<ClientListBloc>()
                                .add(ClientListGetEvent());
                          });
                        });
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
                            " ${formatRupees(client.amount!.toDouble()) ?? ''}",
                        avatarUrl: client.contactPersonName ?? '',

                        salesManName: client.salesmanName == null ? '${client.clientSortOrder}'
                          : '${client.contactPersonName} [${client.clientSortOrder}]',
                        onTap1: () async {
                          LoginModel? storedResponse =
                              await GetLoginRepo().getUserLoginResponse();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerStatement(
                                      acId: client.id ?? "",
                                      enddate: _getEndDate(),
                                      fromdate: _getFromDate(15),
                                      companyId: storedResponse!.companyId,
                                      client_name:
                                          client.contactPersonName ?? "",
                                    )),
                          );
                        },
                        onTap2: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerEdit(clientModel: client),
                            ),
                          );

                          if (!mounted) return; // ✅ guard context use
                          if (result == true) {
                            context.read<ClientListBloc>().add(ClientListGetEvent());
                          }
                        },
                        onTap3: () async {
                          final String latitude =
                              client.latitude?.toString() ?? "0";
                          final String longitude =
                              client.longitude?.toString() ?? "0";

                          if (latitude.isNotEmpty && longitude.isNotEmpty) {
                            final String googleMapsUrl =
                                "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

                            if (await canLaunch(googleMapsUrl)) {
                              await launch(googleMapsUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Unable to open Google Maps")),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
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
