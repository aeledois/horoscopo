import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // generated via `flutterfire` CLI

Random random = Random();
var signo = signos[0];
var dbRef;
final Image imageAsset = Image.asset('assets/images/signos.png', height: 100);
final List<String> signos = [ 'Áries', 'Touro', 'Gêmeos', 'Câncer',
  'Leão', 'Virgem', 'Libra', 'Escorpião', 'Sagitário', 'Capricórnio',
  'Aquário', 'Peixes',];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Previsão do Signo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Previsão para o Signo'),
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
  final db = FirebaseFirestore.instance;

  String cabecalho = "Selecione o Signo e Click para obter a previsão.";
  String resp = "";

  @override
  void initState() {
    super.initState();
    dbRef = db.collection("previsao");
  }

  Future<void> _pressed() async {
    var ind = random.nextInt(10);
    final query = dbRef.where("indice", isEqualTo: ind);

    QuerySnapshot result = await query.get();
    var aux = result.docs;
    var aux2 = "";

    for (int i = 0; i < aux.length; i++) {
      aux2 += (aux[i].data() as Map)['texto'] + ' ';
    }

    setState(() {
      cabecalho = signo;
      resp = aux2;
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
          padding: const EdgeInsets.all(8),
          children: [
            imageAsset,
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              color: Colors.cyan,
              child: DropdownButton<String>(
                onChanged: (String? selected) {
                  setState(() {
                    signo = selected!;
                  });
                },
                value: signo,
                items: signos.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
              ),
            ),
            Text(cabecalho,
              style: const TextStyle(color: Colors.blue, fontSize: 24),
            ),
            Text(resp,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            FloatingActionButton.extended(
              onPressed: _pressed,
              label: const Text('Previsão'),
              icon: const Icon(Icons.shield_moon),
              foregroundColor: Colors.blue,
              backgroundColor: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
