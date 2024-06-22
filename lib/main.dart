import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';
import 'models/room.dart';
import 'room_page.dart';

void main() {
  _configureAmplify();
  runApp(const MyApp());
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugins(
      [
        AmplifyAuthCognito(),
        AmplifyAPI(
          options: APIPluginOptions(
            //modelProvider: ModelProvider.instance,
          ),
        ),
      ],
    );
    await Amplify.configure(amplifyConfig);
    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kraftwerk App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Kraftwerk Räume'),
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
  List<Room> rooms = [Room(name: 'Wendelstein', description: 'Ist es ein Raum? Ist es ein Berg?', numberOfSeats: 6),
  Room(name: 'Hallo', description: 'Ist es ein Raum? Ist es ein Berg?', numberOfSeats: 6) ];

  void _incrementCounter() {
   setState(() {
      rooms.add(Room(
        name: 'Neuer Raum',
        description: 'Beschreibung des neuen Raums',
        numberOfSeats: 10,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: rooms.map((room) {
            return ListTile(
              title: Text(room.name),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RoomPage(key: ValueKey(room.hashCode), room: room)),
              ),
            );
          }).toList(),	
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Add room',
        child: const Icon(Icons.add),
      ),
    );
  }
}
