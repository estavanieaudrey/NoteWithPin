import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'storage.dart';
import 'detailNote.dart';
import 'pinPage.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  final Box<Note> notesBox = Hive.box<Note>('notes');

  //navigasi untuk menuju ke tambah catatan baru
  void _addNote(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => NoteDetailPage()));
  }

  // ada card yang berguna untuk menanyakan apakah mau ganti pin / tidak
  void _showChangePinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubah PIN'),
          content: Text('Apakah Anda ingin mengubah PIN?'),
          actions: [
            TextButton(
              child: Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // kalo iya, pake navigator ke class changepin
            TextButton(
              child: Text('Ya'),
              onPressed: () {
                Navigator.of(context).pop();
                _changePin(context);
              },
            ),
          ],
        );
      },
    );
  }

  // mengarahkan ke halaman pin page untuk ubah pin
  void _changePin(BuildContext context) {
    // didelete dulu dari storage
    PinStorage.deletePin().then((_) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PinPage()));
    });
  }

  // mengarahkan ke halaman pinpage
  void _logout(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PinPage()));
  }

  // set format waktu hingga detik
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // menu utama
      appBar: AppBar(
        title: Text('Catatan'),
        actions: [

          // ada menu pilihan mau logout atau ganti pin
          PopupMenuButton<String>(
            onSelected: (String value) {
              // kl semisal pilih logout,
              if (value == 'logout') {
                // akan memanggil function _logout
                _logout(context);
              // kl semisal pilih change pin
              } else if (value == 'change_pin') {
                // akan memanggil function yang dapat mengubah pin
                _showChangePinDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  // value ini ngikuti atas
                  value: 'logout',
                  child: Text('Logout'),
                ),
                PopupMenuItem<String>(
                  // ini ngikut atas jg
                  value: 'change_pin',
                  child: Text('Ganti PIN'),
                ),
              ];
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: notesBox.listenable(),
        builder: (context, Box<Note> box, _) {
          // cek dari notesBox hive, klo kosong berarti ada tulisan tidak ada catatan
          if (box.values.isEmpty) {
            return Center(child: Text('Tidak ada catatan.'));
          }
          // kl trnyt didalam hive ada catetan :
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              // di print berdasarkan index
              final note = box.getAt(index);
              // return berupa card
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  // card menampilkan title dan waktu edit berdasarkan data sesuai index
                  title: Text(note!.title),
                  //format waktu e dipanggil
                  subtitle: Text('Terakhir diedit: ${_formatDateTime(note.lastEditedDate)}'), 
                  // apabila di klik, akan direct ke page noteDetailPage
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => NoteDetailPage(note: note, noteIndex: index),
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
      // button ini untuk menambah note baru 
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        // apabila di klik akan direct ke add note
        onPressed: () => _addNote(context),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
