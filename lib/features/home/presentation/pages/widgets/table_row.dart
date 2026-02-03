//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../../core/constants/color.dart';
// import '../../../../../core/constants/textthemes.dart';
// import '../../../../customer/presentation/pages/customer_view/widget/coustomer_list.dart';
// import '../../bloc/stockList_bloc/stock_list_bloc.dart';
//
// class StockRow extends StatelessWidget {
//   const StockRow({
//     super.key,
//   });
//
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: BlocBuilder<StockListBloc, StockListState>(
//         builder: (context, state) {
//           if (state is StockListLoading) {
//             return indicator();
//           } else if (state is StockListLoaded) {
//             final stockList = state.stockList;
//             if (stockList.isEmpty) {
//               return  Center(
//                 child: Text(
//                   "No Stocks found",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               );
//             }
//
//             return ListView.builder(
//               itemCount: stockList.length,
//               itemBuilder: (context, index) {
//                 final isEven = index % 2 == 0;
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Text(stockList[index].productName, style:  TextStyle(color: Colour.mediumGray, fontWeight: FontWeight.bold)),
//                         Text('${stockList[index].stock}', style: const TextStyle(color: Colour.mediumGray)),
//                         Text(
//                           '\$${stockList[index].sellingPrice}',
//                           style: TextStyle(
//                             color:Colour.SilverGrey ,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//               },
//             );
//           } else if (state is StockListError) {
//             return Center(
//               child: Text(
//                 "Something Went Wrong",
//                 style: TextStyle(color: Colour.pWhite),
//               ),
//             );
//           } else {
//             context.read<StockListBloc>().add(const StockListGetEvent());
//             return const SizedBox.shrink();
//           }
//         },
//       ),
//     );
//   }
//
// }

import 'package:Yadhava/core/util/format_rupees.dart';
import 'package:Yadhava/features/home/data/stockStsModel.dart';
import 'package:Yadhava/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/color.dart';
import '../../../../customer/presentation/pages/customer_view/widget/coustomer_list.dart';
import '../../bloc/stockList_bloc/stock_list_bloc.dart';

class StockRow extends StatelessWidget {
  const StockRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeStateLoading) {
            return indicator();
          } else if (state is HomeStateLoaded) {
            final stockList = state.homeData?.mobileAppStockBalanceVans;
            if (stockList == null) {
              return const Center(
                child: Text(
                  "No Stocks found",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            } else if (stockList.isEmpty) {
              return const Center(
                child: Text(
                  "No Stocks found",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: stockList.length,
                      itemBuilder: (context, index) {
                        ProductStock stockItem = stockList[index];
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text(stockItem.productName,
                                          style: const TextStyle(
                                              color: Colour.mediumGray,
                                              fontWeight: FontWeight.bold))),
                                  Expanded(
                                      child: Text('${stockItem.stock}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colour.mediumGray))),
                                  Expanded(
                                      child: Text('${stockItem.srtQty ?? 0.0}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colour.mediumGray))),
                                  Expanded(
                                      child: Text(
                                          formatRupees(double.parse(stockItem
                                              .sellingPrice
                                              .toString())),
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                              color: Colour.SilverGrey,
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Colors.grey),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is StockListError) {
            return Center(
              child: Text(
                "Something Went Wrong",
                style: TextStyle(color: Colour.pWhite),
              ),
            );
          } else {
            context.read<StockListBloc>().add(const StockListGetEvent());
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
