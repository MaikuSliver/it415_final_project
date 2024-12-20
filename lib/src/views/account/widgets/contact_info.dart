import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:babysitterapp/src/constants.dart';
import 'package:babysitterapp/src/models.dart';
import 'package:babysitterapp/src/views.dart';

class ContactInformation extends StatelessWidget {
  const ContactInformation({super.key, required this.user});
  final UserAccount user;

  @override
  Widget build(BuildContext context) {
    final bool hasLocation = user.addressLatitude != null &&
        user.addressLongitude != null &&
        user.addressLatitude!.isNotEmpty &&
        user.addressLongitude!.isNotEmpty;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Contact Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (user.role != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: GlobalStyles.primaryButtonColor
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.role!.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: GlobalStyles.primaryButtonColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ContactItem(
                    icon: FluentIcons.phone_24_regular,
                    text:
                        (user.phoneNumber == null || user.phoneNumber!.isEmpty)
                            ? 'No phone number'
                            : user.phoneNumber!,
                  ),
                  const SizedBox(height: 12),
                  ContactItem(
                    icon: FluentIcons.mail_24_regular,
                    text: (user.email == null || user.email!.isEmpty)
                        ? 'No email'
                        : user.email!,
                  ),
                  const SizedBox(height: 12),
                  ContactItem(
                    icon: FluentIcons.location_24_regular,
                    text: (user.address == null || user.address!.isEmpty)
                        ? 'No address'
                        : user.address!,
                  ),
                  const SizedBox(height: 12),
                  if (hasLocation) ...<Widget>[
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 12),
                    LocationPreview(
                      latitude: double.parse(user.addressLatitude!),
                      longitude: double.parse(user.addressLongitude!),
                      hideTitle: true,
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          VerificationCard(user: user),
        ],
      ),
    );
  }
}
