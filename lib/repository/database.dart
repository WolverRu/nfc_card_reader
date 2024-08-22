import 'package:sqflite/sqflite.dart';

Future<Database> getOrCreateDatabase() {
  return openDatabase(
    'nfc_data_manager.db',
    version: 1,
    singleInstance: true,
    onUpgrade: (db, oldVersion, newVersion) async {
      bool _shouldMigrate(int version) =>
          oldVersion < version && version <= newVersion;
      final batch = db.batch();
      if (_shouldMigrate(1)) await _migrate(batch);
      await batch.commit();
    },
  );
}

Future<void> _migrate(Batch batch) async {
  batch.execute('''
    CREATE TABLE record (
      id INTEGER PRIMARY KEY,
      identifier BLOB NOT NULL,
      cardNumber BLOB,
      type BLOB,
      expireDate BLOB,
      state BLOB
    )
  ''');
}
