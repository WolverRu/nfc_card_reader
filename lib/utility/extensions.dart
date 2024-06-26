import 'dart:typed_data';

extension IntExtension on int {
  String toHexString() {
    return toRadixString(16).padLeft(2, '0').toUpperCase();
  }
}

extension Uint8ListExtension on Uint8List {
  String toHexString({String empty = '-', String separator = ' '}) {
    return isEmpty ? empty : map((e) => e.toHexString()).join(separator);
  }
}

extension StringExtension on String {
  String toDateString() {
    return replaceAll('01.', '').replaceAll('.', '/');
  }
}
