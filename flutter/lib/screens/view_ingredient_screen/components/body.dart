import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/controllers/api/api.dart' as Api;
import 'package:food_toxicity_scanner/models/ingredient.dart';
import 'package:food_toxicity_scanner/models/ingredient_log.dart';
import 'package:food_toxicity_scanner/models/user.dart';
import 'package:food_toxicity_scanner/screens/edit_ingredient_screen/edit_ingredient_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../view_ingredient_screen.dart';

class Body extends StatefulWidget {
  final Ingredient ingredient;
  final UniqueKey heroKey;
  final User createdBy;

  Body({
    Key key,
    @required
    this.ingredient,
    this.heroKey,
    this.createdBy,
  }) : assert(ingredient != null),
        super(key: key);

  @override
  _BodyBuilder createState() => _BodyBuilder();
}

class _BodyBuilder extends State<Body> {
  Ingredient ingredient;
  UniqueKey heroKey;
  User createdBy;
  List<IngredientLog> ingredientLog;


  @override
  void initState() {
    super.initState();
    ingredient = widget.ingredient;
    heroKey = widget.heroKey;
    createdBy = widget.createdBy;

    if (createdBy == null) {
      ingredient.getCreatedByUser.then((user) => setState(() => createdBy = user));
    }
    Api.Ingredient.getIngredientLog(ingredient.id).then((log) => setState(() => ingredientLog = log));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Hero(
                            tag: 'viewIngredientScreenIngredientName$heroKey',
                            flightShuttleBuilder: flightShuttleBuilder,
                            child: Text(
                              ingredient.name ?? 'N/A',
                              style: TextStyle(
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                        FlatButton(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 4,),
                              Text('Edit'),
                            ],
                          ),
                          onPressed: () {
                            if (Provider.of<User>(context, listen: false).loggedInCheck(context)) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditIngredientScreen(
                                      ingredient: ingredient
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16,),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 250,
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(ingredient.description ?? 'N/A'),
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Row(
                      children: [
                        Text('Safety Rating: '),
                        Hero(
                          tag: 'viewIngredientScreenIngredientSafetyRating$heroKey',
                          flightShuttleBuilder: flightShuttleBuilder,
                          child: ingredient.safetyToImage,
                        ),
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Hero(
                            tag: 'viewIngredientScreenIngredientCreatedBy$heroKey',
                            flightShuttleBuilder: flightShuttleBuilder,
                            child: Text(
                              'Created by: ${createdBy?.name ?? 'Loading...'}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ),
                        ),
                        ingredientLog?.isEmpty ?? true ? Container()
                            : Expanded(
                            child: Text(
                              'Updated by: ${ingredientLog.first.name}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                        ),
                        SizedBox(width: 16,),
                      ],
                    ),
                    SizedBox(height: 8,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16,),
            if (ingredientLog?.isNotEmpty ?? true)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: ingredientLog?.isEmpty ?? true ?
                      [
                        Center(child: CircularProgressIndicator()),
                      ]
                          :
                      [
                        Row(
                          children: [
                            Icon(Icons.history),
                            SizedBox(width: 4,),
                            Text('History'),
                          ],
                        ),
                        SizedBox(height: 4,),
                        Expanded(
                          child: ListView.builder(
                            itemCount: ingredientLog == null ? 0 : ingredientLog.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${ingredientLog[index].name}',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
                                          ),
                                        ),
                                        ingredientLog[index].safetyToImage,
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Text(
                                      'Updated on ${DateFormat("yyyy/MM/dd 'at' h:mm a").format(ingredientLog[index].updatedAt)}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  ingredientLog[index].asIngredient.then((value) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ViewIngredientScreen(ingredient: value, createdBy: createdBy,),
                                      ),
                                    );
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              ),
          ],
        ),
      ),
    );
  }
}
