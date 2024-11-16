import 'package:flutter/material.dart';

import 'package:babysitterapp/models/user_account.dart';

double calculateProfileCompletion(UserAccount user) {
  final List<String?> userFields = <String?>[
    user.profileImg,
    user.name,
    user.address,
    user.description,
    user.phoneNumber,
    user.validId,
  ];

  final int completedFields =
      userFields.where((String? field) => field?.isNotEmpty ?? false).length;
  final int totalFields = userFields.length;

  return (completedFields / totalFields) * 100;
}

class ProfileCompletion extends StatelessWidget {
  const ProfileCompletion({super.key, required this.profileCompletion});

  final double profileCompletion;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 18),
        const Text(
          'Edit Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: profileCompletion / 100,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        const SizedBox(height: 16),
        Text(
          'Profile Completion: ${profileCompletion.toStringAsFixed(0)}%',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}