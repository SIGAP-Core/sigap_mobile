import 'package:flutter/material.dart';
import 'package:sigap_mobile/app/routes.dart';


class SigapMobile extends StatelessWidget {
  const SigapMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routes,
    );
  }
}
