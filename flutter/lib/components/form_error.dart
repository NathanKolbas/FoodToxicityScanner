import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../size_config.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key key,
    @required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index])),
    );
  }

  Row formErrorText({String error}) {
    return Row(
      children: [
        Icon(Icons.error_outline, color: Colors.red, size: getProportionateScreenWidth(14),),
        SizedBox(
          width: getProportionateScreenWidth(10),
        ),
        Flexible(child: Text(error)),
      ],
    );
  }
}
