import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:minecraft_realms/models/Slot.dart';
import 'package:minecraft_realms/models/device_code.dart';
import 'package:minecraft_realms/models/server.dart';
import 'package:minecraft_realms/services/ms_login_services.dart';
import 'package:minecraft_realms/services/realm_services.dart';

import 'models/options.dart';
import 'models/world.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  msAuth();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minecraft Realms',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Minecraft Realms '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Server> server;

  Map<String, String> getCookies() {
    final cookie = document.cookie!;
    final entity = cookie.split("; ").map((item) {
      final split = item.split("=");
      return MapEntry(split[0], split[1]);
    });
    final cookieMap = Map.fromEntries(entity);
    return cookieMap;
  }

  @override
  void initState() {
    super.initState();
    Map<String, String> cookies = getCookies();
    if (cookies['Token'] != null) {
      server = getWorlds(cookies['Token']!, cookies['UHS']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 3,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(3, (index) {
          return FutureBuilder<Server>(
            future: server,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _buildCard(snapshot.data!.id, snapshot.data!.slots[index], snapshot.data!.activeSlot==snapshot.data!.slots[index].slotId);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          );
        }),
      ),
    );
  }

  Widget _buildCard(int serverId, Slot slot, bool activeSlot) {
    Options options = Options.fromJson(jsonDecode(slot.options));
    return SizedBox(
      height: 210,
      child: Card(
        color: activeSlot?Colors.green[100]:null,
        child: Column(
          children: [
            ListTile(
              title: Text(
                options.slotName,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(options.gameModeDescription),
              leading: Icon(
                Icons.restaurant_menu,
                color: Colors.brown[500],
              ),
            ),
            Container(child: Image.asset('${options.gameModeDescription}.jpg')),
            const Divider(),
            ListTile(
              title: Text(
                'Difficulty: ${options.difficulty.toString()}',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: Icon(
                Icons.warning_outlined,
                color: Colors.brown[500],
              ),
            ),
            ListTile(
              title: Text('Cheats enabled: ${options.cheatsAllowed.toString()}'),
              leading: Icon(
                Icons.all_inbox_outlined,
                color: Colors.brown[500],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
              onPressed: activeSlot?null:() {
                activateSlotCallback(serverId, slot.slotId);
              },
              child: const Text('Activar'),
            ),
          ],
        ),
      ),
    );
  }

  activateSlotCallback(int serverId, int slotId) async{
    Map<String, String> cookies = getCookies();
     late Future<String> serverActivated; 
     serverActivated = activateSlot(serverId, slotId, cookies['Token']!, cookies['UHS']!);
     await serverActivated.then((value){
        server = getWorld(serverId, cookies['Token']!, cookies['UHS']!);
     });
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }
}
