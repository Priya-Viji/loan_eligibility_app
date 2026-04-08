import '../../domain/entities/loan_input_entity.dart';

abstract class LoanEvent {}

class EvaluateLoanEvent extends LoanEvent {
  final LoanInputEntity input;
  EvaluateLoanEvent(this.input);
}
