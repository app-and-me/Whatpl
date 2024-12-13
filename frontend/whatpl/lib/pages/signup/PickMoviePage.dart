import 'package:flutter/material.dart';

class PickMoviePage extends StatefulWidget {
  const PickMoviePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  PickMoviePageState createState() => PickMoviePageState();
}

class PickMoviePageState extends State<PickMoviePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("PickMovie Page"),
      )
    );
  }
}