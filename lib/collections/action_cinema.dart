import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mratings/theme/thememanager.dart';
import 'package:mratings/services/API.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Movie {
  final String title;
  final String director;
  final int year;

  Movie(this.title, this.director, this.year);
}

final List<Movie> movies = [
  Movie('Mission: Impossible – Dead Reckoning Part One', 'Christopher McQuarrie', 2023),
  Movie('John Wick: Chapter 4', 'Chad Stahelski', 2023),
  Movie('Hit Man', 'Richard Linklater', 2023),
  Movie('The Hunger Games', 'Gary Ross', 2012),
  Movie('The Lord of the Rings: The Fellowship of the Ring', 'Peter Jackson', 2001),
  Movie('Rise of the Planet of the Apes', 'Rupert Wyatt', 2011),
  Movie('Pirates of the Caribbean: The Curse of the Black Pearl ', 'Gore Verbinski', 2003),
  Movie('Oldboy', 'Park Chan-wook', 2003),
  Movie('Kingsman: The Secret Service', 'Matthew Vaughn', 2014),
  Movie('Drive', 'Nicolas Winding Refn', 2011),
  Movie('Upgrade', 'Leigh Whannell', 2018),
  Movie('Mission: Impossible – Ghost Protocol', 'Brad Bird', 2011),
];

// MovieListItem Widget
class MovieListItem extends StatelessWidget {
  final Movie movie;
  final VoidCallback onPressed;

  MovieListItem({required this.movie, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: ListTile(
          title: Text(movie.title),
          subtitle: Text('${movie.director} - ${movie.year}'),
          leading: Icon(Icons.movie),
        ),
      ),
    );
  }
}

class ActionC extends StatefulWidget {
  @override
  _ActionCState createState() => _ActionCState();
}

class _ActionCState extends State<ActionC> {
  final MovieData movieData = MovieData();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Action',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Switch(
            value: themeManager.thememode == ThemeMode.dark,
            onChanged: (value) {
              themeManager.toggleTheme(value);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return MovieListItem(
                  movie: movies[index],
                  onPressed: () {
                    _fetchMovieData(context, movies[index].title);
                  },
                );
              },
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: SpinKitSpinningLines(
                    color: themeManager.thememode == ThemeMode.dark ? Colors.white : Colors.black,
                    size: 50.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _fetchMovieData(BuildContext context, String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      await movieData.fetchMovies(query);
      if (movieData.map1.isNotEmpty && movieData.map1['d'] != null && movieData.map1['d'].isNotEmpty) {
        await movieData.fetchAdditionalData(movieData.map1['d'][0]['id']);
      }

      // Navigate only if the context is still valid
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        Navigator.pushNamed(
          context,
          '/content',
          arguments: movieData,
        );
      }
    } catch (error) {
      print('Error fetching movie data: $error');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
