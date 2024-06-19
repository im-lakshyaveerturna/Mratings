import 'package:flutter/material.dart';
import 'package:mratings/theme/thememanager.dart';
import 'package:provider/provider.dart';
import 'package:mratings/services/API.dart';

class Error extends StatefulWidget {
  Error({super.key});


  @override
  State<Error> createState() => _ErrorState();
}

class _ErrorState extends State<Error> {
  final TextEditingController _controller = TextEditingController();
  MovieData movieData = MovieData();
  bool isLoading = false;
  int count = 0;
  String image = 'images/noresult_light.png';


  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    if (themeManager.thememode == ThemeMode.dark){
      setState(() {
        image = 'images/noresult_dark.png';
      });
    }
    if (themeManager.thememode == ThemeMode.light){
      setState(() {
        image = 'images/noresult_light.png';
      });
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(
            value: themeManager.thememode == ThemeMode.dark,
            onChanged: (value) {
              themeManager.toggleTheme(value);
            },
          ),
        ],
        title: Card(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search a Movie/Show',
              icon: Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Icon(Icons.search),
              ),
              border: InputBorder.none,
            ),
            onSubmitted: (String query) {
              setState(() {
                isLoading = true;
              });
              _fetchMovieData(query);
            },
          ),
        ),
      ),
      body:
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
    );
  }
  void _fetchMovieData(String query) async {
    try {
      await movieData.fetchMovies(query);
      if (movieData.map1.isNotEmpty && movieData.map1['d'] != null &&
          movieData.map1['d'].isNotEmpty) {
        await movieData.fetchAdditionalData(movieData.map1['d'][0]['id']);

        if (!isLoading && count == 1 && (
            movieData.map1['d'] == null || movieData.map1['d'].isEmpty ||
                movieData.map2['description'] == null &&
                    movieData.map2['imdb_rating'] == null &&
                    movieData.map2['stars'] == null)) {
          Navigator.pushNamed(context, '/error');
        }
      }
    } catch (error) {
      print('Error fetching movie data: $error');
    } finally {
      setState(() {
        isLoading = false;
        count = 1;
      });
      if (!isLoading && movieData.map1.isNotEmpty &&
          movieData.map1['d'] != null && count == 1 &&
          movieData.map2['description'] != null &&
          movieData.map2['imdb_rating'] != null &&
          movieData.map2['stars'] != null) {
        Navigator.pushNamed(
          context,
          '/content',
          arguments: movieData,);
      }


      if (!isLoading && count == 1 && (
          movieData.map1['d'] == null || movieData.map1['d'].isEmpty ||
              movieData.map2['description'] == null &&
                  movieData.map2['imdb_rating'] == null &&
                  movieData.map2['stars'] == null)) {
        Navigator.pushNamed(context, '/error');
      }
    }
  }

}

