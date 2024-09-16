import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classwork 1 V2',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 150, 127, 189)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Classwork 1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _FirstImage = true; //boolean for the image toggles

    void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _toggleImage(){
    setState(() { //to toggle the image
      _FirstImage = !_FirstImage;
    });
  }
  //img src
  String firstImage = "https://plus.unsplash.com/premium_photo-1694198817869-196127afd4ef?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
  String secondImage = "https://images.unsplash.com/photo-1526674183561-4bfb419ab4e5?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have clicked the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),

            Image.network( //for the images
              _FirstImage ? firstImage : secondImage,
              width: 200,
              height: 200,
            ),

            const SizedBox(height: 10),
            //button for the toggle
            ElevatedButton(onPressed: _toggleImage, child: const Text('Press for other image')
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }   
}
