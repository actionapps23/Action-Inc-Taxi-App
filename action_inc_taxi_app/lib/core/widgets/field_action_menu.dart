import 'package:flutter/material.dart';

class FieldActionsMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final Future<void> Function() onDeleteConfirm;

  const FieldActionsMenu({
    super.key,
    required this.onEdit,
    required this.onDeleteConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'delete') {
          await onDeleteConfirm();
        }
      },
      itemBuilder: (ctx) => const [
        PopupMenuItem(value: 'edit', child: Text('Edit')),
        PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );
  }
}
