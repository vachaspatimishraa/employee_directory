import 'package:flutter/material.dart';
import '../model/employee_model.dart';
import 'employee_avatar.dart';
import 'favorite_button.dart';

class EmployeeCard extends StatelessWidget {
  final EmployeeModel employee;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Hero(
          tag: employee.id,
          child: EmployeeAvatar(name: employee.name ?? '', size: 50),
        ),
        title: Text(
          employee.name ?? 'No Name',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.email_outlined, size: 14, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    employee.email ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.business_rounded, size: 14, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    employee.company?.name ?? 'No Company',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: FavoriteButton(
          isFavorite: employee.isFavorite,
          onTap: onFavoriteTap,
        ),
      ),
    );
  }
}
