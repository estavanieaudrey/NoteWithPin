import 'package:flutter/material.dart';
import 'storage.dart';
import 'homepage.dart';

class PinPage extends StatefulWidget {
  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  // controller untuk textfield input pin
  final TextEditingController _pinController = TextEditingController();
  // untuk cek apakah bikin baru? kl ngga brarti
  bool _isCreatingPin = false;

  // ini, storedpin : masukin pin yang sudah ada
  String? _storedPin;

  @override
  void initState() {
    super.initState();
    _checkStoredPin();
  }

  // pengecekan apakah pin nya null?
  Future<void> _checkStoredPin() async {
    _storedPin = await PinStorage.getPin();
    setState(() {
      _isCreatingPin = _storedPin == null;
    });
  }

  // cek apakah pin bener?
  void _verifyPin() {
    // kalo bener, akan direct ke homepage
    if (_pinController.text == _storedPin) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      // kalo salah, akan muncul text pin salah
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PIN salah!')));
    }
  }

  // menyimpan pin baru lalu direct ke homepage
  void _createPin() async {
    await PinStorage.setPin(_pinController.text);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // tampilan nya
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // kl creating maka muncul buat pin, kl ga create maka masukkan pin
              Text(
                _isCreatingPin ? 'Buat PIN' : 'Masukkan PIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _pinController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'PIN',
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isCreatingPin ? _createPin : _verifyPin,
                child: Text(_isCreatingPin ? 'Buat PIN' : 'Masuk'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

