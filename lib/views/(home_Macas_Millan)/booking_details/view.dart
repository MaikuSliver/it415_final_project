import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

import 'package:babysitterapp/controllers/authentication_controller.dart';
import 'package:babysitterapp/core/helper/check_user.dart';
import 'package:babysitterapp/core/constants/styles.dart';

import 'widgets/card_details.dart';
import 'widgets/info_card.dart';

class BookingDetailNotification extends HookConsumerWidget with GlobalStyles {
  BookingDetailNotification({super.key});

  final int children = 5;
  final DateTime date = DateTime.parse('2024-11-11');
  final String time = '12:15 AM - 4:20 AM';
  final bool stayIn = true;
  final String address = 'Home';
  final String details = 'Bring Your ID';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authController);

    useEffect(() {
      checkUserAndRedirect(context, ref);
      return null;
    }, <Object?>[]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            infoCard(
              title: 'Booking Summary',
              children: <Widget>[
                cardDetails('Children', children.toString()),
                cardDetails('Date', '${date.toLocal()}'.split(' ')[0]),
                cardDetails('Time', time),
                cardDetails('Stay in', stayIn ? 'Yes' : 'No'),
              ],
            ),
            const SizedBox(height: 16),
            infoCard(
              title: 'Address Information',
              children: <Widget>[
                cardDetails('Address', address),
                cardDetails('Details', details),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
