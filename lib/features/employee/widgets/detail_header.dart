import 'package:flutter/material.dart';
import 'employee_avatar.dart';

class DetailHeader extends StatelessWidget {
  final int employeeId;
  final String name;
  final String? username;

  const DetailHeader({
    super.key,
    required this.employeeId,
    required this.name,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Hero(
          tag: 'employee_$employeeId',
          child: EmployeeAvatar(
            name: name,
            size: 110,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        if (username != null && username!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            '@$username',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
