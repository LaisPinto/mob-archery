import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/app/modules/auth/enums/auth_status.dart';
import 'package:mob_archery/app/modules/auth/stores/auth_state.dart';
import 'package:mobx/mobx.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  late final ReactionDisposer _statusReaction;

  @override
  void initState() {
    super.initState();
    final authState = Modular.get<AuthState>();
    _statusReaction = reaction(
      (_) => authState.authStatus,
      (_) => WidgetsBinding.instance.addPostFrameCallback(
        (_) => _redirect(authState),
      ),
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _statusReaction();
    super.dispose();
  }

  void _redirect(AuthState authState) {
    if (!mounted) return;
    switch (authState.authStatus) {
      case AuthStatus.authenticated:
        Modular.to.navigate('/home/');
      case AuthStatus.emailVerificationPending:
        Modular.to.navigate('/auth/email-verification');
      case AuthStatus.unauthenticated:
        Modular.to.navigate('/auth/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
