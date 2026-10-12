import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/color.dart';
import '../../../auth/domain/login_repo.dart';
import '../../data/employee_bonus_claim.dart';
import '../../domain/employee_bonus_claim_repository.dart';

class BonusSalaryPage extends StatefulWidget {
  const BonusSalaryPage({super.key});
  @override
  State<BonusSalaryPage> createState() => _BonusSalaryPageState();
}

class _BonusSalaryPageState extends State<BonusSalaryPage> {
  final _repo = EmployeeBonusClaimRepository();
  late Future<_Data> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_Data> _load() async {
    final login = await GetLoginRepo().getUserLoginResponse();
    if (login == null || login.companyId <= 0 || login.employeeId <= 0) {
      throw Exception(
          'Employee details are unavailable. Please sign in again.');
    }
    final values = await Future.wait([
      _repo.getBalance(
          companyId: login.companyId, employeeId: login.employeeId),
      _repo.getClaims(companyId: login.companyId, employeeId: login.employeeId),
    ]);
    return _Data(values[0] as EmployeeBonusBalance,
        values[1] as List<EmployeeBonusClaim>);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colour.pContainerBlack,
        appBar: AppBar(
          title: const Text('Bonus & Salary'),
          backgroundColor: Colour.pContainerBlack,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () => setState(() => _future = _load()))
          ],
        ),
        body: FutureBuilder<_Data>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _Error(
                  message: snapshot.error.toString(),
                  retry: () => setState(() => _future = _load()));
            }
            final data = snapshot.requireData;
            return ListView(padding: const EdgeInsets.all(16), children: [
              const Text('Earnings overview', style: _heading),
              const SizedBox(height: 6),
              const Text('Your current salary, bonus and claims.',
                  style: _muted),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: _BalanceCard(
                        'Bonus Available',
                        data.balance.bonusBalance,
                        Icons.card_giftcard_outlined)),
                const SizedBox(width: 12),
                Expanded(
                    child: _BalanceCard(
                        'Balance Salary',
                        data.balance.salaryBalance,
                        Icons.account_balance_wallet_outlined)),
              ]),
              const SizedBox(height: 12),
              _BalanceCard('Total Available', data.balance.totalBalance,
                  Icons.payments_outlined,
                  wide: true),
              const SizedBox(height: 24),
              const Text('Claim History', style: _heading),
              const SizedBox(height: 10),
              if (data.claims.isEmpty)
                const _EmptyHistory()
              else
                ...data.claims.map((claim) => _ClaimCard(claim)),
            ]);
          },
        ),
      );
}

class _Data {
  final EmployeeBonusBalance balance;
  final List<EmployeeBonusClaim> claims;
  const _Data(this.balance, this.claims);
}

class _BalanceCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final bool wide;
  const _BalanceCard(this.title, this.amount, this.icon, {this.wide = false});
  @override
  Widget build(BuildContext context) => Container(
      height: wide ? 90 : 122,
      padding: const EdgeInsets.all(14),
      decoration: _box,
      child: Row(children: [
        Icon(icon, color: Colors.amberAccent),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(title, style: _muted),
              const SizedBox(height: 5),
              Text(_money(amount), style: _amount)
            ]))
      ]));
}

class _ClaimCard extends StatelessWidget {
  final EmployeeBonusClaim claim;
  const _ClaimCard(this.claim);
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _box,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.calendar_today_outlined,
              color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(
                  '${_date(claim.weekStartDate)} – ${_date(claim.weekEndDate)}',
                  style: const TextStyle(color: Colors.white))),
          _Status(claim.status)
        ]),
        const Divider(color: Colors.white24, height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _ClaimValue('Salary', claim.salaryClaimed),
          _ClaimValue('Bonus', claim.bonusClaimed),
          _ClaimValue('Total', claim.totalClaimed, bold: true)
        ])
      ]));
}

class _ClaimValue extends StatelessWidget {
  final String label;
  final double amount;
  final bool bold;
  const _ClaimValue(this.label, this.amount, {this.bold = false});
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: _muted),
        const SizedBox(height: 3),
        Text(_money(amount),
            style: bold ? _amount : const TextStyle(color: Colors.white))
      ]);
}

class _Status extends StatelessWidget {
  final String text;
  const _Status(this.text);
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: .2),
          borderRadius: BorderRadius.circular(12)),
      child: Text(text.isEmpty ? 'SAVED' : text,
          style: const TextStyle(
              color: Color(0xFF9CFFB4),
              fontSize: 11,
              fontWeight: FontWeight.bold)));
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      decoration: _box,
      child: const Column(children: [
        Icon(Icons.history_outlined, color: Colors.white70, size: 32),
        SizedBox(height: 8),
        Text('No claim history available',
            style: TextStyle(color: Colors.white, fontSize: 16))
      ]));
}

class _Error extends StatelessWidget {
  final String message;
  final VoidCallback retry;
  const _Error({required this.message, required this.retry});
  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off_outlined,
                color: Colors.white70, size: 40),
            const SizedBox(height: 12),
            Text(message.replaceFirst('Exception: ', ''),
                textAlign: TextAlign.center, style: _muted),
            const SizedBox(height: 12),
            OutlinedButton.icon(
                onPressed: retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'))
          ])));
}

final _box = BoxDecoration(
    color: Colors.white.withValues(alpha: .08),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.white.withValues(alpha: .12)));
const _heading =
    TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
const _muted = TextStyle(color: Colors.white70);
const _amount =
    TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold);
String _money(double amount) =>
    NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(amount);
String _date(String value) {
  final date = DateTime.tryParse(value);
  return date == null ? '—' : DateFormat('dd/MM/yyyy').format(date);
}
