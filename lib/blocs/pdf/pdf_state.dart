import 'package:equatable/equatable.dart';

/// States for the PdfBloc
abstract class PdfState extends Equatable {
  const PdfState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the PdfBloc
class PdfInitial extends PdfState {
  const PdfInitial();
}

/// State when a PDF is being generated
class PdfGenerating extends PdfState {
  const PdfGenerating();
}

/// State when a PDF has been generated successfully
class PdfGenerated extends PdfState {
  final String reportId;
  final String pdfPath;

  const PdfGenerated({
    required this.reportId,
    required this.pdfPath,
  });

  @override
  List<Object?> get props => [reportId, pdfPath];
}

/// State when a PDF is being shared
class PdfSharing extends PdfState {
  const PdfSharing();
}

/// State when a PDF has been shared successfully
class PdfShared extends PdfState {
  final String message;

  const PdfShared(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when a PDF operation has failed
class PdfOperationFailure extends PdfState {
  final String message;

  const PdfOperationFailure(this.message);

  @override
  List<Object?> get props => [message];
}