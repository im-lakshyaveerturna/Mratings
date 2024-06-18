import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mratings/theme/thememanager.dart';

import 'package:mratings/services/API.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Movie{
  final String title;
  final String director;
  final int year;

  Movie(this.title, this.director, this.year);

}
final List<Movie> Movies = [

  Movie('The Notebook', 'Nick Cassavetes', 2004),
  Movie('The Fault in Our Stars', 'Josh Boone', 2014),
  Movie('The Age of Adaline', 'Lee Toland Krieger', 2015),
  Movie('About Time', 'Richard Curtis', 2013),
  Movie('Pride & Prejudice', 'Joe Wright', 2005),
  Movie('Crazy, Stupid, Love', ' Glenn Ficarra, John Requa', 2011),
  Movie('Titanic', 'James Cameron', 1997),
  Movie('When Harry Met Sally...', 'Rob Reiner', 1989),
  Movie('Fifty shades of grey', 'Sam Taylor-Johnson', 2015),
  Movie('Anyone but You', 'Will Gluck', 2023),
  Movie('(500) Days of Summer', 'Marc Webb', 2009),
  Movie('Romeo + Juliet', 'Baz Luhrmann', 1996),

];

class MovieListItem extends StatelessWidget {
  final Movie movie;
  final VoidCallback onPressed;

  MovieListItem({required this.movie, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return  Card(
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


class Romance extends StatefulWidget {
  @override
  State<Romance> createState() => _RomanceState();
}

class _RomanceState extends State<Romance> {
  final MovieData movieData = MovieData();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Romance',
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
              itemCount: Movies.length,
              itemBuilder: (context, index) {
                return MovieListItem(
                  movie: Movies[index],
                  onPressed: () {
                    _fetchMovieData(context, Movies[index].title);
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
