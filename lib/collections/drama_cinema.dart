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

  Movie('Whiplash', 'Damien Chazelle', 2014),
  Movie('12 Years a Slave', 'Steve McQueen', 2014),
  Movie('City of God', 'Fernando Meirelles, Kátia Lund', 2002),
  Movie('Drive My Car', 'Ryusuke Hamaguchi', 2021),
  Movie('Happening', 'Audrey Diwan', 2021),
  Movie('Little Women', 'Greta Gerwig', 2019),
  Movie('Short Term 12', 'Destin Daniel Cretton', 2013),
  Movie('Beautiful Boy', 'Felix Van Groeningen', 2018),
  Movie('Fences', 'Denzel Washington', 2016),
  Movie('Gone Girl', 'David Fincher', 2014),
  Movie('Hidden Figures', 'Theodore Melfi', 2017),
  Movie('Judas and the Black Messiah ', 'Shaka King', 2021),

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


class Drama extends StatefulWidget {
  @override
  State<Drama> createState() => _DramaState();
}

class _DramaState extends State<Drama> {
  final MovieData movieData = MovieData();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Horror',
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

