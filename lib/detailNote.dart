import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'storage.dart';

class NoteDetailPage extends StatefulWidget {
  // inisialisasi 2 parameter untuk menampilan dan edit catatan
  final Note? note; //note yang diedit
  final int? noteKey; // kunci

  NoteDetailPage({this.note, this.noteKey});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  // untuk kontrol inputan textField
  final _titleController = TextEditingController(); // ini judul
  final _contentController = TextEditingController(); // ini isi

  // menyimpan catatan di box hive
  final Box<Note> _notesBox = Hive.box<Note>('notes');

  @override
  void initState() {
    super.initState();
    // jika note tidak null, maka nampilin judul dan isinya
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _saveNote() {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    // Cek jika konten kosong, tampilkan dialog error dan kembali
    if (title.isEmpty && content.isEmpty) {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Text(
            'Maaf,',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Isi catatan tidak boleh kosong!',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
      return;
    }

    // Jika judul kosong, set judul ke "Tidak ada judul"
    if (title.isEmpty) {
      title = 'Tidak ada judul';
    }

    // newNote ini menyimpan judul, isi, kpn note dibuat, dan kpn trakhir diedit
    final newNote = Note(
      title: title,
      content: content,
      createdDate: widget.note?.createdDate ?? DateTime.now(),
      lastEditedDate: DateTime.now(),
    );

    // jika null berarti kan kosong, jd pake .add untuk masukin ke notebox hive
    if (widget.noteKey == null) {
      _notesBox.add(newNote);
    } else {
      // klo tdk null, pakai .put utk memperbarui catatan berdasarkan key kedalam notebox hive
      _notesBox.put(widget.noteKey, newNote);
    }
    Navigator.pop(context);
  }


  void _deleteNote() {
    // kl notekey tdk null berarti ada isinya kan, nah di .delete dari notesbox sesuai notekey itu
    if (widget.noteKey != null) {
      _notesBox.delete(widget.noteKey);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // apabila note nya kosong, maka tambah catatan, kl ada isi maka edit catatan
      appBar: AppBar(
        title: Text(widget.note == null ? 'Tambah Catatan' : 'Edit Catatan'),
        actions: [
          // kalo note nya tidak kosong berarti bisa dihapus, maka dikasi icon delete
          if (widget.note != null)
            IconButton(
              icon: Icon(Icons.delete),
              // ketika icon di klik akan manggil function deleteNote
              onPressed: _deleteNote,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ini textfield untuk judul
            TextField(
              controller: _titleController, //kontroler nya ya title
              decoration: InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // ini textfield untuk isi
            TextField(
              controller: _contentController, //ini konten krn isi
              decoration: InputDecoration(
                labelText: 'Isi',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            SizedBox(height: 20),
            // ini button
            ElevatedButton(
              // kl button di pencet akan panggil function savenote
              onPressed: _saveNote, 
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
