import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/employee_provider.dart';
import '../widgets/detail_header.dart';
import '../widgets/detail_card.dart';
import '../widgets/company_card.dart';
import '../widgets/address_card.dart';
import '../widgets/map_button.dart';
import '../widgets/favorite_button.dart';
import '../widgets/info_tile.dart';

class EmployeeDetailScreen extends ConsumerWidget {
  final int employeeId;

  const EmployeeDetailScreen({super.key, required this.employeeId});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeState = ref.watch(employeeViewModelProvider);

    // Find the employee from the state
    EmployeeModel? employee;
    try {
      employee = employeeState.allEmployees.firstWhere((emp) => emp.id == employeeId);
    } catch (_) {
      try {
        employee = employeeState.employees.firstWhere((emp) => emp.id == employeeId);
      } catch (_) {
        employee = null;
      }
    }

    if (employee == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Employee Details')),
        body: const Center(
          child: Text('Employee details not found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
        actions: [
          FavoriteButton(
            isFavorite: employee.isFavorite,
            onTap: () => ref
                .read(employeeViewModelProvider.notifier)
                .toggleFavorite(employee.id),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 650;

            final headerWidget = DetailHeader(
              employeeId: employee.id,
              name: employee.name ?? '',
              username: employee.username,
            );

            final contactCard = DetailCard(
              title: 'Contact Information',
              children: [
                InfoTile(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: employee.email ?? 'N/A',
                ),
                const Divider(height: 1, indent: 48),
                InfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: employee.phone ?? 'N/A',
                ),
                const Divider(height: 1, indent: 48),
                InfoTile(
                  icon: Icons.language_rounded,
                  label: 'Website',
                  value: employee.website ?? 'N/A',
                  onTap: employee.website != null && employee.website!.isNotEmpty
                      ? () => _launchWebsite(context, employee.website)
                      : null,
                ),
              ],
            );

            final companyCard = CompanyCard(company: employee.company);
            final addressCard = AddressCard(address: employee.address);

            final mapButton = MapButton(
              latitude: employee.address?.geo?.lat,
              longitude: employee.address?.geo?.lng,
            );

            if (isWide) {
              // Two-column layout for tablets and wide screens
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          headerWidget,
                          const SizedBox(height: 32),
                          mapButton,
                        ],
                      ),
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
              // Single column layout for mobile/small screens
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
                    const SizedBox(height: 24),
                    mapButton,
                    const SizedBox(height: 16),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
