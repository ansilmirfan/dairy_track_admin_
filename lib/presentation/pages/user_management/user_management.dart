// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String entityType = 'Driver';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  String assignedDriver = '';
  String assignedRoute = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Data Management'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField(
                  value: entityType,
                  onChanged: (String? newValue) {
                    setState(() {
                      entityType = newValue!;
                    });
                  },
                  items: <String>['Driver', 'Store']
                      .map((String value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Entity Type'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: idController,
                  decoration: InputDecoration(
                      labelText:
                          entityType == 'Driver' ? 'Employee ID' : 'Store ID'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                if (entityType == 'Driver')
                  TextFormField(
                    controller: licenseController,
                    decoration:
                        const InputDecoration(labelText: 'License Number'),
                  ),
                if (entityType == 'Store') ...[
                  TextFormField(
                    controller: contactPersonController,
                    decoration:
                        const InputDecoration(labelText: 'Contact Person'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: contactNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Contact Number'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(
                      labelText: entityType == 'Driver'
                          ? 'Home Location'
                          : 'Store Location'),
                ),
                const SizedBox(height: 16),
                if (entityType == 'Driver')
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Assigned Route'),
                    onChanged: (value) {
                      assignedRoute = value;
                    },
                  ),
                if (entityType == 'Store')
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Assigned Driver'),
                    onChanged: (value) {
                      assignedDriver = value;
                    },
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
