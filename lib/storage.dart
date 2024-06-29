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

  // mengambil pin yang tersimpan di key
  static Future<String?> getPin() async {
    var box = await Hive.openBox('pinBox');
    return box.get('pin');
  }

  // menyimpan pin ke pinkey
  static Future<void> setPin(String pin) async {
    var box = await Hive.openBox('pinBox');
    await box.put('pin', pin);
  }

  // mendelete pin yang tersimpan
  static Future<void> deletePin() async {
    var box = await Hive.openBox('pinBox');
    await box.delete('pin');
  }
}
