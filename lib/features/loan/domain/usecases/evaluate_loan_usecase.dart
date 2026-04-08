import '../entities/loan_input_entity.dart';
import '../entities/loan_result_entity.dart';

class EvaluateLoanUseCase {
  LoanResultEntity call(LoanInputEntity input) {
    int score = 0;
    bool highRiskOverride = false;

    // AGE
    if (input.age < 21) {
      return LoanResultEntity(
        isEligible: false,
        riskLevel: 'High Risk',
        suggestion: 'Applicant is under 21. Not eligible for loan.',
        score: 0,
      );
    } else if (input.age <= 30) {
      score += 2;
    } else if (input.age <= 50) {
      score += 3;
    } else {
      score += 1;
    }

    // SAVINGS RATIO
    final savings = input.income - input.expenses;
    final savingsRatio = input.income > 0 ? (savings / input.income) * 100 : 0;

    if (savingsRatio < 20) {
      score += 1;
    } else if (savingsRatio <= 50) {
      score += 3;
    } else {
      score += 5;
    }

    // CREDIT SCORE
    if (input.creditScore < 600) {
      score += 0;
    } else if (input.creditScore <= 750) {
      score += 2;
    } else {
      score += 5;
    }

    // EXISTING LOANS
    score += input.hasExistingLoans ? -2 : 2;

    // EMPLOYMENT
    switch (input.employmentType) {
      case EmploymentType.salaried:
        score += 3;
        break;
      case EmploymentType.selfEmployed:
        score += 2;
        break;
      case EmploymentType.unemployed:
        score += 0;
        break;
    }

    // OVERRIDES
    if (input.creditScore < 500) highRiskOverride = true;
    if (input.employmentType == EmploymentType.unemployed &&
        input.hasExistingLoans) {
      highRiskOverride = true;
    }

    // ADJUSTMENTS
    if (input.income > 100000) score += 2;
    if (input.expenses > input.income) score -= 3;
    if (input.age < 25 && input.income > 100000) score += 2;

    // RISK CLASSIFICATION
    String riskLevel;
    if (highRiskOverride) {
      riskLevel = 'High Risk';
    } else if (score <= 4) {
      riskLevel = 'High Risk';
    } else if (score <= 10) {
      riskLevel = 'Medium Risk';
    } else {
      riskLevel = 'Low Risk';
    }

    final isEligible = riskLevel != 'High Risk';

    // SUGGESTION
    String suggestion;
    if (!isEligible) {
      suggestion =
          'Application is not eligible due to high risk. Improve credit score, reduce expenses, or stabilize employment.';
    } else if (riskLevel == 'Medium Risk') {
      suggestion =
          'Eligible with medium risk. Consider a lower loan amount or higher interest rate.';
    } else {
      suggestion =
          'Eligible with low risk. Recommended for approval with standard terms.';
    }

    return LoanResultEntity(
      isEligible: isEligible,
      riskLevel: riskLevel,
      suggestion: suggestion,
      score: score,
    );
  }
}
