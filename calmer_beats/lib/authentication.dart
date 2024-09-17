// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(!loggedIn ? Icons.login : Icons.logout),
          onPressed: () {
            !loggedIn ? Navigator.pushNamed(context, '/sign-in') : signOut();
          },
          tooltip: !loggedIn ? 'Login' : 'Logout',
        ),
        Visibility(
          visible: loggedIn,
          child: IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              //firebase profile
              Navigator.pushNamed(context, '/profile');
            },
            tooltip: 'Profile',
          ),
        )
      ],
    );
  }
}

