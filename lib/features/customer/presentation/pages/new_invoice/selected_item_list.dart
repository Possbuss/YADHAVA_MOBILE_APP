import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/addItem_model.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/product_master.dart';
import 'package:Yadhava/features/customer/presentation/pages/new_invoice/widget/item_card.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/color.dart';
import '../../../../../core/constants/textthemes.dart';
import '../../../data/client_model.dart';
import '../../bloc/last_invoice_bloc/lastinvoice_bloc.dart';
import '../Invoice_pages/Invoice_page.dart';
import '../cash_recept/cash_recept.dart';
import '../customer_details/bloc/add_item_bloc.dart';
import '../quotation/quotation_register_page.dart';
import 'invoice_summery.dart';

class SelectedItemList extends StatefulWidget {
  final ClientModel client;
  final int? partyId;

  const SelectedItemList({
    super.key,
    required this.client,
    this.partyId,
  });

  @override
  State<SelectedItemList> createState() => _SelectedItemListState();
}

class _SelectedItemListState extends State<SelectedItemList>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<ProductItem> details = [];
  List<ProductItem> cartItems = [];
  bool add = true;
  late AnimationController _controller;
  double totalAmount = 0;
  double netTotal = 0;
  int lastInvoiceCount = 0;
  List<ProductMaster> allItems = [];
  List<ProductMaster> filteredItems = [];
  List<Map<String, dynamic>> lastInvoiceList = [];
  List<ProductItem> productList = [];
  List<bool> isItemAdded = [];
  Set<int> selectedProductIds = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasRefreshed) {
        _hasRefreshed = true;
        Future.delayed(const Duration(seconds: 1), () {
          _refreshIndicatorKey.currentState?.show();
        });
      }
    });
    context.read<AddItemBloc>().add(FetchItems());
    context
        .read<LastInvoiceBloc>()
        .add(FetchLastInvoice(widget.client.id ?? 0));
    super.initState();
    _controller = AnimationController(vsync: this);
    // _calculateTotalAmount();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _hasRefreshed = false;
  Future<void> _refreshData() async {
    setState(() {
      details.clear(); // If you want to clear first
    });

    try {
      // Call your BLoC or repository to fetch the latest data
      context
          .read<LastInvoiceBloc>()
          .add(FetchLastInvoice(widget.client.id ?? 0));
    } catch (e) {
      print("Refresh error: $e");
    }
  }

  final GlobalKey<DropdownSearchState<String>> dropDownKey =
      GlobalKey<DropdownSearchState<String>>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Items List",
          style: AppTextThemes.appbarHomeHeading,
        ),
        centerTitle: true,
        backgroundColor: Colour.pBackgroundBlack,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                  onPressed: () => _showItemList(context),
                  icon: Icon(
                    Icons.view_list,
                    color: Colors.white,
                  )))
        ],
      ),
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
            FloatingActionButton.small(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuotationRegisterPage(
                      client: widget.client,
                    ),
                  ),
                );
              },
              heroTag: "fabQuotation",
              child: const Icon(Icons.request_quote_outlined),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colour.pBackgroundBlack,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: const Text('Item List',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colour.mediumGray)),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<LastInvoiceBloc, LastInvoiceState>(
              builder: (context, state) {
                if (state is LastInvoiceLoaded) {
                  details = state.invoice;
                  lastInvoiceCount = details.length;
                  if (details.isEmpty) {
                    return Center(
                      child: Text(
                        "Add Items",
                        style: TextStyle(color: Colour.pWhite),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: details.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = details[index];

                        return Dismissible(
                          key: ValueKey(item.partNumber), // Unique key per item
                          direction: DismissDirection.startToEnd, // Swipe right
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            if (details.length == 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('At least one item must remain.')),
                              );
                              return false; // Cancel the dismissal
                            }
                            return true; // Allow the dismissal
                          },
                          onDismissed: (direction) {
                            setState(() {
                              details.removeAt(index);
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('${item.productName} removed')),
                            );
                          },
                          child: ItemCard(
                            totalAmount: item.totalRate,
                            srt: item.srt.toString(),
                            name: item.productName,
                            code: item.partNumber,
                            quantity: item.quantity.toString(),
                            foc: item.fac.toString(),
                            sellingPrice: item.sell,
                            uom: item.uom,
                            productId: item.productId,
                            packingName: item.packingName,
                            packingDescription: item.packingDescription,
                            packingId: item.packingId,
                            onUpdate: (updatedItem) {
                              setState(() {
                                details[index] = updatedItem;
                              });
                            },
                          ),
                        );
                      },
                    );
                  }
                } else if (state is LastInvoiceError) {
                  return Center(
                    child: Text("No Invoices"),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          SafeArea(
            //height: MediaQuery.of(context).size.height * .11,
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0)
                  .copyWith(bottom: 16.0), // const EdgeInsets.only(left: 50),

              child: SizedBox(
                //width: double.infinity,
                width: MediaQuery.of(context).size.width *
                    0.5, // half screen width
                height: 50, // you can adjust height
                child: ElevatedButton(
                  onPressed: () {
                    print("list length${details.length}");
                    double totalamount = 0;
                    int size = details.length;
                    for (int s = 0; s < size; s++) {
                      totalamount += details[s].totalRate;
                    }

                    print("5555555555555555555");
                    print(totalamount);
                    print("5555555555555555555");

                    if (totalamount != 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SummeryPage(
                            selectedItemList: details,
                            client: widget.client,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Total amount is 0'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colour.pWhite, // Change to your brand color
                    foregroundColor: Colors.black, // Text color
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal:
                            32), // EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showItemList(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colour.pWhite,
          title: const Text("Select Item",
              style: TextStyle(color: Colour.blackgery)),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    // Search Field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: "Search items...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              filteredItems = allItems;
                            } else {
                              filteredItems = allItems
                                  .where((item) =>
                                      item.productName
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ??
                                      false)
                                  .toList();
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    Expanded(
                      child: BlocBuilder<AddItemBloc, AddItemState>(
                        builder: (context, state) {
                          if (state is ItemsFetchedState) {
                            allItems = state.items ?? [];

                            if (searchController.text.isEmpty) {
                              filteredItems = allItems;
                            }

                            if (isItemAdded.length != allItems.length) {
                              isItemAdded =
                                  List.generate(allItems.length, (_) => false);
                            }

                            return ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                final productId = item.productId;

                                return Card(
                                  color: Colour.blackgery,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            if (details.any((element) =>
                                                    element.productId ==
                                                    productId) ||
                                                cartItems.any((element) =>
                                                    element.productId ==
                                                    productId)) {
                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text(
                                                      "Item Already Added"),
                                                  content: const Text(
                                                      "This item is already in the cart or list."),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text("OK"),
                                                    )
                                                  ],
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                selectedProductIds
                                                    .add(productId);

                                                ProductItem selectedItem =
                                                    ProductItem(
                                                  fac: (item.foc as num?)
                                                          ?.toInt() ??
                                                      0,
                                                  srt: (item.srt as num?)
                                                          ?.toInt() ??
                                                      0,
                                                  productName:
                                                      item.productName ?? '',
                                                  quantity: 1,
                                                  sell: item.sellingPrice
                                                          ?.toString() ??
                                                      '0',
                                                  totalRate: (item.sellingPrice
                                                              as num?)
                                                          ?.toDouble() ??
                                                      0.0,
                                                  uom: item.packingName ?? '',
                                                  packingDescription:
                                                      item.packingDescription ??
                                                          '',
                                                  packingId:
                                                      (item.packingId as num?)
                                                              ?.toInt() ??
                                                          0,
                                                  packingName:
                                                      item.packingName ?? '',
                                                  partNumber:
                                                      item.partNumber ?? '',
                                                  productId: productId,
                                                );

                                                cartItems.add(selectedItem);
                                              });
                                            }
                                          },
                                          child: cartItems.any((p) =>
                                                  p.productId == productId)
                                              ? const Text("Added",
                                                  style: TextStyle(
                                                      color: Colors.red))
                                              : const Text("Add",
                                                  style: TextStyle(
                                                      color: Colors.green)),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                cartItems.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  details.addAll(cartItems);
                  cartItems.clear();
                  lastInvoiceCount = details.length;
                  Navigator.pop(context);
                });
              },
              child: const Text("Add to Cart"),
            ),
          ],
        );
      },
    );
  }
}
