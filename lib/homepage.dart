// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'storage.dart';
// import 'detailNote.dart';
// import 'pinPage.dart';
// import 'package:intl/intl.dart';

// class HomePage extends StatelessWidget {
//   final Box<Note> notesBox = Hive.box<Note>('notes');

//   //navigasi untuk menuju ke tambah catatan baru
//   void _addNote(BuildContext context) {
//     Navigator.push(context, MaterialPageRoute(builder: (_) => NoteDetailPage()));
//   }

//   // ada card yang berguna untuk menanyakan apakah mau ganti pin / tidak
//   void _showChangePinDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // return nya dibuat alert
//         return AlertDialog(
//           title: Text('Ubah PIN'),
//           content: Text('Apakah Anda ingin mengubah PIN?'),
//           actions: [
//             // kl ga brarti kembali ke page homepage.dart
//             TextButton(
//               child: Text('Tidak'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             // kl iya brarti manggil function changepin yang direct ke pinpage 
//             TextButton(
//               child: Text('Ya'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _changePin(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // mengarahkan ke halaman pin page untuk ubah pin
//   void _changePin(BuildContext context) {
//     PinStorage.deletePin().then((_) {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PinPage()));
//     });
//   }

// //   void _changePin(BuildContext context) {
// //   Navigator.pushReplacement(
// //     context,
// //     MaterialPageRoute(builder: (_) => PinPage(isChangingPin: true)),
// //   );
// // }


//   // mengarahkan ke halaman pinpage krn kalau logout berarti hrs isi pin lagi
//   void _logout(BuildContext context) {
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PinPage()));
//   }

//   // set format waktu hingga detik
//   String _formatDateTime(DateTime dateTime) {
//     return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // menu utama
//       appBar: AppBar(
//         title: Text('Catatan'),
//         actions: [

//           // ada menu pilihan mau logout atau ganti pin
//           PopupMenuButton<String>(
//             onSelected: (String value) {
//               // kl semisal pilih logout,
//               if (value == 'logout') {
//                 // akan memanggil function _logout
//                 _logout(context);
//               // kl semisal pilih change pin
//               } else if (value == 'change_pin') {
//                 // akan memanggil function yang dapat mengubah pin
//                 _showChangePinDialog(context);
//               }
//             },
//             itemBuilder: (BuildContext context) {
//               return [
//                 PopupMenuItem<String>(
//                   // value ini hrs sama kayak yg ada di loop
//                   value: 'logout',
//                   child: Text('Logout'),
//                 ),
//                 PopupMenuItem<String>(
//                   // ini juga
//                   value: 'change_pin',
//                   child: Text('Ganti PIN'),
//                 ),
//               ];
//             },
//           ),
//         ],
//       ),
//       body: ValueListenableBuilder(
//         valueListenable: notesBox.listenable(),
//         builder: (context, Box<Note> box, _) {
//           // cek dari notesBox hive, klo kosong berarti ada tulisan tidak ada catatan
//           if (box.values.isEmpty) {
//             return Center(child: Text('Tidak ada catatan.'));
//           }

//           // Mengurutkan catatan berdasarkan waktu terakhir diedit
//           final notes = box.keys.cast<int>().map((key) => MapEntry(key, box.get(key)!)).toList()
//             ..sort((a, b) => b.value.lastEditedDate.compareTo(a.value.lastEditedDate));

//           // kl trnyt didalam hive ada catetan :
//           return ListView.builder( 
//             // var notes yang isinya catatan yg sdh di sort dimasukkan ke itemCount untuk length nya
//             itemCount: notes.length,
//             // manggil konteks dan index item yang ada
//             itemBuilder: (context, index) {
//               // var note untuk menyimpan list notes pada index
//               final note = notes[index].value;
//               // var key untuk mengidentifikasi ini note yang mana
//               final key = notes[index].key;
//               return Card(
//                 elevation: 4,
//                 margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: ListTile(
//                   // menampilkan judul dari catatan 
//                   title: Text(note.title),
//                   // menampilkan format waktu yang udah di set berdasarkan datetime saat ini
//                   subtitle: Text('Terakhir diedit: ${_formatDateTime(note.lastEditedDate)}'),
//                   onTap: () {
//                     // ketika card di klik, akan direct ke detailNote sesuai dengan index yang ada
//                     Navigator.push(context, MaterialPageRoute(
//                       builder: (_) => NoteDetailPage(note: note, noteKey: key),
//                     ));
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () => _addNote(context),
//         backgroundColor: Colors.blueAccent,
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'storage.dart';
import 'detailNote.dart';
import 'pinPage.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  final Box<Note> notesBox = Hive.box<Note>('notes');

  void _addNote(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => NoteDetailPage()));
  }

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

  void _changePin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => PinPage(isChangingPin: true)),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PinPage()));
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catatan'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'logout') {
                _logout(context);
              } else if (value == 'change_pin') {
                _showChangePinDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
                PopupMenuItem<String>(
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
          if (box.values.isEmpty) {
            return Center(child: Text('Tidak ada catatan.'));
          }

          final notes = box.keys.cast<int>().map((key) => MapEntry(key, box.get(key)!)).toList()
            ..sort((a, b) => b.value.lastEditedDate.compareTo(a.value.lastEditedDate));

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index].value;
              final key = notes[index].key;
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(note.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dibuat: ${_formatDateTime(note.createdDate)}'),
                      Text('Terakhir diedit: ${_formatDateTime(note.lastEditedDate)}'),
                    ],
                  ),
                  onTap: () {
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addNote(context),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

