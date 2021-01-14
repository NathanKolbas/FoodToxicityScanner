import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/components/ingredient_card.dart';
import 'package:food_toxicity_scanner/controllers/api/api.dart' as Api;
import 'package:food_toxicity_scanner/models/ingredient.dart';
import 'package:food_toxicity_scanner/models/user.dart';
import 'package:food_toxicity_scanner/screens/new_ingredient_screen/new_ingredient_screen.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IngredientSearch();
  }
}

class IngredientSearch extends StatefulWidget {
  @override
  _IngredientSearchState createState() => _IngredientSearchState();
}

class _IngredientSearchState extends State<IngredientSearch> {
  // controls the text label we use as a search bar
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Future<List<Ingredient>> futureIngredients;
  List ingredients = new List();
  List filteredIngredients = new List();
  ScrollController _scrollController = ScrollController();

  _IngredientSearchState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredIngredients = ingredients;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    futureIngredients = Api.Ingredient.getIngredients();
    super.initState();
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(context),
        // Expanded(
          FutureBuilder<List<Ingredient>>(
            future: futureIngredients,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ingredients = snapshot.data;
                filteredIngredients = ingredients;
                return  _buildList();
              } else if (snapshot.hasError) {
                return Text("Unable to get ingredients. Error: ${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        // ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(18)),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: _filter,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            labelText: 'Search for an ingredient',
            hintText: 'Search...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: _buildSortMenu(context),
          ),
        ),
      ),
    );
  }

  // I do not know why we need the "as int". Seems like for some reason it isn't
  // returning back as an int which causes it to crash even though it should be already.
  final _sortItems = {
    'Ascending': (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()) as int,
    'Descending': (b, a) => a.name.toLowerCase().compareTo(b.name.toLowerCase()) as int,
    'Newly created': (b, a) => a.createdAt.compareTo(b.createdAt) as int,
    'Oldest created': (a, b) => a.createdAt.compareTo(b.createdAt) as int,
    'Newest updated': (a, b) => a.updatedAt.compareTo(b.updatedAt) as int,
    'Oldest updated': (b, a) => a.updatedAt.compareTo(b.updatedAt) as int,
    'Safe': (a, b) => a.safetyToInt.compareTo(b.safetyToInt) as int,
    'Avoid': (b, a) => a.safetyToInt.compareTo(b.safetyToInt) as int,
  };

  Widget _buildSortMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.sort),
      itemBuilder: (BuildContext context) {
        return _sortItems.keys.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
      onSelected: (key) => setState(() {
        filteredIngredients.sort(_sortItems[key]);
      }),
    );
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < ingredients.length; i++) {
        if (ingredients[i].name.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(ingredients[i]);
        }
      }
      filteredIngredients = tempList;

      if (filteredIngredients.length == 0) {
        return Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(18)),
            child: OutlineButton(
              child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Unable to find ingredient. Would you like to add the new ingredient \"$_searchText\"?",
                      textAlign: TextAlign.center,
                    ),
                  )
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
                        name: _searchText,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      }
    }

    return Expanded(
      child: DraggableScrollbar.rrect(
        controller: _scrollController,
        backgroundColor: Theme.of(context).primaryColor,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: ingredients == null ? 0 : filteredIngredients.length,
          itemBuilder: (BuildContext context, int index) {
            return IngredientCard(
              ingredient: filteredIngredients[index],
              heroKey: UniqueKey(),
              // name: filteredIngredients[index].name,
              // description: filteredIngredients[index].description,
              // safetyRating: Ingredient.safetyRatingEnum[filteredIngredients[index].safetyRating],
            );
          },
        ),
      ),
    );
  }
}
