import 'package:flutter/material.dart';
import 'package:loan_eligibility_app/core/theme/app_colors.dart';
import 'package:loan_eligibility_app/core/theme/app_text_styles.dart';
import '../../domain/entities/loan_result_entity.dart';

class ResultCard extends StatelessWidget {
  final LoanResultEntity result;

  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final Color color = switch (result.riskLevel) {
      'High Risk' => AppColors.danger,
      'Medium Risk' => AppColors.warning,
      _ => AppColors.success,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result.isEligible ? 'Eligible' : 'Not Eligible',
            style: AppTextStyles.title.copyWith(color: color),
          ),
          const SizedBox(height: 8),
          Text(
            'Risk Level: ${result.riskLevel}',
            style: AppTextStyles.subtitle,
          ),
          const SizedBox(height: 4),
          Text('Score: ${result.score}', style: AppTextStyles.body),
          const SizedBox(height: 12),
          Text(result.suggestion, style: AppTextStyles.body),
        ],
      ),
    );
  }
}
