import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:maverick/features/dashboard/home.dart';
import 'package:maverick/models/group.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _membersController = TextEditingController();
  final _treasurerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contributionController = TextEditingController();
  final _meetingFrequencyController = TextEditingController();

  String _groupType = 'Investment Group';
  String _contributionFrequency = 'Monthly';
  bool _isLoading = false;

  final List<String> _groupTypes = [
    'Investment Group',
    'SACCO',
    'Savings Group',
    'Chama',
    'Cooperative',
  ];

  final List<String> _frequencies = [
    'Weekly',
    'Bi-weekly',
    'Monthly',
    'Quarterly',
  ];

  void createGroup() async {
    final messenger = ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    try {
      var box = Hive.box<GroupModel>('groups');
      await box.add(
        GroupModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text.trim(),
          numberOfMembers: int.parse(_membersController.text),
          treasurer: _treasurerController.text.trim(),
          createdAt: DateTime.now(),
          description: _descriptionController.text.trim(),
          groupType: _groupType,
          contributionAmount:
              double.tryParse(_contributionController.text) ?? 0.0,
          contributionFrequency: _contributionFrequency,
          meetingFrequency: _meetingFrequencyController.text.trim(),
          groupBal: 0,
        ),
      );

      // Navigate back or show success message
      // Navigator.of(context).pop();
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));

      messenger.showSnackBar(
        const SnackBar(content: Text('Group created successfully!')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Error creating group: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _membersController.dispose();
    _treasurerController.dispose();
    _descriptionController.dispose();
    _contributionController.dispose();
    _meetingFrequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Group"), elevation: 0),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Group Name
                        _buildLabel("Group Name"),
                        TextFormField(
                          controller: _nameController,
                          decoration: _buildInputDecoration("Enter group name"),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter group name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Group Type Dropdown
                        _buildLabel("Group Type"),
                        DropdownButtonFormField<String>(
                          value: _groupType,
                          decoration: _buildInputDecoration(
                            "Select group type",
                          ),
                          items: _groupTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _groupType = newValue!;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // Number of Members
                        _buildLabel("Expected Number of Members"),
                        TextFormField(
                          controller: _membersController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: _buildInputDecoration(
                            "Enter number of members",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter number of members';
                            }
                            final number = int.tryParse(value);
                            if (number == null || number <= 0) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Treasurer/Admin
                        _buildLabel("Treasurer/Admin Name"),
                        TextFormField(
                          controller: _treasurerController,
                          decoration: _buildInputDecoration(
                            "Enter treasurer name",
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter treasurer name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Contribution Amount
                        _buildLabel("Monthly Contribution Amount (Optional)"),
                        TextFormField(
                          controller: _contributionController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          decoration: _buildInputDecoration(
                            "Enter amount (e.g., 5000)",
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Contribution Frequency
                        _buildLabel("Contribution Frequency"),
                        DropdownButtonFormField<String>(
                          value: _contributionFrequency,
                          decoration: _buildInputDecoration("Select frequency"),
                          items: _frequencies.map((String frequency) {
                            return DropdownMenuItem<String>(
                              value: frequency,
                              child: Text(frequency),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _contributionFrequency = newValue!;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // Meeting Schedule
                        _buildLabel("Meeting Schedule (Optional)"),
                        TextFormField(
                          controller: _meetingFrequencyController,
                          decoration: _buildInputDecoration(
                            "e.g., Every first Saturday",
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Description
                        _buildLabel("Group Description"),
                        TextFormField(
                          controller: _descriptionController,
                          minLines: 3,
                          maxLines: 5,
                          maxLength: 500,
                          keyboardType: TextInputType.multiline,
                          decoration: _buildInputDecoration(
                            "Describe your group's purpose and goals",
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter group description';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        // Create Group Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : createGroup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(255, 144, 94, 1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Create Group",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.all(16),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          width: 2,
          color: Color.fromRGBO(255, 144, 94, 1),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
