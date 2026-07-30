import 'package:flutter/material.dart';

import '../../../auth/domain/login_repo.dart';
import '../../../customer/data/local/invoice_draft_local_data_source.dart';
import '../../../customer/presentation/pages/new_invoice/selected_item_list.dart';
import '../../../customer/presentation/pages/customer_view/customer_view.dart';
import '../../../route/presentation/pages/route.dart';
import '../widget/bottom_navi.dart';
import 'home_screen.dart';

class HomePage extends StatefulWidget {
  final int? index;
  const HomePage({super.key, this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _activeIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CustomerView(),
    const RoutePage()
  ];
  @override
  void initState() {
    super.initState();
    _activeIndex = widget.index ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _offerInvoiceDraft();
    });
  }

  Future<void> _offerInvoiceDraft() async {
    final draftStore = InvoiceDraftLocalDataSource();
    final draft = await draftStore.load();
    final login = await GetLoginRepo().getUserLoginResponse();
    if (!mounted || draft == null || login == null) {
      return;
    }

    if (draft.client.companyId != login.companyId || draft.client.id == null) {
      await draftStore.clear();
      return;
    }

    final shouldResume = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Resume unfinished invoice?'),
        content: Text(
          'Continue the invoice for '
          '${draft.client.name ?? draft.client.contactPersonName ?? 'client'} '
          'with ${draft.items.length} item(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Discard'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.restore),
            label: const Text('Resume'),
          ),
        ],
      ),
    );

    if (!mounted) {
      return;
    }
    if (shouldResume == true) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SelectedItemList(
            client: draft.client,
            partyId: draft.client.id,
            draftItems: draft.items,
          ),
        ),
      );
    } else if (shouldResume == false) {
      await draftStore.clear();
    }
  }

  void _onNavBarTap(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_activeIndex],
      bottomNavigationBar: BottomNavBar(
        activeIndex: _activeIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
