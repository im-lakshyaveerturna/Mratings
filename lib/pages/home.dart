import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          if (!isLoading)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text('Top Picks', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/action_cinema');
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          child: Stack(children: [
                            Container(
                                width: 365,
                                height: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('images/action.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(18)
                                )
                            ),
                            Text(
                                """ 
                                                                   
   ACTION""", style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1)),
                          ],)
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/sci-fi_cinema');
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          child: Stack(children: [
                            Container(
                                width: 365,
                                height: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('images/sci-fi.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(18)
                                )
                            ),
                            Text(
                                """ 
                                                                   
   Sci-Fi""", style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1)),
                          ],)
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/superhero_cinema');
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          child: Stack(children: [
                            Container(
                                width: 365,
                                height: 300,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'images/superherp.jpeg'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(18)
                                )
                            ),
                            Text(
                                """ 
                                                                   
   Heroes""", style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1)),
                          ],)
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/drama_cinema');
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          child: Stack(children: [
                            Container(
                                width: 365,
                                height: 300,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('images/drama.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(18)
                                )
                            ),
                            Text(
                                """ 
                                                                   
   Drama""", style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1)),
                          ],)
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/romance_cinema');
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          child: Stack(children: [
                            Container(
                                width: 365,
                                height: 300,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('images/romance.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(18)
                                )
                            ),
                            Text(
                                """ 
                                                                   
   Romance""", style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1)),
                          ],)
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/comedy_cinema');
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          child: Stack(children: [
                            Container(
                                width: 365,
                                height: 300,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('images/comedy.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(18)
                                )
                            ),
                            Text(
                                """ 
                                                                   
   Comedy""", style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1)),
                          ],)
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/horror_cinema');
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          child: Stack(children: [
                            Container(
                                width: 365,
                                height: 300,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('images/horror.jpeg'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(18)
                                )
                            ),
                            Text(
                                """ 
                                                                   
   Horror""", style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1)),
                          ],)
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/top_grossing_cinema');
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          child: Stack(children: [
                            Container(
                                width: 365,
                                height: 350,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('images/grossing.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(18)
                                )
                            ),
                            Text(
                                """ 
                                                                   
   Top-Grossing""", style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1)),
                          ],)
                      ),
                    ],
                  ),

                ],
              ),
            ),

          Text(' '),
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
                            color: themeManager.thememode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            size: 50.0,
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
