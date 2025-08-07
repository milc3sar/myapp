import 'package:equatable/equatable.dart';

/// Entity class for Evidence in the domain layer
class EvidenceEntity extends Equatable {
  final String id;
  final String imagePath;
  final String voiceRecordingPath;
  final String observation;
  final DateTime createdAt;
  final Map<String, double> location;
  final String? locationMapPath;

  const EvidenceEntity({
    required this.id,
    required this.imagePath,
    required this.voiceRecordingPath,
    required this.observation,
    required this.createdAt,
    required this.location,
    this.locationMapPath,
  });

  @override
  List<Object?> get props => [
        id,
        imagePath,
        voiceRecordingPath,
        observation,
        createdAt,
        location,
        locationMapPath,
      ];

  /// Creates a copy of this EvidenceEntity with the given fields replaced with the new values
  EvidenceEntity copyWith({
    String? id,
    String? imagePath,
    String? voiceRecordingPath,
    String? observation,
    DateTime? createdAt,
    Map<String, double>? location,
    String? locationMapPath,
  }) {
    return EvidenceEntity(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      voiceRecordingPath: voiceRecordingPath ?? this.voiceRecordingPath,
      observation: observation ?? this.observation,
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
      locationMapPath: locationMapPath ?? this.locationMapPath,
    );
  }
}