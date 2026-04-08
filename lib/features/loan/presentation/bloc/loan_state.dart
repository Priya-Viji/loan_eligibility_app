import '../../domain/entities/loan_result_entity.dart';

abstract class LoanState {}

class LoanInitial extends LoanState {}

class LoanLoading extends LoanState {}

class LoanEvaluated extends LoanState {
  final LoanResultEntity result;
  LoanEvaluated(this.result);
}

class LoanError extends LoanState {
  final String message;
  LoanError(this.message);
}
