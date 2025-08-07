import 'package:equatable/equatable.dart';

import 'supply_entity.dart';

/// Entity class for Report in the domain layer
class ReportEntity extends Equatable {
  final String id;
  final String supervisorName;
  final DateTime date;
  final String subject;
  final List<bool> activities;
  final List<SupplyEntity> supplies;
  final List<String> conclusions;
  final List<String> recommendations;
  final String? pdfPath;

  const ReportEntity({
    required this.id,
    required this.supervisorName,
    required this.date,
    required this.subject,
    required this.activities,
    required this.supplies,
    required this.conclusions,
    required this.recommendations,
    this.pdfPath,
  });

  @override
  List<Object?> get props => [
        id,
        supervisorName,
        date,
        subject,
        activities,
        supplies,
        conclusions,
        recommendations,
        pdfPath,
      ];

  /// Creates a copy of this ReportEntity with the given fields replaced with the new values
  ReportEntity copyWith({
    String? id,
    String? supervisorName,
    DateTime? date,
    String? subject,
    List<bool>? activities,
    List<SupplyEntity>? supplies,
    List<String>? conclusions,
    List<String>? recommendations,
    String? pdfPath,
  }) {
    return ReportEntity(
      id: id ?? this.id,
      supervisorName: supervisorName ?? this.supervisorName,
      date: date ?? this.date,
      subject: subject ?? this.subject,
      activities: activities ?? this.activities,
      supplies: supplies ?? this.supplies,
      conclusions: conclusions ?? this.conclusions,
      recommendations: recommendations ?? this.recommendations,
      pdfPath: pdfPath ?? this.pdfPath,
    );
  }

  /// Adds a supply to this report
  ReportEntity addSupply(SupplyEntity supply) {
    return copyWith(
      supplies: [...supplies, supply],
    );
  }

  /// Removes a supply from this report
  ReportEntity removeSupply(String supplyId) {
    return copyWith(
      supplies: supplies.where((s) => s.id != supplyId).toList(),
    );
  }

  /// Updates a supply in this report
  ReportEntity updateSupply(SupplyEntity supply) {
    return copyWith(
      supplies: supplies.map((s) => s.id == supply.id ? supply : s).toList(),
    );
  }

  /// Adds a conclusion to this report
  ReportEntity addConclusion(String conclusion) {
    return copyWith(
      conclusions: [...conclusions, conclusion],
    );
  }

  /// Removes a conclusion from this report
  ReportEntity removeConclusion(int index) {
    final newConclusions = List<String>.from(conclusions);
    if (index >= 0 && index < newConclusions.length) {
      newConclusions.removeAt(index);
    }
    return copyWith(conclusions: newConclusions);
  }

  /// Adds a recommendation to this report
  ReportEntity addRecommendation(String recommendation) {
    return copyWith(
      recommendations: [...recommendations, recommendation],
    );
  }

  /// Removes a recommendation from this report
  ReportEntity removeRecommendation(int index) {
    final newRecommendations = List<String>.from(recommendations);
    if (index >= 0 && index < newRecommendations.length) {
      newRecommendations.removeAt(index);
    }
    return copyWith(recommendations: newRecommendations);
  }

  /// Sets the PDF path for this report
  ReportEntity setPdfPath(String path) {
    return copyWith(pdfPath: path);
  }
}