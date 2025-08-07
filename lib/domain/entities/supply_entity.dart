import 'package:equatable/equatable.dart';

import 'evidence_entity.dart';

/// Entity class for Supply in the domain layer
class SupplyEntity extends Equatable {
  final String id;
  final String code;
  final List<EvidenceEntity> evidences;
  final DateTime createdAt;

  const SupplyEntity({
    required this.id,
    required this.code,
    required this.evidences,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, code, evidences, createdAt];

  /// Creates a copy of this SupplyEntity with the given fields replaced with the new values
  SupplyEntity copyWith({
    String? id,
    String? code,
    List<EvidenceEntity>? evidences,
    DateTime? createdAt,
  }) {
    return SupplyEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      evidences: evidences ?? this.evidences,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Adds an evidence to this supply
  SupplyEntity addEvidence(EvidenceEntity evidence) {
    return copyWith(
      evidences: [...evidences, evidence],
    );
  }

  /// Removes an evidence from this supply
  SupplyEntity removeEvidence(String evidenceId) {
    return copyWith(
      evidences: evidences.where((e) => e.id != evidenceId).toList(),
    );
  }

  /// Updates an evidence in this supply
  SupplyEntity updateEvidence(EvidenceEntity evidence) {
    return copyWith(
      evidences: evidences.map((e) => e.id == evidence.id ? evidence : e).toList(),
    );
  }
}