// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:loan_eligibility_app/features/loan/domain/usecases/evaluate_loan_usecase.dart';
// import 'package:loan_eligibility_app/features/loan/presentation/bloc/loan_bloc.dart';
// import 'package:loan_eligibility_app/features/loan/presentation/pages/splash_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Loan Eligibility App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color.fromARGB(255, 85, 108, 240),
//         ),
//       ),
//       home: BlocProvider(
//         create: (_) => LoanBloc(EvaluateLoanUseCase()),
//         child: const SplashScreen(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_eligibility_app/features/loan/presentation/bloc/loan_bloc.dart';

import 'features/loan/domain/usecases/evaluate_loan_usecase.dart';
import 'features/loan/presentation/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoanBloc(EvaluateLoanUseCase()),
      child: MaterialApp(
        title: 'Loan Eligibility App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 85, 108, 240),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
