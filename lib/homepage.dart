import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'storage.dart';
import 'detailNote.dart';
import 'pinPage.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  // notesbox sbg wadah hive menyimpan notes
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
        // return nya dibuat alert
        return AlertDialog(
          title: Text('Change PIN'),
          content: Text('Do you want to change your PIN?'),
          actions: [
            // kl ga brarti kembali ke page homepage.dart
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // kl iya brarti manggil function changepin yang direct ke pinpage 
            TextButton(
              child: Text('Yes'),
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => PinPage(isChangingPin: true)),
    );
  }

  // mengarahkan ke halaman pinpage krn kalau logout berarti hrs isi pin lagi
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
        title: Text('Notes'),
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
                  // value ini hrs sama kayak yg ada di loop
                  value: 'logout',
                  child: Text('Logout'),
                ),
                PopupMenuItem<String>(
                  // ini juga
                  value: 'change_pin',
                  child: Text('Change PIN'),
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
            return Center(child: Text('No note.'));
          }

          // Mengurutkan catatan berdasarkan waktu terakhir diedit
          final notes = box.keys.cast<int>().map((key) => MapEntry(key, box.get(key)!)).toList()
            ..sort((a, b) => b.value.lastEditedDate.compareTo(a.value.lastEditedDate));

          // kl trnyt didalam hive ada catetan :
          return ListView.builder(
            // var notes yang isinya catatan yg sdh di sort dimasukkan ke itemCount untuk length nya
            itemCount: notes.length,
            // manggil konteks dan index item yang ada
            itemBuilder: (context, index) {
              // var note untuk menyimpan list notes pada index
              final note = notes[index].value;
              // var key untuk mengidentifikasi ini note yang mana
              final key = notes[index].key;
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  // menampilkan judul dari catatan
                  title: Text(note.title),
                  // menampilkan format waktu yang udah di set berdasarkan datetime saat ini
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Created: ${_formatDateTime(note.createdDate)}'),
                      Text('Last Edited: ${_formatDateTime(note.lastEditedDate)}'),
                    ],
                  ),
                  onTap: () {
                    // ketika card di klik, akan direct ke detailNote sesuai dengan index yang ada
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => NoteDetailPage(note: note, noteKey: key),
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
      // button untuk tmbh note
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        // pnggil addnote
        onPressed: () => _addNote(context),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

