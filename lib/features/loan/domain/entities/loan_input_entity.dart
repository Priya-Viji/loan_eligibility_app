enum EmploymentType { salaried, selfEmployed, unemployed }

class LoanInputEntity {
  final int age;
  final double income;
  final double expenses;
  final bool hasExistingLoans;
  final int creditScore;
  final EmploymentType employmentType;

  const LoanInputEntity({
    required this.age,
    required this.income,
    required this.expenses,
    required this.hasExistingLoans,
    required this.creditScore,
    required this.employmentType,
  });
}
