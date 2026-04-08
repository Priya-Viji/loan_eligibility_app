import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/evaluate_loan_usecase.dart';
import 'loan_event.dart';
import 'loan_state.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  final EvaluateLoanUseCase evaluateLoan;

  LoanBloc(this.evaluateLoan) : super(LoanInitial()) {
    on<EvaluateLoanEvent>((event, emit) async {
      emit(LoanLoading());

      try {
        final result = evaluateLoan(event.input);
        await Future.delayed(const Duration(milliseconds: 300));
        emit(LoanEvaluated(result));
      } catch (e) {
        emit(LoanError("Something went wrong. Please try again."));
      }
    });
  }
}
