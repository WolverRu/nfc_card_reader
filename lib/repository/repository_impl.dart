import 'package:nfc_card_reader/model/read_record.dart';
import 'package:nfc_card_reader/repository/repository.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryImpl implements Repository {
  RepositoryImpl(this._db);

  final Database _db;

  final SubscriptionManager _subscriptionManager = SubscriptionManager();

  @override
  Stream<Iterable<ReadRecord>> subscribeReadRecordList() {
    return _subscriptionManager.createStream(() async {
      return _db
          .query('record')
          .then((value) => value.map((e) => ReadRecord.fromJson(e)));
    });
  }

  @override
  Future<ReadRecord> createOrUpdateReadRecord(ReadRecord record) async {
    final id = await _db.insert('record', record.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    _subscriptionManager.publish();
    return ReadRecord.fromJson(record.toJson()..['id'] = id);
  }

  @override
  Future<void> deleteReadRecord(ReadRecord record) async {
    await _db.delete('record', where: 'id = ?', whereArgs: [record.id!]);
    _subscriptionManager.publish();
  }
}
