import 'package:flutter/material.dart';
import 'package:nfc_card_reader/model/read_record.dart';
import 'package:nfc_card_reader/repository/repository.dart';
import 'package:nfc_card_reader/view/animation/pulsating_FAB.dart';
import 'package:nfc_card_reader/view/app.dart';
import 'package:nfc_card_reader/view/card_form.dart';
import 'package:nfc_card_reader/view/card_form_details.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:provider/provider.dart';
import 'package:nfc_card_reader/utility/extensions.dart';

class HomeScreenModel with ChangeNotifier {
  NfcTag? tag;
  final Repository _repo;
  final ReadRecord? old;
  Map<String, dynamic>? additionalData;

  HomeScreenModel(this._repo, this.old);

  Future<ReadRecord?> handleTag(NfcTag tag, BuildContext context) async {
    this.tag = tag;
    additionalData = {};

    Object? tech;
    ReadRecord? record;

    tech = NfcA.from(tag);
    if (tech is NfcA && tech.state == "ACTIVE") {
      record = ReadRecord(
        id: old?.id,
        identifier: tech.identifier,
        cardNumber: tech.cardNumber,
        type: tech.type,
        expireDate: tech.expireDate,
        state: tech.state,
      );
      _repo.createOrUpdateReadRecord(record);
    } else {
      record = null;
    }

    notifyListeners();
    return record;
  }

  void deleteTag(BuildContext context, ReadRecord record) {
    Provider.of<Repository>(context, listen: false)
        .deleteReadRecord(record)
        .catchError((e) => e);
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Widget withDependency([ReadRecord? record]) =>
      ChangeNotifierProvider<HomeScreenModel>(
        create: (context) =>
            HomeScreenModel(Provider.of(context, listen: false), record),
        child: const HomeScreen(),
      );

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeScreenModel>(context, listen: false);
    final toggle = Provider.of<UiModel>(context, listen: false).toggleTheme;
    Brightness currentBrightness = Theme.of(context).brightness;
    Color navigationBarColor = currentBrightness == Brightness.light
        ? const Color.fromRGBO(254, 249, 230, 1)
        : const Color.fromARGB(255, 28, 28, 30);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Карты',
            ),
            IconButton(
                onPressed: () => toggle(),
                icon: currentBrightness == Brightness.light
                    ? const Icon(
                        Icons.dark_mode,
                        color: Colors.blue,
                      )
                    : const Icon(
                        Icons.light_mode,
                        color: Colors.yellow,
                      ))
          ],
        ),
      ),
      body: StreamBuilder<Iterable<ReadRecord>>(
          stream: Provider.of<Repository>(context, listen: false)
              .subscribeReadRecordList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Image.asset(
                  'assets/nfc_icon.png',
                ),
              );
            }
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                final record = snapshot.data?.elementAt(index);
                return record != null
                    ? _HomeScreenFormRow(index, record, navigationBarColor)
                    : const SizedBox.shrink();
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox.shrink();
              },
              itemCount: snapshot.data?.length ?? 0,
            );
          }),
      floatingActionButton: PulsatingFAB(
        handleTag: model.handleTag,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _HomeScreenFormRow extends StatelessWidget {
  const _HomeScreenFormRow(this.index, this.record, this.navigationBarColor);

  final int index;

  final ReadRecord record;

  final Color navigationBarColor;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeScreenModel>(context, listen: false);
    List<MaterialColor> reversedPrimariesColors =
        Colors.primaries.reversed.toList();
    return Slidable(
      key: Key(record.id.toString()),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => model.deleteTag(context, record),
        ),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) async {
              await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Удалить запись?'),
                  content: Text(record.cardNumber ?? ''),
                  actions: [
                    TextButton(
                      child: const Text('ОТМЕНА'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('УДАЛИТЬ'),
                      onPressed: () {
                        Navigator.pop(context, true);
                        model.deleteTag(context, record);
                      },
                    ),
                  ],
                ),
              );
            },
            backgroundColor: navigationBarColor,
            foregroundColor: const Color(0xFFFE4A49),
            icon: Icons.delete,
            label: 'Удалить',
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardFormDetails(record),
            )),
        child: CardForm(
          cardHolder: record.type,
          cardNumber: record.cardNumber,
          expiryDate: record.expireDate?.toDateString(),
          status: record.state,
          cardColor: Colors.primaries[index % Colors.primaries.length],
          gradientColor:
              reversedPrimariesColors[index % reversedPrimariesColors.length],
        ),
      ),
    );
  }
}
