class EmployeeBonusBalance {
  final double salaryAccrued;
  final double bonusAccrued;
  final double salaryBalance;
  final double bonusBalance;
  final double totalBalance;

  const EmployeeBonusBalance({
    required this.salaryAccrued,
    required this.bonusAccrued,
    required this.salaryBalance,
    required this.bonusBalance,
    required this.totalBalance,
  });

  factory EmployeeBonusBalance.fromJson(Map<String, dynamic> json) {
    double value(String key) =>
        double.tryParse(
            (json[key] ?? json[_pascalCase(key)] ?? 0).toString()) ??
        0;
    return EmployeeBonusBalance(
      salaryAccrued: value('salaryAccrued'),
      bonusAccrued: value('bonusAccrued'),
      salaryBalance: value('salaryBalance'),
      bonusBalance: value('bonusBalance'),
      totalBalance: value('totalBalance'),
    );
  }
}

class EmployeeBonusClaim {
  final String weekStartDate;
  final String weekEndDate;
  final double salaryClaimed;
  final double bonusClaimed;
  final String status;

  const EmployeeBonusClaim({
    required this.weekStartDate,
    required this.weekEndDate,
    required this.salaryClaimed,
    required this.bonusClaimed,
    required this.status,
  });

  factory EmployeeBonusClaim.fromJson(Map<String, dynamic> json) {
    double value(String key) =>
        double.tryParse(
            (json[key] ?? json[_pascalCase(key)] ?? 0).toString()) ??
        0;
    String text(String key) =>
        (json[key] ?? json[_pascalCase(key)] ?? '').toString();
    return EmployeeBonusClaim(
      weekStartDate: text('weekStartDate'),
      weekEndDate: text('weekEndDate'),
      salaryClaimed: value('salaryClaimed'),
      bonusClaimed: value('bonusClaimed'),
      status: text('status'),
    );
  }

  double get totalClaimed => salaryClaimed + bonusClaimed;
}

String _pascalCase(String value) =>
    '${value[0].toUpperCase()}${value.substring(1)}';
