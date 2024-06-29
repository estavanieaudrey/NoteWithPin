import 'package:flutter/material.dart';
import 'storage.dart';
import 'homepage.dart';

class PinPage extends StatefulWidget {
  //var 
  final bool isChangingPin;

  // parameter set false, ga require krn tdk diharuskan ngecall class dgn parameter
  PinPage({this.isChangingPin = false});

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  //inisialisasi controller 
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  // ini, storedpin : masukin pin yang sudah ada
  String? _storedPin;
  // inisialisasi biasa 
  bool _isCreatingPin = false;
  bool _isVerifyingOldPin = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // setiap page dipanggil memeriksa apakah ada pin yg disimpan 
    _checkStoredPin();
  }

  // pengecekan apakah pin nya null?
  // ini dijalankan per line 
  Future<void> _checkStoredPin() async {
    _storedPin = await PinStorage.getPin();
    setState(() {
      // ini kl gada pin yg disimpan brarti buat baru
      if (_storedPin == null) {
        _isCreatingPin = true; 
        // apabila sdh ada pin 
      } else if (widget.isChangingPin) {
        _isVerifyingOldPin = true; 
      }
    });
  }

  // apakah pin sdh bener?
  void _verifyPin() {
    setState(() {
      _errorMessage = '';
    });

    // kalo pin kurang dari 4 digit
    if (_pinController.text.length < 4) {
      setState(() {
        // panggil error ini
        _errorMessage = 'PIN must be at least 4 digits!';
      });
      return;
    }
    // kl pin yg diinput bener
    if (_pinController.text == _storedPin) {
      // kl ubah pin maka akan manggil 
      if (widget.isChangingPin) { 
        setState(() {
          _isVerifyingOldPin = false; 
          // buat pin baru
          _isCreatingPin = true;
        });
        // kl ga ubah pin maka masuk ke homepage
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
      }
      // apabila pin yg dimasukkan salah 
    } else {
      setState(() {
        _errorMessage = 'Wrong PIN!';
      });
    }
  }

  // ini untuk buat pin
  void _createPin() async {
    setState(() {
      _errorMessage = '';
    });

    // new pin hrs minimal 4 digit
    if (_newPinController.text.length < 4) {
      setState(() {
        _errorMessage = 'New PIN must be at least 4 digits!';
      });
      return;
    }

    // set pin 
    await PinStorage.setPin(_newPinController.text);
    // masuk ke homepage
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ini texfield
              Text(
                // kl creating pin brarti..
                _isCreatingPin
                    ? 'Create New PIN'
                    // kl input pin lama
                    : _isVerifyingOldPin
                        ? 'Enter Old PIN'
                        : 'Input PIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    // klo creating pin makan new pin controller
                    // klo gak maka panggil pin controller 
                    controller: _isCreatingPin ? _newPinController : _pinController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // kl creat pin maka pin baru kl gak brarti cuma pin
                      labelText: _isCreatingPin ? 'New PIN' : 'PIN',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  // kl ada error akan ada alert card
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Color.fromARGB(255, 255, 7, 7)),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                // kl creat pin panggil  _createpin 
                // kl gak berarti _verifypin
                onPressed: _isCreatingPin ? _createPin : _verifyPin,
                child: Text(_isCreatingPin ? 'Create PIN' : 'Enter'),
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