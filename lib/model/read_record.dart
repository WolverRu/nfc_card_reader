import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

part 'read_record.g.dart';

class Uint8ListConverter implements JsonConverter<Uint8List, List<int>> {
  const Uint8ListConverter();

  @override
  Uint8List fromJson(List<int> json) {
    return Uint8List.fromList(json);
  }

  @override
  List<int> toJson(Uint8List object) {
    return object.toList();
  }
}

@JsonSerializable()
class ReadRecord {
  ReadRecord({
    required this.id,
    @Uint8ListConverter() required this.identifier,
    required this.cardNumber,
    required this.type,
    required this.expireDate,
    required this.state,
  });

  final int? id;

  @Uint8ListConverter()
  final Uint8List identifier;

  final String? cardNumber;

  final String? type;

  final String? expireDate;

  final String state;

  factory ReadRecord.fromJson(Map<String, dynamic> json) =>
      _$ReadRecordFromJson(json);

  Map<String, dynamic> toJson() => _$ReadRecordToJson(this);
}
