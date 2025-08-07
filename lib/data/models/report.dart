import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'supply.dart';

part 'report.freezed.dart';
part 'report.g.dart';

@freezed
abstract class Report with _$Report {
  @HiveType(typeId: 3)
  const factory Report({
    @HiveField(0) required String id,
    @HiveField(1) required String supervisorName,
    @HiveField(2) required DateTime date,
    @HiveField(3) required String subject,
    @HiveField(4) required List<bool> activities,
    @HiveField(5) required List<Supply> supplies,
    @HiveField(6) required List<String> conclusions,
    @HiveField(7) required List<String> recommendations,
    @HiveField(8) String? pdfPath,
  }) = _Report;

  factory Report.create({
    required String supervisorName,
    required String subject,
    required List<bool> activities,
    DateTime? date,
    List<Supply> supplies = const [],
    List<String> conclusions = const [],
    List<String> recommendations = const [],
    String? pdfPath,
  }) {
    // Validate activities list has exactly 4 items
    if (activities.length != 4) {
      throw ArgumentError('Activities list must have exactly 4 items');
    }
    
    return Report(
      id: const Uuid().v4(),
      supervisorName: supervisorName,
      date: date ?? DateTime.now(),
      subject: subject,
      activities: activities,
      supplies: supplies,
      conclusions: conclusions,
      recommendations: recommendations,
      pdfPath: pdfPath,
    );
  }

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}

// This class will be used to generate the Hive adapter
class ReportAdapter extends TypeAdapter<Report> {
  @override
  final int typeId = 3;

  @override
  Report read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    
    return Report(
      id: fields[0] as String,
      supervisorName: fields[1] as String,
      date: fields[2] as DateTime,
      subject: fields[3] as String,
      activities: (fields[4] as List).cast<bool>(),
      supplies: (fields[5] as List).cast<Supply>(),
      conclusions: (fields[6] as List).cast<String>(),
      recommendations: (fields[7] as List).cast<String>(),
      pdfPath: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Report obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.supervisorName)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.subject)
      ..writeByte(4)
      ..write(obj.activities)
      ..writeByte(5)
      ..write(obj.supplies)
      ..writeByte(6)
      ..write(obj.conclusions)
      ..writeByte(7)
      ..write(obj.recommendations)
      ..writeByte(8)
      ..write(obj.pdfPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}