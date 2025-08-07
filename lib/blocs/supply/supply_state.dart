import 'package:equatable/equatable.dart';
import 'package:supervisor/domain/entities/evidence_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';

/// States for the SupplyBloc
abstract class SupplyState extends Equatable {
  const SupplyState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the SupplyBloc
class SupplyInitial extends SupplyState {
  const SupplyInitial();
}

/// State when supplies are being loaded
class SupplyLoading extends SupplyState {
  const SupplyLoading();
}

/// State when supplies have been loaded successfully
class SuppliesLoaded extends SupplyState {
  final List<SupplyEntity> supplies;

  const SuppliesLoaded(this.supplies);

  @override
  List<Object?> get props => [supplies];
}

/// State when a single supply has been loaded successfully
class SupplyLoaded extends SupplyState {
  final SupplyEntity supply;

  const SupplyLoaded(this.supply);

  @override
  List<Object?> get props => [supply];
}

/// State when evidences for a supply have been loaded successfully
class EvidencesLoaded extends SupplyState {
  final String supplyId;
  final List<EvidenceEntity> evidences;

  const EvidencesLoaded(this.supplyId, this.evidences);

  @override
  List<Object?> get props => [supplyId, evidences];
}

/// State when a supply operation has been completed successfully
class SupplyOperationSuccess extends SupplyState {
  final String message;

  const SupplyOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when a supply operation has failed
class SupplyOperationFailure extends SupplyState {
  final String message;

  const SupplyOperationFailure(this.message);

  @override
  List<Object?> get props => [message];
}