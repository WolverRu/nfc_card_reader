import 'package:flutter/material.dart';
import 'package:nfc_card_reader/model/read_record.dart';
import 'package:nfc_card_reader/utility/extensions.dart';

class CardFormDetails extends StatelessWidget {
  const CardFormDetails(this.record, {super.key});

  final ReadRecord? record;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Карта № ${record?.cardNumber}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 380,
            minWidth: double.infinity,
          ),
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            color: const Color(0xFF001021),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RecordColumn(
                title: const Row(
                  children: [
                    Icon(Icons.key),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Id'),
                  ],
                ),
                subtitle: Text(record?.identifier.toHexString() ?? ''),
              ),
              const SizedBox(height: 12),
              _RecordColumn(
                title: const Row(
                  children: [
                    Icon(Icons.card_travel_sharp),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Статус'),
                  ],
                ),
                subtitle: Text(record?.state ?? ''),
              ),
              const SizedBox(height: 12),
              _RecordColumn(
                title: const Row(
                  children: [
                    Icon(Icons.format_list_numbered_rtl),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Номер карты'),
                  ],
                ),
                subtitle: Text(record?.cardNumber ?? ''),
              ),
              const SizedBox(height: 12),
              _RecordColumn(
                title: const Row(
                  children: [
                    Icon(Icons.timer_sharp),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Срок службы до'),
                  ],
                ),
                subtitle: Text(record?.expireDate?.toDateString() ?? ''),
              ),
              const SizedBox(height: 12),
              _RecordColumn(
                title: const Row(
                  children: [
                    Icon(Icons.type_specimen),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Тип'),
                  ],
                ),
                subtitle: Text(record?.type ?? ''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecordColumn extends StatelessWidget {
  const _RecordColumn({required this.title, required this.subtitle});

  final Widget title;

  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 18,
              color: const Color.fromRGBO(254, 249, 230, 1),
              fontWeight: FontWeight.bold),
          child: title,
        ),
        const SizedBox(height: 5),
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 16,
                color: const Color.fromRGBO(254, 249, 230, 1),
              ),
          child: subtitle,
        ),
      ],
    );
  }
}
