import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mratings/theme/theme.dart';

import 'package:mratings/theme/thememanager.dart';
import 'package:mratings/services/API.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  MovieData movieData = MovieData();
  bool isLoading = false;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
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
      body: Stack(
        children: [
          if (count == 0 && !isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/mratings2.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

          if (!isLoading && count == 1 && (
              movieData.map1['d'] == null || movieData.map1['d'].isEmpty ||
                  movieData.map2['description'] == null &&
                  movieData.map2['imdb_rating'] == null &&
                  movieData.map2['stars'] == null))
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/noresult.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Text('                                                                                                              '),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (isLoading) ...[
                          SizedBox(height: 300,),
                          SpinKitSpinningLines(
                            color: themeManager.thememode == ThemeMode.dark ? Colors.white : Colors.black,
                            size: 50.0,
                          ),
                        ] else if (!isLoading && movieData.map1.isNotEmpty && movieData.map1['d'] != null && count == 1 &&
                            movieData.map2['description'] != null && movieData.map2['imdb_rating'] != null && movieData.map2['stars'] != null) ...[
                          Column(
                            children: [
                              SizedBox(height: 20,),
                              if (movieData.map1['d'] != null && movieData.map1['d'].isNotEmpty)
                                Card(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                                        child: Image.network(
                                          movieData.map1['d'][0]['i']['imageUrl'] ?? '',
                                          height: 280,
                                          width: 210,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(Icons.error, color: Colors.red, size: 100);
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      Text(
                                        movieData.moviename ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans',
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                        child: Text(
                                          '${movieData.map2['genres']?[0] ?? ''}/${movieData.map2['genres']?[1] ?? ''}',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 9,),
                                      SizedBox(height: 14,),
                                      Card(
                                        color: Colors.deepPurpleAccent,
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Image(
                                                    image: AssetImage('images/imdblogo.png'),
                                                    height: 29,
                                                    width: 45,
                                                  ),
                                                  Text(
                                                    '${double.parse(movieData.map2['imdb_rating'])}',
                                                    style: TextStyle(
                                                      fontSize: 26,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                movieData.map2['description'] ?? 'Description not available.',
                                                style: TextStyle(
                                                  fontSize: 19,
                                                ),
                                              ),
                                              SizedBox(height: 20,),
                                              Text(
                                                'Directors: ${movieData.map2['directors']?[0] ?? 'N/A'}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Text(
                                                'Cast: ${movieData.map2['stars']?[0] ?? 'N/A'}, ${movieData.map2['stars']?[1] ?? 'N/A'}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    }

  void _fetchMovieData(String query) async {
    try {
      await movieData.fetchMovies(query);
      if (movieData.map1.isNotEmpty && movieData.map1['d'] != null && movieData.map1['d'].isNotEmpty) {
        await movieData.fetchAdditionalData(movieData.map1['d'][0]['id']);
      }
    } catch (error) {
      print('Error fetching movie data: $error');
    } finally {
      setState(() {
        isLoading = false;
        count = 1;
      });
    }
  }
}
