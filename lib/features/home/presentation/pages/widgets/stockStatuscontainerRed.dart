import 'package:Yadhava/features/customer/presentation/pages/customer_view/widget/coustomer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/color.dart';
import '../../../../../core/constants/textthemes.dart';
import '../../../../../core/util/format_rupees.dart';
import '../../bloc/stockList_bloc/stock_list_bloc.dart';

class StockStatusContainer extends StatelessWidget {
  const StockStatusContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<StockListBloc, StockListState>(
        builder: (context, state) {
          if (state is StockListLoading) {
            return indicator();
          } else if (state is StockListLoaded) {
            final stockList = state.stockList;
            if (stockList.isEmpty) {
              return const Center(
                child: Text(
                  "No Stocks found",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: stockList.length,
              itemBuilder: (context, index) {
                final isEven = index % 2 == 0;
                //
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isEven
                          ? [Colour.pContainerLightMaroon, Colour.pContainerDarkMaroon]
                          : [Colour.pContainerLightBlue, Colour.pContainerDarkBlue],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    // borderRadius: BorderRadius.circular(12),
                    // border: Border.all(color: Colour.blackgery, width: 1),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Card(
                    color: Colors.transparent,
                    // margin:
                    //     const EdgeInsets.symmetric(vertical: 4, ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colour.blackgery, width: 1),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            Colors.green, // You can set dynamic colors
                        child: Text('${stockList[index].stock}',
                          // stockList[index].productName.isNotEmpty
                          //     ? stockList[index].productName.toUpperCase()
                          //     : '?',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                          overflow: TextOverflow.ellipsis,

                        ),
                      ),
                      title: Text(
                        "${stockList[index].productName}",
                        style: AppTextThemes.h5,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Code : ${stockList[index].partNumber}",
                            style: AppTextThemes.h5,
                          ), Text(
                            "Value : ${stockList[index].stockValue}",
                            style: AppTextThemes.h5,
                          ),
                        ],
                      ),
                      trailing: Text(
                          formatRupees(stockList[index].sellingPrice).toString(),
                          style: AppTextThemes.h7
                  // const TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                    ),
                  ),
                );

                // return Padding(
                //   padding: const EdgeInsets.only(bottom: 24),
                //   child: Container(
                //     width: double.infinity,
                //     height: 149,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       gradient: LinearGradient(
                //         colors: isEven
                //             ? [Colour.pContainerLightMaroon, Colour.pContainerDarkMaroon]
                //             : [Colour.pContainerLightBlue, Colour.pContainerDarkBlue],
                //         begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //       ),
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(18),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Text('Name', style: AppTextThemes.h5),
                //               Text('Code : ${stockList[index].partNumber}', style: AppTextThemes.h5),
                //             ],
                //           ),
                //           const SizedBox(height: 4),
                //           Text(stockList[index].productName, style: AppTextThemes.h6),
                //           const SizedBox(height: 16),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text('Quantity', style: AppTextThemes.h5),
                //                   const SizedBox(height: 4),
                //                   ///stock
                //                   Text('${stockList[index].stock} ${stockList[index].packingName}', style: AppTextThemes.h7),
                //                 ],
                //               ),
                //               Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text('Price', style: AppTextThemes.h5),
                //                   const SizedBox(height: 4),
                //                   ///selling price
                //                   Text(formatRupees(stockList[index].sellingPrice).toString(), style: AppTextThemes.h7),
                //                 ],
                //               ),
                //               Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text('Value', style: AppTextThemes.h5),
                //                   const SizedBox(height: 4),
                //                   ///stock value
                //                   Text(stockList[index].stockValue.toString(), style: AppTextThemes.h7),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // );
              },
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
