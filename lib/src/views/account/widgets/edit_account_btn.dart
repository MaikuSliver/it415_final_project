import 'package:babysitterapp/src/components.dart';
import 'package:flutter/material.dart';

import 'package:babysitterapp/src/constants.dart';
import 'package:babysitterapp/src/helpers.dart';
import 'package:babysitterapp/src/models.dart';
import 'package:babysitterapp/src/views.dart';

class EditAccountButton extends StatelessWidget {
  const EditAccountButton({super.key, required this.user});

  final UserAccount user;

  bool get isVerified =>
      user.emailVerified != null && user.validIdVerified != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(width: 40),
              CachedAvatar(
                imageUrl: user.profileImg,
                showOnlineStatus: true,
                isOnline: user.onlineStatus,
                showVerificationStatus: true,
                isVerified: isVerified,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.name ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email ?? 'No Email',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: isVerified
                ? ElevatedButton.icon(
                    onPressed: () {
                      CustomRouter.navigateToWithTransition(
                        EditAccountView(user: user),
                        'rightToLeftWithFade',
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          GlobalStyles.primaryButtonColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text(
                      'Edit Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: () {
                      // CustomRouter.navigateToWithTransition(
                      //   const VerificationView(),
                      //   'rightToLeftWithFade',
                      // );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                    icon: const Icon(Icons.warning_amber_rounded, size: 20),
                    label: const Text(
                      'Verify Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
