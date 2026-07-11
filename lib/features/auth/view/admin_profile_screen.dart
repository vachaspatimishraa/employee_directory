import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/auth_provider.dart';
import '../../employee/widgets/employee_avatar.dart';
import '../../employee/widgets/detail_card.dart';
import '../../employee/widgets/info_tile.dart';
import '../../../core/widgets/app_text_field.dart';

class AdminProfileScreen extends ConsumerStatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  ConsumerState<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends ConsumerState<AdminProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _companyController;
  late TextEditingController _designationController;
  late TextEditingController _websiteController;
  late TextEditingController _streetController;
  late TextEditingController _suiteController;
  late TextEditingController _cityController;
  late TextEditingController _zipcodeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _companyController = TextEditingController();
    _designationController = TextEditingController();
    _websiteController = TextEditingController();
    _streetController = TextEditingController();
    _suiteController = TextEditingController();
    _cityController = TextEditingController();
    _zipcodeController = TextEditingController();

    // Populate controllers after frame binding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _populateControllers();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _designationController.dispose();
    _websiteController.dispose();
    _streetController.dispose();
    _suiteController.dispose();
    _cityController.dispose();
    _zipcodeController.dispose();
    super.dispose();
  }

  void _populateControllers() {
    final profile = ref.read(adminProfileViewModelProvider).profile;
    if (profile != null) {
      _nameController.text = profile.name ?? '';
      _phoneController.text = profile.phone ?? '';
      _companyController.text = profile.company ?? '';
      _designationController.text = profile.designation ?? '';
      _websiteController.text = profile.website ?? '';
      _streetController.text = profile.street ?? '';
      _suiteController.text = profile.suite ?? '';
      _cityController.text = profile.city ?? '';
      _zipcodeController.text = profile.zipcode ?? '';
    }
  }

  Future<void> _launchWebsite(String? url) async {
    if (url == null || url.trim().isEmpty) return;
    var cleanUrl = url.trim();
    if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
      cleanUrl = 'https://$cleanUrl';
    }
    final uri = Uri.parse(cleanUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch';
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open website.')),
        );
      }
    }
  }

  void _saveChanges() async {
    final profileState = ref.read(adminProfileViewModelProvider);
    if (profileState.profile == null) return;

    final updated = profileState.profile!.copyWith(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      company: _companyController.text.trim(),
      designation: _designationController.text.trim(),
      website: _websiteController.text.trim(),
      street: _streetController.text.trim(),
      suite: _suiteController.text.trim(),
      city: _cityController.text.trim(),
      zipcode: _zipcodeController.text.trim(),
    );

    final success = await ref.read(adminProfileViewModelProvider.notifier).saveProfile(updated);
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
      }
    } else {
      final error = ref.read(adminProfileViewModelProvider).errorMessage;
      if (mounted && error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(adminProfileViewModelProvider);
    final theme = Theme.of(context);

    if (profileState.profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final profile = profileState.profile!;
    final isEditing = profileState.isEditing;

    // Check if the profile is newly created and needs completion
    final isFirstLogin = profile.name == null || profile.name!.trim().isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                _populateControllers();
                ref.read(adminProfileViewModelProvider.notifier).setEditMode(false);
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Center(
                child: EmployeeAvatar(
                  name: profile.name != null && profile.name!.isNotEmpty
                      ? profile.name!
                      : 'Admin',
                  size: 110,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                profile.name != null && profile.name!.isNotEmpty
                    ? profile.name!
                    : 'Administrator',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                profile.designation != null && profile.designation!.isNotEmpty
                    ? profile.designation!
                    : 'Administrator',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (isFirstLogin && !isEditing) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.errorContainer),
                  ),
                  child: Text(
                    'Complete Your Profile',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              if (isEditing) ...[
                // Edit Form fields
                DetailCard(
                  title: 'Required Information',
                  children: [
                    TextFormField(
                      initialValue: profile.email,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Email (Read Only)',
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _nameController,
                      labelText: 'Full Name',
                      hintText: 'Enter full name',
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DetailCard(
                  title: 'Professional Details',
                  children: [
                    AppTextField(
                      controller: _companyController,
                      labelText: 'Company',
                      hintText: 'Enter company name',
                      prefixIcon: Icons.business_rounded,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _designationController,
                      labelText: 'Designation',
                      hintText: 'Enter job designation',
                      prefixIcon: Icons.badge_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DetailCard(
                  title: 'Contact Info',
                  children: [
                    AppTextField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      hintText: 'Enter phone number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _websiteController,
                      labelText: 'Website',
                      hintText: 'Enter website URL',
                      prefixIcon: Icons.language_rounded,
                      keyboardType: TextInputType.url,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DetailCard(
                  title: 'Address Info',
                  children: [
                    AppTextField(
                      controller: _streetController,
                      labelText: 'Street',
                      hintText: 'Enter street',
                      prefixIcon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _suiteController,
                      labelText: 'Suite',
                      hintText: 'Enter suite/apartment number',
                      prefixIcon: Icons.door_front_door_outlined,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _cityController,
                      labelText: 'City',
                      hintText: 'Enter city',
                      prefixIcon: Icons.location_city_rounded,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _zipcodeController,
                      labelText: 'Zipcode',
                      hintText: 'Enter zip code',
                      prefixIcon: Icons.pin_drop_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: _saveChanges,
                    icon: profileState.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.save_rounded),
                    label: const Text('Save Changes'),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // View Mode Profile Cards
                DetailCard(
                  title: 'Contact Details',
                  children: [
                    InfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: profile.email,
                    ),
                    const Divider(height: 1, indent: 48),
                    InfoTile(
                      icon: Icons.person_outline_rounded,
                      label: 'Full Name',
                      value: profile.name?.isNotEmpty == true ? profile.name! : 'N/A',
                    ),
                    const Divider(height: 1, indent: 48),
                    InfoTile(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: profile.phone?.isNotEmpty == true ? profile.phone! : 'N/A',
                    ),
                    const Divider(height: 1, indent: 48),
                    InfoTile(
                      icon: Icons.language_rounded,
                      label: 'Website',
                      value: profile.website?.isNotEmpty == true ? profile.website! : 'N/A',
                      onTap: profile.website?.isNotEmpty == true
                          ? () => _launchWebsite(profile.website)
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DetailCard(
                  title: 'Company Information',
                  children: [
                    InfoTile(
                      icon: Icons.business_rounded,
                      label: 'Company',
                      value: profile.company?.isNotEmpty == true ? profile.company! : 'N/A',
                    ),
                    const Divider(height: 1, indent: 48),
                    InfoTile(
                      icon: Icons.badge_outlined,
                      label: 'Designation',
                      value: profile.designation?.isNotEmpty == true ? profile.designation! : 'N/A',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DetailCard(
                  title: 'Address Information',
                  children: [
                    InfoTile(
                      icon: Icons.location_on_outlined,
                      label: 'Street',
                      value: profile.street?.isNotEmpty == true ? profile.street! : 'N/A',
                    ),
                    const Divider(height: 1, indent: 48),
                    InfoTile(
                      icon: Icons.door_front_door_outlined,
                      label: 'Suite',
                      value: profile.suite?.isNotEmpty == true ? profile.suite! : 'N/A',
                    ),
                    const Divider(height: 1, indent: 48),
                    InfoTile(
                      icon: Icons.location_city_rounded,
                      label: 'City',
                      value: profile.city?.isNotEmpty == true ? profile.city! : 'N/A',
                    ),
                    const Divider(height: 1, indent: 48),
                    InfoTile(
                      icon: Icons.pin_drop_outlined,
                      label: 'Zipcode',
                      value: profile.zipcode?.isNotEmpty == true ? profile.zipcode! : 'N/A',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: () {
                      _populateControllers();
                      ref.read(adminProfileViewModelProvider.notifier).setEditMode(true);
                    },
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Edit Profile'),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
