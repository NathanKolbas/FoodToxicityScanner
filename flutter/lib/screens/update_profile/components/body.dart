import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/controllers/api/api.dart' as Api;
import 'package:food_toxicity_scanner/models/user.dart' as Model;
import 'package:food_toxicity_scanner/screens/update_profile/components/update_profile_form.dart';

import '../../../size_config.dart';

class Body extends StatefulWidget {
  final int id;

  Body(this.id);

  @override
  _Body createState() => new _Body();
}

class _Body extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: FutureBuilder<Model.User>(
        future: Api.User.getUser(id: widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildForm(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildForm(Model.User user) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(28),
        ),
        child: UpdateProfileForm(user: user),
      ),
    );
  }
}
