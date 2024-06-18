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

  Movie('Hit Man', 'Richard Linkla', 2024),
  Movie('Inside Out 2', 'Kelsey Mann', 2024),
  Movie('Furiosa: A Mad Max Saga', 'George Miller', 2024),
  Movie('Under Paris', 'Xavier Gens', 2024),
  Movie('The Watched', 'Ishana Shyamalan', 2024),
  Movie('The Fall Guy', 'David Leitch', 2024),
  Movie('Godzilla Minus One', 'Takashi Yamazaki', 2023),
  Movie('Free Guy', 'Shawn Levy', 2024),
  Movie('Civil War', 'Alex Garland', 2024),
  Movie('Dune: Part Two', 'Denis Villeneuve', 2024),
  Movie('Challengers', 'Luca Guadagnino', 2024),

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


class Grossing extends StatefulWidget {
  @override
  State<Grossing> createState() => _GrossingState();
}

class _GrossingState extends State<Grossing> {
  final MovieData movieData = MovieData();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top-grossing',
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
