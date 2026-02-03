import 'package:flutter/material.dart';

Future<bool?> deleteDialog(BuildContext context) {
    return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                  title: const Text("Confirm"),
                  content: const Text("Are you sure you want to delete this item?"),
                  actions: <Widget>[
                    TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                    ),
                    TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Delete"),
                    ),
                  ],
                  );
                },
                );
  }