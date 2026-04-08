import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loan_eligibility_app/features/loan/domain/entities/loan_input_entity.dart';
import 'package:loan_eligibility_app/features/loan/presentation/bloc/loan_bloc.dart';
import 'package:loan_eligibility_app/features/loan/presentation/bloc/loan_event.dart';
import 'package:loan_eligibility_app/features/loan/presentation/bloc/loan_state.dart';

import '../widgets/calculate_button.dart';
import '../widgets/loan_form_widget.dart';
import '../widgets/result_card.dart';

class LoanPage extends StatefulWidget {
  const LoanPage({super.key});

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  LoanInputEntity? _formInput;

  void _showResultDialog(BuildContext context, LoanEvaluated state) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          state.result.isEligible ? "Eligible" : "Not Eligible",
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Risk Level: ${state.result.riskLevel}"),
            const SizedBox(height: 8),
            Text(state.result.suggestion),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoanBloc>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: Column(
        children: [
          // ---------------- HEADER ----------------
          Container(
            height: 170,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 70),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: const Center(
              child: Text(
                "Loan Eligibility Check",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),

          // ---------------- BODY ----------------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: BlocConsumer<LoanBloc, LoanState>(
                listener: (context, state) {
                  if (state is LoanEvaluated) {
                    _showResultDialog(context, state);
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 12),

                        // ---------------- FORM CARD ----------------
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: LoanFormWidget(
                            onChanged: (input) => _formInput = input,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ---------------- BUTTON ----------------
                        CalculateButtonWidget(
                          onPressed: () {
                            if (_formInput != null) {
                              bloc.add(EvaluateLoanEvent(_formInput!));
                            }
                          },
                          isLoading: state is LoanLoading,
                        ),

                        const SizedBox(height: 22),

                        // ---------------- RESULT CARD ----------------
                        if (state is LoanEvaluated)
                          AnimatedOpacity(
                            opacity: 1,
                            duration: const Duration(milliseconds: 450),
                            child: ResultCard(result: state.result),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
