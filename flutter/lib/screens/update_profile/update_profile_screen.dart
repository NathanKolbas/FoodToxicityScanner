import 'package:flutter/material.dart';

import 'components/body.dart';

class UpdateProfileScreen extends StatelessWidget {
  // No route name as we will pass data and this seems easier for now
  final int id;

  UpdateProfileScreen(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(id),
    );
  }
}
