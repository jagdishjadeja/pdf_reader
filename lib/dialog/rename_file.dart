import 'package:flutter/material.dart';

class RenameDialog extends StatefulWidget {
  final String fileName;
  const RenameDialog({Key key, @required this.fileName}) : super(key: key);

  @override
  _RenameDialogState createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  var fileFormField = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      fileFormField.text = widget.fileName;
      fileFormField.selection = TextSelection(
        baseOffset: 0,
        extentOffset: fileFormField.text.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Rename file'),
        ],
      ),
      content: Container(
        child: TextField(
          controller: fileFormField,
          autofocus: true,
        ),
      ),
      actions: [
        FlatButton(
          child: Text('save'),
          onPressed: () {
            Navigator.pop(context, fileFormField.text);
          },
        ),
        FlatButton(
          child: Text('cancel'),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ],
    );
  }
}
