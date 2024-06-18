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

  Movie('Polite Society', 'Nida Manzoor', 2023),
  Movie('The 40 year-old virgin', 'Tim Story', 2002),
  Movie('Barbershop', 'Shawn Levy', 2021),
  Movie('Sick of Myself', ' Kristoffer Borgli', 2023),
  Movie('Dungeons & Dragons: Honor Among Thieves', 'John Francis Daley, Jonathan Goldstein', 2023),
  Movie('Good Luck to You, Leo Grande', 'Sophie Hyde', 2022),
  Movie('21 Jump Street', 'Phil Lord, Chris Miller', 2012),
  Movie('Hot Fuzz', 'Edgar Wright', 2007),
  Movie('Jump Street', 'Phil Lord, Chris Miller', 2012),
  Movie('Ted', 'Seth MacFarlane', 2012),
  Movie('Hangover', 'Todd Phillips', 2010),
  Movie('Good Boys', 'Gene Stupnitsky', 2019),

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

class Comedy extends StatefulWidget {
  @override
  State<Comedy> createState() => _ComedyState();
}

class _ComedyState extends State<Comedy> {
  final MovieData movieData = MovieData();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comedy',
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
