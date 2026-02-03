import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/color.dart';
import '../../../../../core/constants/textthemes.dart';
import '../../../../auth/domain/logout_repo.dart';
import '../../../../customer/presentation/pages/customer_details/bloc/add_item_bloc.dart';
// update with actual path
import 'alertBox.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final sufixicon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool? obscureText;

  HomeAppBar({
    super.key,
    required this.userName,
    this.controller,
    this.validator,
    this.keyboardType,
    this.focusNode,
    this.obscureText,
    this.sufixicon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddItemBloc, AddItemState>(
      listener: (context, state) {
        if (state is SyncingSalesInvoices) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is SalesInvoicesSynced) {
          Navigator.of(context).pop(); // Close the dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sales invoices synced successfully")),
          );
        } else if (state is SalesInvoicesSyncError) {
          Navigator.of(context).pop(); // Close the dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Sync failed: ${state.error}")),
          );
        }
      },
      child: AppBar(
        backgroundColor: Colour.pBackgroundBlack,
        automaticallyImplyLeading: false,
        elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                // Logout Button
                IconButton(
                  onPressed: () {
                    alertBox(
                      context: context,
                      title: "LogOut",
                      content: Text(
                        "Are You Sure To LogOut?",
                        textAlign: TextAlign.center,
                        style: AppTextThemes.h7,
                      ),
                      leftBtnName: "No",
                      rightBtnName: "Yes",
                      leftBtnTap: () => Navigator.pop(context),
                      rightBtnTap: () {
                        Navigator.pop(context);
                        Logoutrepo().logout(context);
                      },
                    );
                  },
                  icon: Icon(
                    size: 30,
                    Icons.logout_outlined,
                    color: Colour.mediumGray2,
                  ),
                ),


                // Sync Button
                IconButton(
                  onPressed: () {
                    alertBox(
                      context: context,
                      title: "Sync Data",
                      content: Text(
                        "Are you sure you want to sync data?",
                        textAlign: TextAlign.center,
                        style: AppTextThemes.h7,
                      ),
                      leftBtnName: "No",
                      rightBtnName: "Yes",
                      leftBtnTap: () => Navigator.pop(context),
                      rightBtnTap: () {
                        Navigator.pop(context);
                        context.read<AddItemBloc>().add(SyncInvoices());
                      },
                    );
                  },
                  icon: Icon(
                    size: 30,
                    Icons.refresh_outlined,
                    color: Colour.mediumGray2,
                  ),
                )
              ],
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yadhava',
                style: AppTextThemes.homeappbarHomeHeading,
              ),
              Text(
                userName,
                style: AppTextThemes.homeAppbarHomeSubtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
