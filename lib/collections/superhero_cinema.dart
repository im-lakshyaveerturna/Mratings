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

  Movie('Dark knight', 'Christopher Nolan', 2008),
  Movie('Deadpool', 'Tim Miller', 2016),
  Movie('Avengers: Endgame', 'Anthony Russo, Joe Russo', 2019),
  Movie('Batman v Superman: Dawn of Justice', 'Zack Snyder', 2016),
  Movie('Spider-Man 2 ', 'Sam Raimi', 2004),
  Movie('Thor: Ragnarok', 'Taika Waititi', 2017),
  Movie('Logan', 'James Mangold', 2017),
  Movie('Iron Man', 'Jon Favreau', 2008),
  Movie('Transformers', 'Michael Bay', 2007),
  Movie('The Boys', 'Dan Trachtenberg', 2019),
  Movie('Justice League', 'Zack Snyder', 2017),
  Movie('The Dark Knight Rises', 'Christopher Nolan', 2012),

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

class SHero extends StatefulWidget {
  const SHero({super.key});

  @override
  State<SHero> createState() => _SHeroState();
}

class _SHeroState extends State<SHero> {
  final MovieData movieData = MovieData();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SuperHero',
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