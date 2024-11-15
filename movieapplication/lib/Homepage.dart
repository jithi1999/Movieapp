import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
   Future<void> loadingTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? movieList = prefs.getStringList('MovieList');
    List<String>? FavouriteList = prefs.getStringList('FavouriteList');
    print(movieList);

    
    if (movieList != null) {
      setState(() {
        task = movieList;
      });
    }
    if (FavouriteList != null) {
      setState(() {
        Favourite_List = FavouriteList;
      });
    }

    // print(MovieList);
  }


  @override
  void initState() {
    
    super.initState();
    loadingTodoList();
  }

  TextEditingController addnew = TextEditingController();
  List<String> task = [];
  List<String> Favourite_List = [];

  Future<void> UpdateList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('MovieList', task);
    prefs.setStringList('FavouriteList', Favourite_List);
    
    
  }
  Future<void> searchMovies(String query) async {
    final String apiKey = '_API_KEY'; 
    final response = await http.get(Uri.parse(
        'https://www.themoviedb.org/documentation/api'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 1,
              color: Color.fromARGB(255, 118, 181, 120),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "My Movies",
                        style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: addnew,
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 0, 0, 0)),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.add),
                                fillColor: Color.fromARGB(255, 248, 248, 248),
                                filled: true,
                                border: OutlineInputBorder(),
                                hintText: 'Search Movies',
                                hintStyle: TextStyle(fontSize: 15)),
                                
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (addnew.text.isNotEmpty) {
                                task.add(addnew.text);
                                addnew.clear();
                                UpdateList();
                              } else {
                                addnew.clear();
                              }
                            });
                          },
                          child: Icon(Icons.search, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(20),
                            backgroundColor: const Color.fromARGB(255, 18, 31, 42),
                            
                             
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Movie List",
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                          itemCount: task.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 20),
                              child: Container(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  Favourite_List.add(
                                                      task[index]);
                                                  task.removeAt(index);
                                                  
                                                });
                                              },
                                              icon: Icon(
                                                Icons.check_circle,
                                                color: Color.fromARGB(255, 134, 83, 26),
                                              )),
                                          Text(task[index]),
                                          Spacer(),
                                         
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  task.removeAt(index);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Color.fromARGB(255, 97, 42, 42),
                                              )),
                                        ],
                                      ),
                                    ],
                                  )),
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " Favorites",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                          itemCount: Favourite_List.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 20),
                              child: Container(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  task.add(
                                                      Favourite_List[index]);
                                                  Favourite_List.removeAt(
                                                      index);
                                                  UpdateList();
                                                });
                                              },
                                              icon: Icon(
                                                Icons.check_circle,
                                                color: Color.fromARGB(
                                                    255, 7, 255, 11),
                                              )),
                                          new RichText(
                                            text: new TextSpan(
                                              children: <TextSpan>[
                                                new TextSpan(
                                                  text: Favourite_List[index],
                                                  style: new TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 1, 1, 1),
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          
                                        ],
                                      ),
                                    ],
                                  )),
                            );
                         }),
                   ),
                 ),
                ],
              )),
        ],
      ),
    );
  }
}
  
    








  