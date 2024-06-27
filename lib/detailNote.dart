import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'storage.dart';

class NoteDetailPage extends StatefulWidget {
  // inisialisasi var untuk menampilan dan edit catatan
  final Note? note;
  final int? noteIndex;

  NoteDetailPage({this.note, this.noteIndex});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  // untuk kontrol textField
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  // menyimpan catatan di box hive
  final Box<Note> _notesBox = Hive.box<Note>('notes');

  @override
  // inisialisasi catatan
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  // menyimpan catatan
  void _saveNote() {
    final newNote = Note(
      title: _titleController.text,
      content: _contentController.text,
      // berdasarkan waktu saat ini
      createdDate: widget.note?.createdDate ?? DateTime.now(),
      lastEditedDate: DateTime.now(),
    );

    if (widget.noteIndex == null) {
      _notesBox.add(newNote);
    } else {
      _notesBox.putAt(widget.noteIndex!, newNote);
    }

    Navigator.pop(context);
  }

  // menghapus catatan sesuai index
  void _deleteNote() {
    if (widget.noteIndex != null) {
      _notesBox.deleteAt(widget.noteIndex!);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // apabila note nya kosong, maka tambah catatan, kl ada isi maka edit catatan
        title: Text(widget.note == null ? 'Tambah Catatan' : 'Edit Catatan'),
        actions: [
          // jika tidak null, maka akan ada button delete
          if (widget.note != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteNote,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // textfield untuk judul 
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // textfield untuk isi 
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Isi',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            SizedBox(height: 20),
            // button untuk save note
            ElevatedButton(
              // jika di klik akan memanggil function save note
              onPressed: _saveNote,
              child: Text('Simpan'),
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
