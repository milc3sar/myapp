import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'evidence.freezed.dart';
part 'evidence.g.dart';

@freezed
abstract class Evidence with _$Evidence {
  @HiveType(typeId: 1)
  const factory Evidence({
    @HiveField(0) required String id,
    @HiveField(1) required String imagePath,
    @HiveField(2) required String voiceRecordingPath,
    @HiveField(3) required String observation,
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) required Map<String, double> location,
    @HiveField(6) String? locationMapPath,
  }) = _Evidence;

  factory Evidence.create({
    required String imagePath,
    required String voiceRecordingPath,
    required String observation,
    required Map<String, double> location,
    String? locationMapPath,
  }) {
    return Evidence(
      id: const Uuid().v4(),
      imagePath: imagePath,
      voiceRecordingPath: voiceRecordingPath,
      observation: observation,
      createdAt: DateTime.now(),
      location: location,
      locationMapPath: locationMapPath,
    );
  }

  factory Evidence.fromJson(Map<String, dynamic> json) => _$EvidenceFromJson(json);
}

// This class will be used to generate the Hive adapter
class EvidenceAdapter extends TypeAdapter<Evidence> {
  @override
  final int typeId = 1;

  @override
  Evidence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    
    return Evidence(
      id: fields[0] as String,
      imagePath: fields[1] as String,
      voiceRecordingPath: fields[2] as String,
      observation: fields[3] as String,
      createdAt: fields[4] as DateTime,
      location: (fields[5] as Map).cast<String, double>(),
      locationMapPath: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Evidence obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.voiceRecordingPath)
      ..writeByte(3)
      ..write(obj.observation)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.locationMapPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvidenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}