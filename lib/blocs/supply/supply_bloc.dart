import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supervisor/domain/entities/evidence_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';
import 'package:supervisor/domain/repositories/supply_repository.dart';
import 'package:uuid/uuid.dart';

import 'supply_event.dart';
import 'supply_state.dart';

/// BLoC for managing supply-related operations
class SupplyBloc extends Bloc<SupplyEvent, SupplyState> {
  final SupplyRepository _supplyRepository;

  SupplyBloc({required SupplyRepository supplyRepository})
      : _supplyRepository = supplyRepository,
        super(const SupplyInitial()) {
    on<LoadSupplies>(_onLoadSupplies);
    on<LoadSuppliesByReportId>(_onLoadSuppliesByReportId);
    on<LoadSupply>(_onLoadSupply);
    on<CreateSupply>(_onCreateSupply);
    on<UpdateSupply>(_onUpdateSupply);
    on<DeleteSupply>(_onDeleteSupply);
    on<AddEvidenceToSupply>(_onAddEvidenceToSupply);
    on<CreateAndAddEvidenceToSupply>(_onCreateAndAddEvidenceToSupply);
    on<RemoveEvidenceFromSupply>(_onRemoveEvidenceFromSupply);
    on<UpdateEvidenceInSupply>(_onUpdateEvidenceInSupply);
  }

  Future<void> _onLoadSupplies(LoadSupplies event, Emitter<SupplyState> emit) async {
    try {
      emit(const SupplyLoading());
      final supplies = await _supplyRepository.getAllSupplies();
      emit(SuppliesLoaded(supplies));
    } catch (e) {
      emit(SupplyOperationFailure('Failed to load supplies: ${e.toString()}'));
    }
  }

  Future<void> _onLoadSuppliesByReportId(LoadSuppliesByReportId event, Emitter<SupplyState> emit) async {
    try {
      emit(const SupplyLoading());
      final supplies = await _supplyRepository.getSuppliesByReportId(event.reportId);
      emit(SuppliesLoaded(supplies));
    } catch (e) {
      emit(SupplyOperationFailure('Failed to load supplies for report: ${e.toString()}'));
    }
  }

  Future<void> _onLoadSupply(LoadSupply event, Emitter<SupplyState> emit) async {
    try {
      emit(const SupplyLoading());
      final supply = await _supplyRepository.getSupplyById(event.id);
      if (supply != null) {
        emit(SupplyLoaded(supply));
      } else {
        emit(const SupplyOperationFailure('Supply not found'));
      }
    } catch (e) {
      emit(SupplyOperationFailure('Failed to load supply: ${e.toString()}'));
    }
  }

  Future<void> _onCreateSupply(CreateSupply event, Emitter<SupplyState> emit) async {
    try {
      emit(const SupplyLoading());
      
      // Validate supply code (8 digits)
      if (event.code.length != 8 || int.tryParse(event.code) == null) {
        emit(const SupplyOperationFailure('Supply code must be 8 digits'));
        return;
      }
      
      // Create a new supply entity
      final supply = SupplyEntity(
        id: const Uuid().v4(),
        code: event.code,
        evidences: const [],
        createdAt:  DateTime.now()
      );
      
      // Save the supply
      await _supplyRepository.saveSupply(supply);
      
      emit(SupplyOperationSuccess('Supply created successfully'));
      
      // Load the newly created supply
      add(LoadSupply(supply.id));
    } catch (e) {
      emit(SupplyOperationFailure('Failed to create supply: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateSupply(UpdateSupply event, Emitter<SupplyState> emit) async {
    try {
      emit(const SupplyLoading());
      await _supplyRepository.saveSupply(event.supply);
      emit(SupplyOperationSuccess('Supply updated successfully'));
      add(LoadSupply(event.supply.id));
    } catch (e) {
      emit(SupplyOperationFailure('Failed to update supply: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteSupply(DeleteSupply event, Emitter<SupplyState> emit) async {
    try {
      emit(const SupplyLoading());
      await _supplyRepository.deleteSupply(event.id);
      emit(const SupplyOperationSuccess('Supply deleted successfully'));
      add(const LoadSupplies());
    } catch (e) {
      emit(SupplyOperationFailure('Failed to delete supply: ${e.toString()}'));
    }
  }

  Future<void> _onAddEvidenceToSupply(AddEvidenceToSupply event, Emitter<SupplyState> emit) async {
    try {
      emit(const SupplyLoading());
      await _supplyRepository.addEvidenceToSupply(event.supplyId, event.evidence);
      emit(const SupplyOperationSuccess('Evidence added to supply successfully'));
      add(LoadSupply(event.supplyId));
    } catch (e) {
      emit(SupplyOperationFailure('Failed to add evidence to supply: ${e.toString()}'));
    }
  }

  Future<void> _onCreateAndAddEvidenceToSupply(CreateAndAddEvidenceToSupply event, Emitter<SupplyState> emit) async {
    try {
      emit(const SupplyLoading());
      
      // Create a new evidence entity
      final evidence = EvidenceEntity(
        id: const Uuid().v4(),
        imagePath: event.imagePath,
        voiceRecordingPath: event.voiceRecordingPath,
        observation: event.observation,
        createdAt: DateTime.now(),
        location: event.location,
        locationMapPath: event.locationMapPath,
      );
      
      // Add the evidence to the supply
      await _supplyRepository.addEvidenceToSupply(event.supplyId, evidence);
      
      emit(const SupplyOperationSuccess('Evidence added to supply successfully'));
      add(LoadSupply(event.supplyId));
    } catch (e) {
      emit(SupplyOperationFailure('Failed to add evidence to supply: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveEvidenceFromSupply(RemoveEvidenceFromSupply event, Emitter<SupplyState> emit) async {
    try {
      emit(const SupplyLoading());
      await _supplyRepository.removeEvidenceFromSupply(event.supplyId, event.evidenceId);
      emit(const SupplyOperationSuccess('Evidence removed from supply successfully'));
      add(LoadSupply(event.supplyId));
    } catch (e) {
      emit(SupplyOperationFailure('Failed to remove evidence from supply: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateEvidenceInSupply(UpdateEvidenceInSupply event, Emitter<SupplyState> emit) async {
    try {
      emit(const SupplyLoading());
      await _supplyRepository.updateEvidenceInSupply(event.supplyId, event.evidence);
      emit(const SupplyOperationSuccess('Evidence updated in supply successfully'));
      add(LoadSupply(event.supplyId));
    } catch (e) {
      emit(SupplyOperationFailure('Failed to update evidence in supply: ${e.toString()}'));
    }
  }
}