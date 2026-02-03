import 'package:Yadhava/core/util/format_rupees.dart';
import 'package:Yadhava/features/home/presentation/bloc/cash_credit_summery/cash_credit_summery_bloc.dart';
import 'package:Yadhava/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/color.dart';
import '../../../../customer/presentation/pages/customer_view/widget/coustomer_list.dart';
import '../../bloc/stockList_bloc/stock_list_bloc.dart';

class cashCreditTableRow extends StatelessWidget {
  const cashCreditTableRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeStateLoading) {
            return indicator();
          } else if (state is HomeStateLoaded) {
            final cashList =
                state.homeData?.salesInvoiceCollectionCreditCashCustomerImports;
            if (cashList == null) {
              return const Center(
                child: Text(
                  "No records found",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            } else if (cashList.isEmpty) {
              return const Center(
                child: Text(
                  "No records found",
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
                      itemCount: cashList.length,
                      itemBuilder: (context, index) {
                        final cashItem = cashList[index];
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text(cashItem.customerName,
                                          style: const TextStyle(
                                              color: Colour.mediumGray,
                                              fontWeight: FontWeight.bold))),
                                  Expanded(
                                      child: Text(
                                          formatRupees(double.parse(
                                              cashItem.debit.toString())),
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                              color: Colour.SilverGrey,
                                              fontWeight: FontWeight.bold))),
                                  Expanded(
                                      child: Text(
                                          formatRupees(double.parse(
                                              cashItem.credit.toString())),
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
          } else if (state is CashCreditSummeryError) {
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
