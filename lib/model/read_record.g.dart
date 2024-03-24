// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadRecord _$ReadRecordFromJson(Map<String, dynamic> json) => ReadRecord(
      id: json['id'] as int?,
      identifier:
          const Uint8ListConverter().fromJson(json['identifier'] as List<int>),
      cardNumber: json['cardNumber'] as String?,
      type: json['type'] as String?,
      expireDate: json['expireDate'] as String?,
      state: json['state'] as String,
    );

Map<String, dynamic> _$ReadRecordToJson(ReadRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'identifier': const Uint8ListConverter().toJson(instance.identifier),
      'cardNumber': instance.cardNumber,
      'type': instance.type,
      'expireDate': instance.expireDate,
      'state': instance.state,
    };
