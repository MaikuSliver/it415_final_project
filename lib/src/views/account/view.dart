import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:babysitterapp/src/providers.dart';
import 'package:babysitterapp/src/constants.dart';
import 'package:babysitterapp/src/models.dart';
import 'package:babysitterapp/src/views.dart';

class AccountView extends HookConsumerWidget with GlobalStyles {
  AccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authControllerService);

    Future<void> handleRefresh() async {
      if (authState.user?.id == null) return;
      await ref
          .read(authControllerService.notifier)
          .getUserData(authState.user!.id!);
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: authState.user == null
          ? const Center(
              child: CircularProgressIndicator(
                color: GlobalStyles.primaryButtonColor,
              ),
            )
          : RefreshIndicator(
              onRefresh: handleRefresh,
              color: GlobalStyles.primaryButtonColor,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.white,
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          EditAccountButton(user: authState.user!),
                          if (authState.user!.description != null &&
                              authState.user!.description!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 16.0,
                              ),
                              child: BioCard(
                                primaryButtonColor:
                                    GlobalStyles.primaryButtonColor,
                                authState: authState,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ContactInformation(user: authState.user!),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: LogoutButton(),
                    ),
                    const SizedBox(height: 140),
                  ],
                ),
              ),
            ),
    );
  }
}
