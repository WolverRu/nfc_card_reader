import 'dart:async';

import 'package:nfc_card_reader/model/read_record.dart';
import 'package:nfc_card_reader/repository/database.dart';
import 'package:nfc_card_reader/repository/repository_impl.dart';

abstract class Repository {
  static Future<Repository> createInstance() async =>
      RepositoryImpl(await getOrCreateDatabase());

  Stream<Iterable<ReadRecord>> subscribeReadRecordList();

  Future<ReadRecord> createOrUpdateReadRecord(ReadRecord record);

  Future<void> deleteReadRecord(ReadRecord record);
}

class SubscriptionManager {
  final Map<int, StreamController> _controllers = {};
  final Map<int, StreamController> _subscribers = {};

  Stream<T> createStream<T>(Future<T> Function() fetcher) {
    final key = DateTime.now().microsecondsSinceEpoch;
    final controller = StreamController<T>(onCancel: () {
      _controllers.remove(key)?.close();
      _subscribers.remove(key)?.close();
    });
    void publisher(Future<T> future) =>
        future.then(controller.add).catchError(controller.addError);
    _subscribers[key] = StreamController(onListen: () => publisher(fetcher()))
      ..stream.listen((_) => publisher(fetcher()));
    _controllers[key] = controller;
    return controller.stream;
  }

  void publish() => _subscribers.values.forEach((e) => e.add(null));
}
