import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/components/home_appbar_button.dart';
import 'package:food_toxicity_scanner/components/ingredient_card.dart';
import 'package:food_toxicity_scanner/models/ingredient.dart';
import 'package:food_toxicity_scanner/controllers/api/api.dart' as Api;
import 'package:food_toxicity_scanner/screens/home/home_screen.dart';

class OcrTextDetail extends StatefulWidget {
  final String ocrText;

  OcrTextDetail(this.ocrText);

  @override
  _OcrTextDetailState createState() => _OcrTextDetailState();
}

class _OcrTextDetailState extends State<OcrTextDetail> {
  Future<List<Ingredient>> futureIngredient;

  @override
  void initState() {
    super.initState();
    futureIngredient = Api.Ingredient.scan(widget.ocrText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingredients'),
        actions: [
          homeAppbarButton(context),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Ingredient>>(
          future: futureIngredient,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> columnList = List();
              snapshot.data.forEach((element) {
                columnList.add(IngredientCard(
                  ingredient: element,
                  heroKey: UniqueKey(),
                    // name: element.name == null ? "NA" : element.name,
                    // description: element.description == null ? "NA" : element.description,
                    // safetyRating: Ingredient.safetyRatingEnum[element.safetyRating],
                ));
                columnList.add(Padding(padding: const EdgeInsets.only(bottom: 4.0)));
              });
              return ListView(children: columnList);
              // return Text(snapshot.data[0].name);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
