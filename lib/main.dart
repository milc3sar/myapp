import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supervisor/blocs/pdf/pdf_bloc.dart';
import 'package:supervisor/blocs/report/report_bloc.dart';
import 'package:supervisor/blocs/supply/supply_bloc.dart';
import 'package:supervisor/data/datasources/local_storage.dart';
import 'package:supervisor/data/models/evidence.dart';
import 'package:supervisor/data/models/report.dart';
import 'package:supervisor/data/models/supply.dart';
import 'package:supervisor/data/repositories/report_repository_impl.dart';
import 'package:supervisor/data/repositories/supply_repository_impl.dart';
import 'package:supervisor/domain/repositories/report_repository.dart';
import 'package:supervisor/domain/repositories/supply_repository.dart';
import 'package:supervisor/presentation/screens/home_screen.dart';
import 'package:supervisor/presentation/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(EvidenceAdapter());
  Hive.registerAdapter(SupplyAdapter());
  Hive.registerAdapter(ReportAdapter());
  
  // Open Hive boxes
  await Hive.openBox('reports_box');
  await Hive.openBox('supplies_box');
  await Hive.openBox('evidences_box');
  await Hive.openBox('settings_box');
  
  runApp(const SupervisorApp());
}

class SupervisorApp extends StatelessWidget {
  const SupervisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create the local storage instance
    final localStorage = LocalStorage.fromDefaultBoxes();
    
    // Create the repositories
    final SupplyRepository supplyRepository = SupplyRepositoryImpl(localStorage: localStorage);
    final ReportRepository reportRepository = ReportRepositoryImpl(localStorage: localStorage);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReportBloc>(
          create: (context) => ReportBloc(reportRepository: reportRepository),
        ),
        BlocProvider<SupplyBloc>(
          create: (context) => SupplyBloc(supplyRepository: supplyRepository),
        ),
        BlocProvider<PdfBloc>(
          create: (context) => PdfBloc(reportRepository: reportRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Supervisión',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
