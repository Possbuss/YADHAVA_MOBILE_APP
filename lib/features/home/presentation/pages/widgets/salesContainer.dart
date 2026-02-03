import 'dart:developer';

import 'package:Yadhava/features/auth/data/login_model.dart';
import 'package:Yadhava/features/auth/domain/login_repo.dart';
import 'package:Yadhava/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/constants/color.dart';
import '../../../../../core/constants/textthemes.dart';
import '../../../../../core/util/format_rupees.dart';
import '../../../../customer/presentation/pages/customer_view/widget/coustomer_list.dart';
import '../../bloc/totalSales_bloc/bloc/total_sales_bloc.dart';

class SalesContainer extends StatelessWidget {
  const SalesContainer({super.key});

  Future<Map<String, dynamic>> getStoredUserData() async {
    GetLoginRepo loginRepo = GetLoginRepo();
    LoginModel? storedResponse = await loginRepo.getUserLoginResponse();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return {
      'branchName': storedResponse!.vehicleName ?? "N/A",
      'routeName': storedResponse!.routeName ?? "N/A",
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeStateLoading) {
          return indicator();
        }

        if (state is HomeStateLoaded) {
          final totalSales = state.homeData?.mobileAppSalesDashBoard;
          double totalSaleAmount = 0.0;
          double totalCollectionAmount = 0.0;
          double receipt = 0.0;
          double cash = 0.0;
          double credit = 0.0;
          double bank = 0.0;
          int length = totalSales!.length;

          for (var sale in totalSales) {
            switch (sale.payType) {
              case 'CASH':
                cash += sale.amount;
                totalCollectionAmount += sale.amount;
                break;
              case 'BANK':
                bank += sale.amount;
                totalCollectionAmount += sale.amount;
                break;
              case 'RECEIPT':
                receipt += sale.amount;
                totalCollectionAmount += sale.amount;
                break;
              case 'CREDIT':
                credit += sale.amount;
                break;
              case 'SALE':
                totalSaleAmount += sale.amount;
                break;
            }
          }

          print(cash);
          print(bank);
          print(credit);
          print("**********************");
          log(totalSales.toString());

          if (totalSales.isEmpty) {
            return FutureBuilder<Map<String, dynamic>>(
              future: getStoredUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return indicator();
                }

                if (snapshot.hasData) {
                  final storedData = snapshot.data!;
                  return _buildSalesContainer(
                      collectionAmount: 0,
                      salesAmount: 0,
                      branchName: storedData['branchName'],
                      routeName: storedData['routeName'],
                      cash: cash,
                      bank: bank,
                      credit: credit,
                      receipt: receipt);
                } else {
                  return const Center(
                    child: Text(
                      "No data found",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                }
              },
            );
          }

          return _buildSalesContainer(
              salesAmount: totalSaleAmount,
              collectionAmount: totalCollectionAmount,
              branchName: totalSales.first.branchName,
              routeName: totalSales.first.routeName,
              cash: cash,
              bank: bank,
              credit: credit,
              receipt: receipt);
        }

        if (state is TotalSalesListError) {
          return const Center(
            child: Text(
              "Something Went Wrong",
              style: TextStyle(color: Colour.pWhite),
            ),
          );
        }

        context.read<TotalSalesBloc>().add(const TotalSalesGetEvent());
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSalesContainer(
      {required double salesAmount,
      required double collectionAmount,
      required String branchName,
      required String routeName,
      required double cash,
      required double receipt,
      required double bank,
      required double credit}) {
    print('cash');
    print(cash);

    return Container(
      width: double.infinity,
      //height: 158,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/icon/BACKGROUND 2.png'),
        ),
        color: Colour.blackgery,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 26, right: 20, top: 20, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Sales', style: AppTextThemes.h4),
                    SizedBox(
                      width: 8,
                    ),
                    Text(formatRupees(salesAmount).toString(),
                        style: AppTextThemes.h3),
                  ],
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Text('Collection', style: AppTextThemes.h4),
                    SizedBox(
                      width: 8,
                    ),
                    Text(formatRupees(collectionAmount).toString(),
                        style: AppTextThemes.h3),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text('Vehicle Number: $branchName', style: AppTextThemes.h5),
            Text('Route: $routeName', style: AppTextThemes.h5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cash", style: AppTextThemes.h5),
                      //Text(cash.toString(), style: AppTextThemes.h5),
                      Text(formatRupees(cash).toString(),
                          style: AppTextThemes.h5_1),
                    ],
                  ),
                ),
                _verticalDivider(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bank", style: AppTextThemes.h5),
                      //Text(cash.toString(), style: AppTextThemes.h5),
                      Text(formatRupees(bank).toString(),
                          style: AppTextThemes.h5_1)
                    ],
                  ),
                ),
                _verticalDivider(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Receipt", style: AppTextThemes.h5),
                      //Text(cash.toString(), style: AppTextThemes.h5),
                      Text(formatRupees(receipt).toString(),
                          style: AppTextThemes.h5_1)
                    ],
                  ),
                ),
                _verticalDivider(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Credit", style: AppTextThemes.h5),
                      //Text(cash.toString(), style: AppTextThemes.h5),
                      Text(formatRupees(credit).toString(),
                          style: AppTextThemes.h5_1)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _verticalDivider() {
  return Container(
    height: 40, // Adjust height as needed
    width: 1,
    color: Color.fromARGB(255, 255, 255, 255),
    margin: const EdgeInsets.symmetric(horizontal: 8),
  );
}
