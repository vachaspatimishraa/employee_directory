import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/employee_model.dart';
import '../model/address_model.dart';
import '../model/company_model.dart';
import '../provider/employee_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class EditEmployeeScreen extends ConsumerStatefulWidget {
  final EmployeeModel employee;

  const EditEmployeeScreen({super.key, required this.employee});

  @override
  ConsumerState<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends ConsumerState<EditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _websiteController;
  late TextEditingController _companyNameController;
  late TextEditingController _companyCatchPhraseController;
  late TextEditingController _companyBsController;
  late TextEditingController _streetController;
  late TextEditingController _suiteController;
  late TextEditingController _cityController;
  late TextEditingController _zipcodeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _usernameController = TextEditingController(text: widget.employee.username);
    _emailController = TextEditingController(text: widget.employee.email);
    _phoneController = TextEditingController(text: widget.employee.phone);
    _websiteController = TextEditingController(text: widget.employee.website);
    _companyNameController = TextEditingController(text: widget.employee.company?.name);
    _companyCatchPhraseController = TextEditingController(text: widget.employee.company?.catchPhrase);
    _companyBsController = TextEditingController(text: widget.employee.company?.bs);
    _streetController = TextEditingController(text: widget.employee.address?.street);
    _suiteController = TextEditingController(text: widget.employee.address?.suite);
    _cityController = TextEditingController(text: widget.employee.address?.city);
    _zipcodeController = TextEditingController(text: widget.employee.address?.zipcode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _companyNameController.dispose();
    _companyCatchPhraseController.dispose();
    _companyBsController.dispose();
    _streetController.dispose();
    _suiteController.dispose();
    _cityController.dispose();
    _zipcodeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final updatedEmployee = widget.employee.copyWith(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        website: _websiteController.text.trim(),
        company: CompanyModel(
          name: _companyNameController.text.trim(),
          catchPhrase: _companyCatchPhraseController.text.trim(),
          bs: _companyBsController.text.trim(),
        ),
        address: AddressModel(
          street: _streetController.text.trim(),
          suite: _suiteController.text.trim(),
          city: _cityController.text.trim(),
          zipcode: _zipcodeController.text.trim(),
          geo: widget.employee.address?.geo,
        ),
      );

      await ref.read(employeeViewModelProvider.notifier).addEmployee(updatedEmployee);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee updated successfully.')),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _nameController,
                labelText: 'Full Name *',
                hintText: 'Enter full name',
                prefixIcon: Icons.person_outline,
                validator: (value) => Validators.validateRequired(value, 'Name'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _usernameController,
                labelText: 'Username',
                hintText: 'Enter username',
                prefixIcon: Icons.alternate_email,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _emailController,
                labelText: 'Email *',
                hintText: 'Enter email address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validators.validateEmail(value),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _phoneController,
                labelText: 'Phone',
                hintText: 'Enter phone number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _websiteController,
                labelText: 'Website',
                hintText: 'Enter website URL',
                prefixIcon: Icons.language,
              ),
              const SizedBox(height: 24),
              const Text('Company Details', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              AppTextField(
                controller: _companyNameController,
                labelText: 'Company Name',
                hintText: 'Enter company name',
                prefixIcon: Icons.business,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _companyCatchPhraseController,
                labelText: 'Catch Phrase',
                hintText: 'Enter catch phrase',
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _companyBsController,
                labelText: 'Business Scope',
                hintText: 'Enter business scope',
              ),
              const SizedBox(height: 24),
              const Text('Address Details', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _streetController,
                      labelText: 'Street',
                      hintText: 'Street',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppTextField(
                      controller: _suiteController,
                      labelText: 'Suite',
                      hintText: 'Suite',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _cityController,
                      labelText: 'City',
                      hintText: 'City',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppTextField(
                      controller: _zipcodeController,
                      labelText: 'Zipcode',
                      hintText: 'Zipcode',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'Save Changes',
                onPressed: _save,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
