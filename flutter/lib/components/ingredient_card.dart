import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/models/ingredient.dart';
import 'package:food_toxicity_scanner/models/user.dart';
import 'package:food_toxicity_scanner/screens/new_ingredient_screen/new_ingredient_screen.dart';
import 'package:food_toxicity_scanner/screens/view_ingredient_screen/view_ingredient_screen.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class IngredientCard extends StatefulWidget {
  final Ingredient ingredient;
  final UniqueKey heroKey;

  const IngredientCard({
    Key key,
    @required
    this.ingredient,
    this.heroKey,
  }) : assert(ingredient != null),
        super(key: key);

  @override
  _IngredientCardBuilder createState() => _IngredientCardBuilder();
}

class _IngredientCardBuilder extends State<IngredientCard> {
  Ingredient ingredient;
  UniqueKey heroKey;
  User createdBy;

  @override
  Widget build(BuildContext context) {
    // Do it in here instead of initialize as this way each time it is built
    // it will get the new information.
    ingredient = widget.ingredient;
    heroKey = widget.heroKey;

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        onExpansionChanged: (open) async {
          if (!open) return;

          if (ingredient.id != null) createdBy = await ingredient.getCreatedByUser;
          setState(() {});
        },
        expandedAlignment: Alignment.topLeft,
        title: Row(
          children: [
            Hero(
              tag: 'viewIngredientScreenIngredientSafetyRating$heroKey',
              flightShuttleBuilder: flightShuttleBuilder,
              child: ingredient.safetyToImage,
            ),
            SizedBox(width: 18.0,),
            Expanded(
              child: Hero(
                tag: 'viewIngredientScreenIngredientName$heroKey',
                flightShuttleBuilder: flightShuttleBuilder,
                child: Text(ingredient.name ?? 'N/A', style: TextStyle(color: Colors.black),),
              ),
            ),
          ],
        ),
        children: buildExpansionBody(),
      ),
    );
  }

  List<Widget> buildExpansionBody() {
    return ingredient.id == null ?
    [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0, bottom: 16.0),
        child: OutlineButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "The ingredient is not currently in the database. Would you like to add the new ingredient \"${ingredient.name}\"?",
              textAlign: TextAlign.center,
            ),
          ),
          highlightedBorderColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          borderSide: BorderSide(
              color: Colors.black,
              width: 1,
              style: BorderStyle.solid
          ),
          onPressed: () {
            if (Provider.of<User>(context, listen: false).loggedInCheck(context)) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewIngredientScreen(
                    name: ingredient.name,
                  ),
                ),
              );
            }
          },
        ),
      ),
    ]
    :
    [
      Padding(
        padding: EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0,),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 250,
          ),
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                ingredient.description ?? 'N/A',
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(right: 8.0, bottom: 8.0, left: 16.0,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Hero(
              tag: 'viewIngredientScreenIngredientCreatedBy$heroKey',
              flightShuttleBuilder: flightShuttleBuilder,
              child: Text(
                'Created by: ${createdBy?.name ?? 'Loading...'}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            FlatButton(
              color: Colors.transparent,
              child: Row(
                children: [
                  Icon(Icons.read_more),
                  SizedBox(width: 4,),
                  Text('More'),
                ],
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewIngredientScreen(
                      ingredient: ingredient,
                      heroKey: heroKey,
                      // createdBy: createdBy,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ];
  }
}
