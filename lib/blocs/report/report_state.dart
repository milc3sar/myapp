import 'package:equatable/equatable.dart';
import 'package:supervisor/domain/entities/report_entity.dart';

/// States for the ReportBloc
abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the ReportBloc
class ReportInitial extends ReportState {
  const ReportInitial();
}

/// State when reports are being loaded
class ReportLoading extends ReportState {
  const ReportLoading();
}

/// State when reports have been loaded successfully
class ReportsLoaded extends ReportState {
  final List<ReportEntity> reports;

  const ReportsLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

/// State when a single report has been loaded successfully
class ReportLoaded extends ReportState {
  final ReportEntity report;

  const ReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

/// State when a report operation has been completed successfully
class ReportOperationSuccess extends ReportState {
  final String message;

  const ReportOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when a report operation has failed
class ReportOperationFailure extends ReportState {
  final String message;

  const ReportOperationFailure(this.message);

  @override
  List<Object?> get props => [message];
}