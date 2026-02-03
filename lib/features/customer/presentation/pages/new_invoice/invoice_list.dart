// import 'package:Yadhava/core/constants/color.dart';
// import 'package:Yadhava/features/customer/model/InvoiceModel.dart';
// import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/addItem_model.dart';
// import 'package:Yadhava/features/customer/presentation/pages/new_invoice/selected_item_list.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../../core/widget/custom_snackbar.dart';
// import '../../../data/client_model.dart';
// import '../Invoice_pages/Invoice_page.dart';
// import '../cash_recept/cash_recept.dart';
// import '../customer_details/bloc/add_item_bloc.dart';
//
// class InvoiceList extends StatefulWidget {
//   final ClientModel client;
//   final String fromDate;
//   final String endDate;
//   final int vehicleId;
//   final int companyId;
//   final VoidCallback onOrderSaved;
//   final int? partyId;
//   const InvoiceList(
//       {super.key,
//       required this.client,
//       required this.fromDate,
//       required this.endDate,
//       required this.vehicleId,
//       required this.companyId,
//       required this.onOrderSaved,
//       this.partyId});
//
//   @override
//   State<InvoiceList> createState() => _InvoiceListState();
// }
//
// class _InvoiceListState extends State<InvoiceList> {
//   int itemSelected = 0;
//   String? selectedValue;
//   bool isExpanded = false;
//
//   List<bool> isItemAdded = [];
//   List<Map<String, dynamic>> selectedList = [];
//   List<String> items = ['Invoice', 'cash'];
//   final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
//       GlobalKey<RefreshIndicatorState>();
//    List<ProductItem> details=[];
//
//   @override
//   void initState() {
//     context.read<AddItemBloc>().add(FetchItems());
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // floatingActionButton: Padding(
//       //   padding: const EdgeInsets.only(right: 20.0),
//       //   child: SizedBox(
//       //     width: MediaQuery.sizeOf(context).width * 0.2,
//       //     child: FloatingActionButton(
//       //       backgroundColor: Colour.plightpurple,
//       //       onPressed: () {
//       //         if (selectedList.isEmpty) {
//       //         } else {
//       //           Navigator.push(
//       //               context,
//       //               MaterialPageRoute(
//       //                   builder: (context) =>
//       //                       SelectedItemList(selectedItemList: selectedList)));
//       //         }
//       //       },
//       //       child: const Text(
//       //         "Next",
//       //         style: TextStyle(color: Colour.pWhite),
//       //       ),
//       //     ),
//       //   ),
//       // ),
//
//       floatingActionButton: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (isExpanded) ...[
//             FloatingActionButton.small(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => InvoicePage(
//                       client: widget.client,
//                       partyId: widget.partyId,
//                     ),
//                   ),
//                 );
//                 // buildFloatingActionButton(
//                 //   context: context,
//                 //   client: widget.client,
//                 //   companyId: companyId,
//                 //   endDate: endDate,
//                 //   fromDate: fromDate,
//                 //   vehicleId: vehicleId,
//                 //   onTap: () {
//                 //     _fetchInvoices();
//                 //     refreshIndicatorKey.currentState?.show();
//                 //   },
//                 //   onThen: () {
//                 //     _fetchInvoices();
//                 //   },
//                 // );
//               },
//               child: const Icon(Icons.list_alt),
//               heroTag: "fab1",
//             ),
//             const SizedBox(height: 10),
//             FloatingActionButton.small(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => CashRecept(
//                             clientId: widget.partyId,
//                           )),
//                 );
//                 refreshIndicatorKey.currentState?.show();
//               },
//               child: const Icon(Icons.receipt_long),
//               heroTag: "fab2",
//             ),
//             const SizedBox(height: 10),
//           ],
//           FloatingActionButton(
//             onPressed: () {
//               setState(() {
//                 isExpanded = !isExpanded;
//               });
//             },
//             child: Icon(isExpanded ? Icons.close : Icons.menu),
//             heroTag: "mainFab",
//           ),
//         ],
//       ),
//
//       backgroundColor: Colour.pBackgroundBlack,
//       appBar: AppBar(
//         backgroundColor: Colour.pBackgroundBlack,
//         title: const Text(
//           'Items List',
//           style: TextStyle(color: Colour.pWhite),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const SizedBox(height: 10),
//             Expanded(
//               // child: BlocListener<AddItemBloc, AddItemState>(
//               //   listener: (context, state) {
//               //     if (state is ItemAddedState) {
//               //       ScaffoldMessenger.of(context).showSnackBar(
//               //         SnackBar(
//               //           content: Text(state.message),
//               //           backgroundColor: state.isAlreadyExists ? Colors.red : Colors.green,
//               //           duration: const Duration(seconds: 2),
//               //         ),
//               //       );
//               //     }
//               //   },
//                 child:
//                 BlocBuilder<AddItemBloc, AddItemState>(
//                   builder: (context, state) {
//                     if (state is ItemsFetchedState) {
//                       final items = state.items ?? [];
//                       print(items);
//                       print(items.runtimeType);
//
//                       if (isItemAdded.length != items.length) {
//                         isItemAdded =
//                             List.generate(items.length, (index) => false);
//                       }
//
//                       return ListView.builder(
//                         itemCount: items.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return Card(
//                             color: Colour.blackgery,
//                             margin: const EdgeInsets.symmetric(vertical: 5),
//                             elevation: 4,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: ListTile(
//                               title: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       '${items[index]['productName']}',
//                                       style: const TextStyle(
//                                         color: Colour.mediumGray,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   Text(
//                                     '${items[index]['partNumber']}',
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                       color: Colour.mediumGray,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               subtitle: Row(
//                                 children: [
//                                   Text(
//                                     '₹${items[index]['sellingPrice']}',
//                                     style: const TextStyle(
//                                       color: Colour.SilverGrey,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const Spacer(),
//                                   if (!isItemAdded[index])
//                                     // TextButton(
//                                     //
//                                     //
//                                     //   onPressed: () {
//                                     //     ProductItem item = ProductItem(
//                                     //       fac: items[index]['foc'].text??'0',
//                                     //       srt:items[index]['srt'].text??'0',
//                                     //       productName: items[index]['packingName'] ,
//                                     //       quantity: 1,
//                                     //       sell: items[index]['sellingPrice']??0,
//                                     //       totalRate: items[index]['sellingPrice']??0,
//                                     //       uom:items[index]['uom']??'0' ,
//                                     //       packingDescription:
//                                     //       items[index]['packingDescription']??'',
//                                     //       packingId: items[index]['packingId']!??'' ,
//                                     //       packingName: items[index]['packingName'] ?? '',
//                                     //       partNumber: items[index]['partNumber'] ?? 0,
//                                     //       productId: items[index]['productId'] ?? 0,
//                                     //     );
//                                     //     context.read<AddItemBloc>().add(SubmitAddItem(item: item));
//                                     //
//                                     //     setState(() {
//                                     //       itemSelected++;
//                                     //       isItemAdded[index] = true;
//                                     //
//                                     //       // Check for duplicates correctly
//                                     //       if (!selectedList.any((item) =>
//                                     //           item['partNumber'] ==
//                                     //           items[index]['partNumber'])) {
//                                     //         selectedList.add(items[index]);
//                                     //       }
//                                     //       print(selectedList.length);
//                                     //     });
//                                     //   },
//                                     //   child: const Text(
//                                     //     "Add",
//                                     //     style: TextStyle(color: Colors.green),
//                                     //   ),
//                                     // ),
//                                     TextButton(
//                                       onPressed: () {
//
//
//                                         setState(() {
//                                           itemSelected++;
//                                           isItemAdded[index] = true;
//                                           ProductItem item = ProductItem(
//                                             fac: items[index]['foc']?.toString() ??
//                                                 '0',
//                                             srt: items[index]['srt']?.toString() ??
//                                                 '0',
//                                             productName:
//                                             items[index]['productName'] ?? '',
//                                             quantity: 1,
//                                             sell: items[index]['sellingPrice'].toString() ?? '0',
//                                             totalRate:
//                                             items[index]['sellingPrice']?? '0',
//                                             uom: items[index]['packingName']?? '0',
//                                             packingDescription: items[index]
//                                             ['packingDescription'] ??
//                                                 '',
//                                             packingId:
//                                             items[index]['packingId'] ?? 0,
//                                             packingName:
//                                             items[index]['packingName'] ?? '',
//                                             partNumber:
//                                             items[index]['partNumber'] ?? 0,
//                                             productId:
//                                             items[index]['productId'] ?? 0,
//                                           );
//                                         details.add(item);
//                                         print(details.length);
//                                           // context
//                                           //     .read<AddItemBloc>()
//                                           //     .add(SubmitAddItem(item: item));
//                                           // // ✅ Check for duplicates correctly
//                                           if (!selectedList.any((item) =>
//                                               item['partNumber'] ==
//                                               items[index]['partNumber'])) {
//                                             selectedList.add(items[index]);
//                                           }
//                                           print(selectedList.length);
//                                         });
//                                       },
//                                       child: const Text(
//                                         "Add",
//                                         style: TextStyle(color: Colors.green),
//                                       ),
//                                     ),
//                                   if (isItemAdded[index])
//                                     TextButton(
//                                       onPressed: () {
//                                         // final items = context.read<AddItemBloc>().addedItems;
//
//                                         setState(() {
//                                           itemSelected--;
//                                           isItemAdded[index] = false;
//
//                                           // context
//                                           //     .read<AddItemBloc>()
//                                           //     .add(RemoveItem(item));
//                                           details.removeWhere((item)=>
//                                           item.productId==items[index]['productId']);
//                                           selectedList.removeWhere((item) =>
//                                               item['partNumber'] ==
//                                               items[index]['partNumber']);
//                                         });
//                                         print(selectedList.length);
//                                       },
//                                       child: const Text(
//                                         "Remove",
//                                         style: TextStyle(color: Colors.red),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }
//                    else {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                   },
//                 ),
//               // ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0, top: 15),
//               child: Row(
//                 // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text(
//                     "Items Selected: $itemSelected",
//                     style: const TextStyle(color: Colour.mediumGray),
//                   ),
//                   const SizedBox(
//                     width: 25,
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       if (selectedList.isEmpty) {
//                         showCustomSnackBar(
//                             context,
//                             "Select any Item",
//                             const Icon(
//                               Icons.error,
//                               color: Colors.red,
//                             ));
//                       } else {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SelectedItemList(
//                               // selectedItemList: selectedList,
//                               client: widget.client, details:details,
//                             ),
//                           ),
//                         );
//                       }
//                     },
//                     child: const Text("Next"),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:Yadhava/core/constants/color.dart';
import 'package:Yadhava/features/customer/model/InvoiceModel.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/addItem_model.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/product_master.dart';
import 'package:Yadhava/features/customer/presentation/pages/new_invoice/selected_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widget/custom_snackbar.dart';
import '../../../data/client_model.dart';
import '../../bloc/last_invoice_bloc/lastinvoice_bloc.dart';
import '../Invoice_pages/Invoice_page.dart';
import '../cash_recept/cash_recept.dart';
import '../customer_details/bloc/add_item_bloc.dart';

class InvoiceList extends StatefulWidget {
  final ClientModel client;
  final String fromDate;
  final String endDate;
  final int vehicleId;
  final int companyId;
  final VoidCallback onOrderSaved;
  final int? partyId;
  const InvoiceList(
      {super.key,
      required this.client,
      required this.fromDate,
      required this.endDate,
      required this.vehicleId,
      required this.companyId,
      required this.onOrderSaved,
      this.partyId});

  @override
  State<InvoiceList> createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
  int itemSelected = 0;
  String? selectedValue;
  bool isExpanded = false;

  List<bool> isItemAdded = [];
  List<Map<String, dynamic>> selectedList = [];
  List<String> items = ['Invoice', 'cash'];
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<ProductItem> details = [];
  Set<int> selectedProductIds = {}; // Track selected products by ID
  List<ProductMaster> allItems = [];
  List<ProductMaster> filteredItems = [];
  List<Map<String, dynamic>> lastInvoiceList = [];
  TextEditingController searchController = TextEditingController();
  int lastInvoiceCount=0;
  void filterItems(String query) {
    setState(() {
      filteredItems = allItems
          .where((item) =>
              item.productName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    details.clear();
    context.read<AddItemBloc>().add(FetchItems());
    context
        .read<LastInvoiceBloc>()
        .add(FetchLastInvoice(widget.client.id ?? 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: true,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isExpanded) ...[
            FloatingActionButton.small(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvoicePage(
                      client: widget.client,
                      partyId: widget.partyId,
                    ),
                  ),
                );
              },
              heroTag: "fab1",
               child: const Icon(Icons.list_alt),
            ),
            const SizedBox(height: 10),
            FloatingActionButton.small(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CashRecept(
                            clientId: widget.partyId,
                          )),
                );
                refreshIndicatorKey.currentState?.show();
              },
              heroTag: "fab2",
              child: const Icon(Icons.receipt_long),
            ),
            const SizedBox(height: 10),
          ],
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            heroTag: "mainFab",
            child: Icon(isExpanded ? Icons.close : Icons.menu),
          ),
        ],
      ),

      backgroundColor: Colour.pBackgroundBlack,
      appBar: AppBar(
        backgroundColor: Colour.pBackgroundBlack,
        title: const Text(
          'Items List',
          style: TextStyle(color: Colour.pWhite),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SizedBox(
          height: double.infinity,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 10),
              TextField(
                style: const TextStyle(color: Colour.mediumGray),
                controller: searchController,
                onChanged: filterItems,
                decoration: InputDecoration(
                  hintText: "Search Items...",
                  prefixIcon: const Icon(Icons.search, color: Colour.mediumGray),
                  filled: true,
                  fillColor: Colour.blackgery,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              /// **Dynamically Expanding Last Invoice Items**
              StatefulBuilder(
                builder: (context, setState) {
                  return BlocBuilder<LastInvoiceBloc, LastInvoiceState>(
                    builder: (context, state) {
                      if (state is LastInvoiceLoaded) {
                        final data = state.invoice;
                         lastInvoiceCount=data.length;


                        return AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                                  child:
                                  SizedBox(
                                    height:MediaQuery.of(context).size.height * 0.4,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemCount: details.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final item = details[index];

                                        return Card(
                                          // color: Colour.pContainerLightBlue.withBlue(90),

                                          color: Colour.pContainerLightBlue.withBlue(90),
                                          margin: const EdgeInsets.symmetric(vertical: 3),
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item.productName,
                                                    style: const TextStyle(
                                                      color: Colour.mediumGray,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ), Text(
                                                  '₹${item.partNumber}',
                                                  style: const TextStyle(
                                                    color: Colour.SilverGrey,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Text(
                                                  '₹${item.sell}',
                                                  style: const TextStyle(
                                                    color: Colour.SilverGrey,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const Spacer(),
                                                TextButton(
                                                  onPressed: () {
                                                    details.length==1?showCustomSnackBar(context, "At least one item required", Icon(Icons.error)): setState(() {
                                                      details.removeAt(index);
                                                      itemSelected--;

                                                    });

                                                  },
                                                  child: const Text(
                                                    "Remove",
                                                    style: TextStyle(color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                        );
                      }else if(state is LastInvoiceError){
                        return Center(child: Text("No Invoices"),);
                      }else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                },
              ),

              /// **Other Items List (Moves Up/Down Depending on Expansion)**
              SizedBox(
                height: MediaQuery.of(context).size.height/3.3325,
                child: BlocBuilder<AddItemBloc, AddItemState>(
                  builder: (context, state) {
                    if (state is ItemsFetchedState) {
                      allItems = state.items ?? [];
                      filteredItems = filteredItems.isEmpty ? allItems : filteredItems;

                      if (isItemAdded.length != allItems.length) {
                        isItemAdded = List.generate(allItems.length, (index) => false);
                      }

                      return ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = filteredItems[index];
                          final productId = item.productId;

                          return Card(
                            color: Colour.blackgery,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.productName,
                                      style: const TextStyle(
                                        color: Colour.mediumGray,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.partNumber,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colour.mediumGray,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    item.sellingPrice.toString(),
                                    style: const TextStyle(
                                      color: Colour.SilverGrey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      if (details.any((element) => element.productId == productId)) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Item Already Added"),
                                              content: const Text("This item is already in the list."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("OK"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        setState(() {
                                          selectedProductIds.add(productId);
                                          itemSelected++; // Increment item count

                                          ProductItem selectedItem = ProductItem(
                                            fac: (item.foc as num?)?.toInt() ?? 0,
                                            srt: (item.srt as num?)?.toInt() ?? 0,
                                            productName: item.productName ?? '',
                                            quantity: 1,
                                            sell: item.sellingPrice?.toString() ?? '0',
                                            totalRate: (item.sellingPrice as num?)?.toDouble() ?? 0.0,
                                            uom: item.packingName ?? '',
                                            packingDescription: item.packingDescription ?? '',
                                            packingId: (item.packingId as num?)?.toInt() ?? 0,
                                            packingName: item.packingName ?? '',
                                            partNumber: item.partNumber ?? '',
                                            productId: productId,
                                          );


                                          details.add(selectedItem);
                                        });
                                      }
                                    },
                                    child: const Text("Add", style: TextStyle(color: Colors.green)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Column(
                          //   children: [
                          //     Text(
                          //       "Items Selected: ${itemSelected==0?"updating..":itemSelected  }",
                          //       style: const TextStyle(color: Colour.mediumGray),
                          //     ), Text(
                          //       "Last Invoice Count: ${lastInvoiceCount==0?"updating..":lastInvoiceCount  }",
                          //       style: const TextStyle(color: Colour.mediumGray),
                          //     ),
                          //   ],
                          // ),
                     const  SizedBox(width: 15,),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                if (details.isEmpty) {
                                  showCustomSnackBar(
                                      context,
                                      "Select any Item",
                                      const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ));
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelectedItemList(
                                        client: widget.client,
                                        // details: details,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text("Next",style: TextStyle(color: Colour.pWhite),),
                            ),
                          ),
                        ],
                      ),
                    )

            ],
          ),
        ),

      ),
    );
  }
}
