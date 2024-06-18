import 'package:flutter/material.dart';
import 'package:mratings/services/API.dart';
import 'package:mratings/theme/thememanager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final TextEditingController _controller = TextEditingController();
  MovieData movieData = MovieData();
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final MovieData initialMovieData = ModalRoute.of(context)!.settings.arguments as MovieData;
    setState(() {
      movieData = initialMovieData;
    });
  }

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
            onSubmitted: (String query1) {
              setState(() {
                isLoading = true;
              });
              _fetchMovieData(query1);
            },
          ),
        ),
      ),
      body: isLoading
          ? Center(
        child: Column(
          children: [
            SizedBox(height: 300),
            SpinKitSpinningLines(
              color: themeManager.thememode == ThemeMode.dark ? Colors.white : Colors.black,
              size: 50.0,
            ),
          ],
        ),
      )
          : movieData.map1['d'] != null && movieData.map1['d'].isNotEmpty
          ? SingleChildScrollView(
        child: Card(
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
              SizedBox(height: 20),
              Text(
                movieData.moviename ?? 'N/A',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Text(
                  '${movieData.map2['genres']?[0] ?? ''}/${movieData.map2['genres']?[1] ?? ''}',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 9),
              SizedBox(height: 14),
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
                            '${double.parse(double.parse(movieData.map2['imdb_rating'] ?? '0.0').toStringAsFixed(1))}',
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
                      SizedBox(height: 20),
                      Text(
                        'Directors: ${movieData.map2['directors']?[0] ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
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
      )
          : Center(child: Text('No movie data available')),
    );
  }

  void _fetchMovieData(String query1) async {
    try {
      MovieData newMovieData = MovieData();
      await newMovieData.fetchMovies(query1);
      if (newMovieData.map1.isNotEmpty && newMovieData.map1['d'] != null && newMovieData.map1['d'].isNotEmpty) {
        await newMovieData.fetchAdditionalData(newMovieData.map1['d'][0]['id']);

      }
      setState(() {
        movieData = newMovieData;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching movie data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }
}
