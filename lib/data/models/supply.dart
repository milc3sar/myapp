import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'evidence.dart';

part 'supply.freezed.dart';
part 'supply.g.dart';

@freezed
abstract class Supply with _$Supply {
  @HiveType(typeId: 2)
  const factory Supply({
    @HiveField(0) required String id,
    @HiveField(1) required String code,
    @HiveField(2) required List<Evidence> evidences,
    @HiveField(3) required DateTime createdAt,
  }) = _Supply;

  factory Supply.create({
    required String code,
    List<Evidence> evidences = const [],
    DateTime? createdAt,
  }) {
    // Validate that code is 8 digits
    if (code.length != 8 || int.tryParse(code) == null) {
      throw ArgumentError('Supply code must be 8 digits');
    }
    
    return Supply(
      id: const Uuid().v4(),
      code: code,
      evidences: evidences,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  factory Supply.fromJson(Map<String, dynamic> json) => _$SupplyFromJson(json);
}

// This class will be used to generate the Hive adapter
class SupplyAdapter extends TypeAdapter<Supply> {
  @override
  final int typeId = 2;

  @override
  Supply read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    
    return Supply(
      id: fields[0] as String,
      code: fields[1] as String,
      evidences: (fields[2] as List).cast<Evidence>(),
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Supply obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.evidences)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}