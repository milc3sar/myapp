import 'package:equatable/equatable.dart';
import 'package:supervisor/domain/entities/evidence_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';

/// Events for the SupplyBloc
abstract class SupplyEvent extends Equatable {
  const SupplyEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all supplies
class LoadSupplies extends SupplyEvent {
  const LoadSupplies();
}

/// Event to load supplies for a specific report
class LoadSuppliesByReportId extends SupplyEvent {
  final String reportId;

  const LoadSuppliesByReportId(this.reportId);

  @override
  List<Object?> get props => [reportId];
}

/// Event to load a specific supply by ID
class LoadSupply extends SupplyEvent {
  final String id;

  const LoadSupply(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to create a new supply
class CreateSupply extends SupplyEvent {
  final String code;

  const CreateSupply(this.code);

  @override
  List<Object?> get props => [code];
}

/// Event to update an existing supply
class UpdateSupply extends SupplyEvent {
  final SupplyEntity supply;

  const UpdateSupply(this.supply);

  @override
  List<Object?> get props => [supply];
}

/// Event to delete a supply
class DeleteSupply extends SupplyEvent {
  final String id;

  const DeleteSupply(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to add evidence to a supply
class AddEvidenceToSupply extends SupplyEvent {
  final String supplyId;
  final EvidenceEntity evidence;

  const AddEvidenceToSupply(this.supplyId, this.evidence);

  @override
  List<Object?> get props => [supplyId, evidence];
}

/// Event to create and add evidence to a supply
class CreateAndAddEvidenceToSupply extends SupplyEvent {
  final String supplyId;
  final String imagePath;
  final String voiceRecordingPath;
  final String observation;
  final Map<String, double> location;
  final String? locationMapPath;

  const CreateAndAddEvidenceToSupply({
    required this.supplyId,
    required this.imagePath,
    required this.voiceRecordingPath,
    required this.observation,
    required this.location,
    this.locationMapPath,
  });

  @override
  List<Object?> get props => [
        supplyId,
        imagePath,
        voiceRecordingPath,
        observation,
        location,
        locationMapPath,
      ];
}

/// Event to remove evidence from a supply
class RemoveEvidenceFromSupply extends SupplyEvent {
  final String supplyId;
  final String evidenceId;

  const RemoveEvidenceFromSupply(this.supplyId, this.evidenceId);

  @override
  List<Object?> get props => [supplyId, evidenceId];
}

/// Event to update evidence in a supply
class UpdateEvidenceInSupply extends SupplyEvent {
  final String supplyId;
  final EvidenceEntity evidence;

  const UpdateEvidenceInSupply(this.supplyId, this.evidence);

  @override
  List<Object?> get props => [supplyId, evidence];
}