import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/dependency_injection.dart';
import 'core/strings/app_strings.dart';
import 'core/theme/theme.dart';
import 'features/list_exchanges/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: AppTheme.theme,
      home: BlocProvider(
        create: (context) => DependencyInjection.exchangeBloc,
        child: const HomePage(),
      ),
    );
  }
}

