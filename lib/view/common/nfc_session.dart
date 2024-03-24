import 'package:flutter/material.dart';
import 'package:nfc_card_reader/model/read_record.dart';
import 'package:nfc_card_reader/view/animation/pulsating_circle.dart';
import 'package:nfc_card_reader/view/card_form_details.dart';
import 'package:nfc_manager/nfc_manager.dart';

Future<void> startSession({
  required BuildContext context,
  required Future<ReadRecord?> Function(NfcTag) handleTag,
  String alertMessage = 'Приложите вашу карту к задней поверхности смартфона',
}) async {
  if (!(await NfcManager.instance.isAvailable())) {
    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (context) => _UnavailableDialog(),
    );
  }

  // ignore: use_build_context_synchronously
  return showDialog(
    context: context,
    builder: (context) => _AndroidSessionDialog(alertMessage, handleTag),
  );
}

class _UnavailableDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Ошибка')),
      content: const Text('NFC устройство выключено'),
      actions: [
        TextButton(
          child: const Text('ОК'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _AndroidSessionDialog extends StatefulWidget {
  const _AndroidSessionDialog(this.alertMessage, this.handleTag);

  final String alertMessage;

  final Future<ReadRecord?> Function(NfcTag tag) handleTag;

  @override
  State<StatefulWidget> createState() => _AndroidSessionDialogState();
}

class _AndroidSessionDialogState extends State<_AndroidSessionDialog> {
  String? _alertMessage;

  String? _errorMessage;

  ReadRecord? _record;

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          _record = await widget.handleTag(tag);
          await NfcManager.instance.stopSession().catchError((_) {/* no op */});
          if (_record == null) {
            setState(() => _errorMessage =
                'Эта карта заблокирована или не активирована. Не удалось получить данные');
          } else {
            setState(() => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CardFormDetails(_record),
                )));
          }
        } catch (e) {
          await NfcManager.instance.stopSession().catchError((_) {/* no op */});
          setState(() => _errorMessage = '$e');
        }
      },
    ).catchError((e) => setState(() => _errorMessage = '$e'));
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession().catchError((_) {/* no op */});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 35),
          child: Text(
            _errorMessage?.isNotEmpty == true ? 'Ошибка' : 'Cканирование',
          ),
        ),
      ),
      contentPadding: const EdgeInsets.all(20),
      content: Container(
        constraints: const BoxConstraints(maxHeight: 200),
        child: _errorMessage?.isNotEmpty == true
            ? Text(
                _errorMessage!,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const PulsatingCircle(),
                  Text(
                    _alertMessage?.isNotEmpty == true
                        ? _alertMessage!
                        : widget.alertMessage,
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
            child: Text(
              _errorMessage?.isNotEmpty == true ? 'ОК' : 'Отмена',
            ),
            onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}
