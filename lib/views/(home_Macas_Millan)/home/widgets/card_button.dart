import 'package:flutter/material.dart';

import 'package:babysitterapp/core/helper/goto_page.dart';

import 'package:babysitterapp/views/(settings_JK_Gerald)/babysitter_profile/view.dart';

Widget babySitterCardButton(BuildContext context) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: () {
            goToPage(context, const BabysitterProfile(), 'rightToLeftWithFade');
          },
          child: const Text('View profile'),
        ),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Message'),
        )
      ],
    );