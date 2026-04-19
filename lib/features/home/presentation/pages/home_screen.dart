//import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:Yadhava/features/auth/data/login_model.dart';
import 'package:Yadhava/features/auth/domain/login_repo.dart';
import 'package:Yadhava/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/cashCreditTableRow.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/HomeAppbar.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/cashCreditTableHeader.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/cashTableHeader.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/cashTableRow.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/creditTableHearder.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/creditTableRow.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/salesContainer.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/sales_header.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/sales_row.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/table_header.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/table_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/color.dart';
import '../../../../core/constants/textthemes.dart';
import '../../../../core/util/local_db_helper.dart';
import '../../../customer/presentation/bloc/inovice_bloc/invoice_bloc.dart';
import '../../../customer/presentation/bloc/last_invoice_bloc/lastinvoice_bloc.dart';
import '../../../customer/presentation/pages/customer_details/bloc/add_item_bloc.dart';
import '../../../customer/data/client_model.dart';
import '../../../customer/presentation/pages/customer_view/active_client_view.dart';
import '../../../customer/presentation/pages/customer_view/inactive_client_view.dart';
import '../../../customer/presentation/pages/quotation/quotation_register_page.dart';
import '../../../customer/presentation/pages/customer_view/route_map/route_map_page.dart';
import '../../../profile/data/mobile_app_user_profile.dart';
import '../../../profile/domain/mobile_app_user_profile_repo.dart';
import '../../../profile/presentation/pages/edit_profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  int vehicleId = 0;
  int companyId = 0;
  int driverId = 0;
  int routeId = 0;
  int activeCount = 0;
  int inactiveCount = 0;
  String profileImagePath = '';
  String profileImageValue = '';

  final GetLoginRepo loginRepo = GetLoginRepo();
  final MobileAppUserProfileRepo _profileRepo = MobileAppUserProfileRepo();
  @override
  initState() {
    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-dd").format(now).toUpperCase();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await getLoginResponse()) {
        await _loadClientCounts();
        await _loadStoredProfile();
        if (!mounted) return;

        context.read<HomeBloc>().add(HomeGetEvent(formattedDate));
        context.read<LastInvoiceBloc>().add(FetchLastInvoice(0));
        context.read<AddItemBloc>().add(FetchProductMaster());

        context
            .read<InvoiceBloc>()
            .add(FetchInvoiceAllEvent(companyId: companyId, routeId: routeId));

        context.read<LastInvoiceBloc>().add(SyncLastInvoices(0));
      }
    });
    // getLoginResponse();
    // context.read<TotalSalesBloc>().add(const TotalSalesGetEvent());
    //  context.read<StockListBloc>().add(const StockListGetEvent());
  }

  Future<void> _loadClientCounts() async {
    final db = LocalDbHelper();
    final active = await db.countActiveClients(routeId);
    final inactive = await db.countInActiveClients(routeId);
    if (!mounted) return;
    setState(() {
      activeCount = active;
      inactiveCount = inactive;
    });
  }

  Future<bool> getLoginResponse() async {
    LoginModel? response = await loginRepo.getUserLoginResponse();
    if (response == null) {
      return false;
    }
    if (!mounted) {
      return false;
    }
    setState(() {
      userName = response.userName;
      vehicleId = response.vehicleId;
      driverId = response.driverId;
      companyId = response.companyId;
      routeId = response.routeId;
    });

    return true;
  }

  Future<void> _loadStoredProfile() async {
    final MobileAppUserProfile? profile = await _profileRepo.getProfile();
    if (!mounted || profile == null) {
      return;
    }

    setState(() {
      userName = profile.name.isNotEmpty ? profile.name : profile.userName;
      profileImagePath = profile.localImagePath;
      profileImageValue = profile.employeeImage;
    });
  }

  Future<void> _openEditProfile() async {
    final MobileAppUserProfile? profile = await _profileRepo.getProfile();
    if (!mounted || profile == null) {
      return;
    }

    Navigator.pop(context);
    final MobileAppUserProfile? updatedProfile =
        await Navigator.push<MobileAppUserProfile>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(initialProfile: profile),
      ),
    );

    if (!mounted || updatedProfile == null) {
      return;
    }

    setState(() {
      userName = updatedProfile.name.isNotEmpty
          ? updatedProfile.name
          : updatedProfile.userName;
      profileImagePath = updatedProfile.localImagePath;
      profileImageValue = updatedProfile.employeeImage;
    });
  }

  ImageProvider<Object>? _profileImageProvider() {
    if (profileImagePath.isNotEmpty) {
      return FileImage(File(profileImagePath));
    }

    final Uint8List? bytes = _tryDecodeBase64Image(profileImageValue);
    if (bytes != null) {
      return MemoryImage(bytes);
    }

    final String imageUrl = _resolveImageUrl(profileImageValue);
    if (imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    }

    return null;
  }

  Uint8List? _tryDecodeBase64Image(String value) {
    if (value.trim().isEmpty) {
      return null;
    }

    final String normalizedValue =
        value.contains(',') ? value.substring(value.indexOf(',') + 1) : value;

    try {
      return base64Decode(normalizedValue);
    } catch (_) {
      return null;
    }
  }

  String _resolveImageUrl(String value) {
    final String trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return '';
    }

    if (trimmedValue.startsWith('http://') ||
        trimmedValue.startsWith('https://')) {
      return trimmedValue;
    }

    final String normalizedBaseUrl = ApiConstants.baseUrl.endsWith('/')
        ? ApiConstants.baseUrl
        : '${ApiConstants.baseUrl}/';
    final String normalizedPath =
        trimmedValue.startsWith('/') ? trimmedValue.substring(1) : trimmedValue;
    return '$normalizedBaseUrl$normalizedPath';
  }

  Future<void> _openHelpSite() async {
    final Uri helpUri = Uri.parse('https://www.posbuss.com');
    if (!await launchUrl(helpUri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open help website.')),
      );
    }
  }

  Future<void> _openSalesOrders() async {
    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuotationRegisterPage(
          client: ClientModel(
            companyId: companyId,
            id: 0,
            name: 'All Customers',
            contactPersonName: 'All Customers',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object>? profileImageProvider = _profileImageProvider();

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: HomeAppBar(
          userName: userName,
        ),
        drawer: Drawer(
          backgroundColor: Colour.pContainerBlack,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
                  decoration:
                      const BoxDecoration(color: Colour.pContainerBlack),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: _openEditProfile,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              backgroundImage: profileImageProvider,
                              child: profileImageProvider == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 35,
                                      color: Colors.blueAccent,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Welcome back!",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: _openEditProfile,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.12),
                                ),
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.alt_route, color: Colors.white),
                  title: const Text(
                    "Client Route Map",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RouteMapPage(),
                      ),
                    );
                  },
                ),

                // 📊 Customer Summary
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Customer Summary",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: const Text(
                    "Active Customers",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    activeCount.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context); // close drawer
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ActiveClientListScreen(),
                      ),
                    );
                    await _loadClientCounts();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel, color: Colors.orange),
                  title: const Text(
                    "Inactive Customers",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    inactiveCount.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context); // close drawer
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InActiveClientListScreen(),
                      ),
                    );
                    await _loadClientCounts();
                  },
                ),

                const Divider(color: Colors.white54),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Sales",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.request_quote_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Sales Orders",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: _openSalesOrders,
                ),

                // 🔄 Sync Clients Button (disabled for now)
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                //   child: ElevatedButton.icon(
                //     onPressed: () async {
                //       // TODO: implement your sync logic
                //       // await syncClients();
                //       ScaffoldMessenger.of(context).showSnackBar(
                //
                //         const SnackBar(content: Text('Syncing clients...')),
                //       );
                //     },
                //     icon: const Icon(Icons.sync, size: 22),
                //     label: const Text(
                //       "Sync Clients",
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w600,
                //         letterSpacing: 0.5,
                //       ),
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.blueAccent,
                //       foregroundColor: Colors.white,
                //       minimumSize: const Size(double.infinity, 50),
                //       elevation: 4,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       shadowColor: Colors.blueAccent.withOpacity(0.4),
                //     ),
                //   ),
                // ),

                const Spacer(), // ✅ Pushes logout to the bottom

                // 🚪 Logout
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: handle logout
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: Colors.white),
                  title: const Text(
                    "Help",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _openHelpSite();
                  },
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              const SalesContainer(),
              // Text(
              //   'Stock Status',
              //   style: AppTextThemes.h4,
              // ),
              // const StockTableHeader(),
              // const StockRow()
              // const SizedBox(height: 8),

              TabBar(
                  indicatorColor: Colors.transparent,
                  labelStyle: AppTextThemes.h7,
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: "Collection Details",
                    ),
                    Tab(
                      text: "Stock Details",
                    ),
                    Tab(
                      text: "Sales Summary",
                    ),
                    Tab(
                      text: "Credit Summary",
                    ),
                    Tab(
                      text: "Cash/Bank Summary",
                    ),
                  ]),

              Expanded(
                child: TabBarView(
                  children: [
                    cashCreditSummery(),
                    stockDetails(),
                    salesSummery(),
                    creditSummery(),
                    cashSummery(),
                  ],
                ),
              ),
              // const StockStatusContainer(),
              // const StockStatusContainerBlue(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget stockDetails() {
  return Column(
    children: [const StockTableHeader(), const StockRow()],
  );
}

Widget salesSummery() {
  return Column(
    children: [const SalesTableHeader(), const SalesRow()],
  );
}

Widget creditSummery() {
  return Column(
    children: [const CreditTableHeader(), const creditTableRow()],
  );
}

Widget cashSummery() {
  return Column(
    children: [const CashTableHeader(), const cashTableRow()],
  );
}

Widget cashCreditSummery() {
  return Column(
    children: [const cashCreditTableheader(), const cashCreditTableRow()],
  );
}
