import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'storage.dart';
import 'pinPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // inisialisasi hive
  await Hive.initFlutter();
  // register note
  Hive.registerAdapter(NoteAdapter());
  // penyimpanan hive namanya notes, simpen Note ke box
  await Hive.openBox<Note>('notes');

  // await PinStorage.deletePin();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PinPage(), //njalanin pinpage
    );
  }
}
