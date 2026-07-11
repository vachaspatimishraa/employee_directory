import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../provider/employee_provider.dart';
import '../model/employee_model.dart';
import '../widgets/detail_header.dart';
import '../widgets/detail_card.dart';
import '../widgets/company_card.dart';
import '../widgets/address_card.dart';
import '../widgets/favorite_button.dart';
import '../widgets/info_tile.dart';
import '../../../routes/route_names.dart';

class EmployeeDetailScreen extends ConsumerWidget {
  final EmployeeModel employee;

  const EmployeeDetailScreen({super.key, required this.employee});

  Future<void> _launchWebsite(BuildContext context, String? url) async {
    if (url == null || url.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Website not available.')),
      );
      return;
    }

    var cleanUrl = url.trim();
    if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
      cleanUrl = 'https://$cleanUrl';
    }

    final uri = Uri.parse(cleanUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $cleanUrl';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open website.')),
        );
      }
    }
  }

  Future<void> _deleteEmployee(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee?'),
        content: const Text('Are you sure you want to permanently delete this employee?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(employeeViewModelProvider.notifier).deleteEmployee(employee.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee deleted successfully.')),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeState = ref.watch(employeeViewModelProvider);
    final match = employeeState.allEmployees.where((emp) => emp.id == employee.id).toList();
    final currentEmployee = match.isNotEmpty ? match.first : employee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
        actions: [
          FavoriteButton(
            isFavorite: currentEmployee.isFavorite,
            onTap: () => ref
                .read(employeeViewModelProvider.notifier)
                .toggleFavorite(currentEmployee.id),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 650;

                  final headerWidget = DetailHeader(
                    employeeId: currentEmployee.id,
                    name: currentEmployee.name ?? '',
                    username: currentEmployee.username,
                  );

                  final contactCard = DetailCard(
                    title: 'Contact Information',
                    children: [
                      InfoTile(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: currentEmployee.email ?? 'N/A',
                      ),
                      const Divider(height: 1, indent: 48),
                      InfoTile(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: currentEmployee.phone ?? 'N/A',
                      ),
                      const Divider(height: 1, indent: 48),
                      InfoTile(
                        icon: Icons.language_rounded,
                        label: 'Website',
                        value: currentEmployee.website ?? 'N/A',
                        onTap: currentEmployee.website != null && currentEmployee.website!.isNotEmpty
                            ? () => _launchWebsite(context, currentEmployee.website)
                            : null,
                      ),
                    ],
                  );

                  final companyCard = CompanyCard(company: currentEmployee.company);
                  final addressCard = AddressCard(address: currentEmployee.address);

                  if (isWide) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: headerWidget,
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                contactCard,
                                const SizedBox(height: 16),
                                companyCard,
                                const SizedBox(height: 16),
                                addressCard,
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          headerWidget,
                          const SizedBox(height: 24),
                          contactCard,
                          const SizedBox(height: 16),
                          companyCard,
                          const SizedBox(height: 16),
                          addressCard,
                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => context.push(RouteNames.editEmployee, extra: currentEmployee),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _deleteEmployee(context, ref),
                      icon: const Icon(Icons.delete_outlined),
                      label: const Text('Delete'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
