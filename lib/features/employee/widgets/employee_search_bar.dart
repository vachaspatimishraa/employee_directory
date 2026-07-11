import 'package:flutter/material.dart';

class EmployeeSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const EmployeeSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Search employees by name or email...',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
          border: InputBorder.none,
          icon: Icon(Icons.search_rounded, color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}
