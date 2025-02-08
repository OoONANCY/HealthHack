import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class TeamEntryScreen extends StatefulWidget {
  const TeamEntryScreen({super.key});

  @override
  State<TeamEntryScreen> createState() => _TeamEntryScreenState();
}

class _TeamEntryScreenState extends State<TeamEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNumberController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitTeamNumber() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final teamDoc = await FirebaseFirestore.instance
          .collection('teams')
          .doc(_teamNumberController.text)
          .get();

      if (mounted) {
        setState(() => _isLoading = false);

        if (teamDoc.exists) {
          context.go('/team-info/${_teamNumberController.text}');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Team not found'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Team Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _teamNumberController,
                decoration: const InputDecoration(
                  labelText: 'Team Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a team number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitTeamNumber,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _teamNumberController.dispose();
    super.dispose();
  }
}