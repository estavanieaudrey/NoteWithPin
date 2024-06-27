import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
part 'note.g.dart';

//hive type dan field ini untuk menyimpan objek note dalam database hive
@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String title; //judul

  @HiveField(1)
  String content; //isi

  @HiveField(2)
  DateTime createdDate; //waktu cttn terbuat

  @HiveField(3)
  DateTime lastEditedDate; //waktu cttn diedit

  Note({
    required this.title,
    required this.content,
    required this.createdDate,
    required this.lastEditedDate,
  });
}


//untuk menyimpan dan mengambil pin
class PinStorage {
  static const _storage = FlutterSecureStorage();
  static const _pinKey = 'user_pin'; //kunci yang digunakan untuk menyimpan key

  // menyimpan pin ke pinkey
  static Future<void> setPin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  // mengambil pin yang tersimpan di key
  static Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  // mendelete pin yang tersimpan
  static Future<void> deletePin() async {
    await _storage.delete(key: _pinKey);
  }
}
