import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loan_eligibility_app/core/theme/app_text_styles.dart';

import '../../domain/entities/loan_input_entity.dart';
import 'custom_text_field.dart';

class LoanFormWidget extends StatefulWidget {
  final void Function(LoanInputEntity input) onChanged;

  const LoanFormWidget({super.key, required this.onChanged});

  @override
  State<LoanFormWidget> createState() => _LoanFormWidgetState();
}

class _LoanFormWidgetState extends State<LoanFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final _ageController = TextEditingController();
  final _incomeController = TextEditingController();
  final _expensesController = TextEditingController();
  final _creditScoreController = TextEditingController();

  bool _hasExistingLoan = false;
  EmploymentType _employmentType = EmploymentType.salaried;

  @override
  void dispose() {
    _ageController.dispose();
    _incomeController.dispose();
    _expensesController.dispose();
    _creditScoreController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _ageController.clear();
    _incomeController.clear();
    _expensesController.clear();
    _creditScoreController.clear();

    setState(() {
      _hasExistingLoan = false;
      _employmentType = EmploymentType.salaried;
    });

    widget.onChanged(
      LoanInputEntity(
        age: 0,
        income: 0,
        expenses: 0,
        hasExistingLoans: false,
        creditScore: 0,
        employmentType: EmploymentType.salaried,
      ),
    );
  }

  void _updateInput() {
    if (!_formKey.currentState!.validate()) return;

    final input = LoanInputEntity(
      age: int.tryParse(_ageController.text) ?? 0,
      income: double.tryParse(_incomeController.text) ?? 0,
      expenses: double.tryParse(_expensesController.text) ?? 0,
      hasExistingLoans: _hasExistingLoan,
      creditScore: int.tryParse(_creditScoreController.text) ?? 0,
      employmentType: _employmentType,
    );

    widget.onChanged(input);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- TITLE ----------------
          Text("Applicant Details", style: AppTextStyles.title),

          const SizedBox(height: 20),

          // ---------------- AGE ----------------
          CustomTextField(
            controller: _ageController,
            label: "Age",
            icon: Icons.cake_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(2),
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.isEmpty) return "Age is required";
              final age = int.tryParse(value);
              if (age == null) return "Enter a valid number";
              if (age < 21 || age > 65) return "Age must be between 21 and 65";
              return null;
            },
            onChanged: (_) => _updateInput(),
          ),

          const SizedBox(height: 16),

          // ---------------- INCOME ----------------
          CustomTextField(
            controller: _incomeController,
            label: "Monthly Income",
            icon: Icons.attach_money_rounded,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) return "Income is required";
              final income = double.tryParse(value);
              if (income == null || income <= 0) return "Enter a valid income";
              if (income < 5000) return "Income too low for loan eligibility";
              return null;
            },
            onChanged: (_) => _updateInput(),
          ),

          const SizedBox(height: 16),

          // ---------------- EXPENSES ----------------
          CustomTextField(
            controller: _expensesController,
            label: "Monthly Expenses",
            icon: Icons.money_off_rounded,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) return "Expenses required";
              final expenses = double.tryParse(value);
              final income = double.tryParse(_incomeController.text);
              if (expenses == null) return "Enter valid expenses";
              if (income != null && expenses > income) {
                return "Expenses cannot exceed income";
              }
              return null;
            },
            onChanged: (_) => _updateInput(),
          ),

          const SizedBox(height: 16),

          // ---------------- CREDIT SCORE ----------------
          CustomTextField(
            controller: _creditScoreController,
            label: "Credit Score",
            icon: Icons.score_rounded,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(3),
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Credit score required";
              }
              final score = int.tryParse(value);
              if (score == null) return "Enter a valid number";
              if (score < 300 || score > 900) {
                return "Credit score must be between 300 and 900";
              }
              return null;
            },
            onChanged: (_) => _updateInput(),
          ),

          const SizedBox(height: 22),

          // ---------------- EXISTING LOAN ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Existing Loan", style: AppTextStyles.subtitle),
              Switch(
                value: _hasExistingLoan,
                onChanged: (val) {
                  setState(() => _hasExistingLoan = val);
                  _updateInput();
                },
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ---------------- EMPLOYMENT TYPE ----------------
          Text("Employment Type", style: AppTextStyles.subtitle),

          const SizedBox(height: 10),

          DropdownButtonFormField<EmploymentType>(
            initialValue: _employmentType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: EmploymentType.salaried,
                child: Text("Salaried"),
              ),
              DropdownMenuItem(
                value: EmploymentType.selfEmployed,
                child: Text("Self-employed"),
              ),
              DropdownMenuItem(
                value: EmploymentType.unemployed,
                child: Text("Unemployed"),
              ),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() => _employmentType = val);
                _updateInput();
              }
            },
          ),
          const SizedBox(height: 20),

          Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.4)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _clearForm,
              child: const Text(
                "Clear All",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
