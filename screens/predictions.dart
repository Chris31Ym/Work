import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../alertas/alert_reprobado.dart';
import '../alertas/alert_aprobado.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final url = Uri.parse("http://192.168.0.105:5003/get_predictions");
  final _formkey = GlobalKey<FormState>();
  // late Future<List<Notas>> estudiantes;
  final TextEditingController _nota1 = TextEditingController();
  final TextEditingController _nota2 = TextEditingController();
  final TextEditingController _nota3 = TextEditingController();
  String _prediction = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 100.0,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage('assets/student.png'),
              ),
              const Text(
                'Calificaciones',
                style: TextStyle(fontFamily: 'Lumanosimo', fontSize: 50.0),
              ),
              const Text(
                'Alumnos: ',
                style: TextStyle(fontFamily: 'Lumanosimo', fontSize: 20.0),
              ),
              const SizedBox(height: 20),
              TextFormField(
                  controller: _nota1,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por Favor Ingresa Una Nota';
                    }
                    if (value.length > 2) {
                      return 'No Se Pueden poner mas de dos digitos';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Nota1',
                    labelText: 'Ingresa la primer nota',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.note_alt),
                  )),
              const SizedBox(height: 20),
              TextFormField(
                  controller: _nota2,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'No Puede Estar Vacio Sin Una Nota';
                    }
                    if (value.length > 2) {
                      return 'No Se Pueden poner mas de dos digitos';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Nota2',
                    labelText: 'Ingresa la segunda nota',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.note_alt_outlined),
                  )),
              const SizedBox(height: 20),
              TextFormField(
                  controller: _nota3,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por Favor Ingresa Una Nota';
                    }
                    if (value.length > 2) {
                      return 'No Se Pueden poner mas de dos digitos';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Nota3',
                    labelText: 'Ingresa la tercera nota',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.note_alt_outlined),
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _enviarPrediccion,
                child: const Text('Obtener prediccion'),
              ),
              const SizedBox(height: 20),
              Text('Prediccion: $_prediction'),
            ],
          ),
        ),
      ),
    );
  }

  Future<StatelessWidget> _enviarPrediccion() async {
    final form = _formkey.currentState;
    final headers = {'Content-Type': 'application/json'};
    final student = {
      "nota1": _nota1.text,
      "nota2": _nota2.text,
      "nota3": _nota3.text
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode({student}));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        _prediction = responseData['prediction'].toString();
      });
    } else {
      setState(() {
        _prediction = 'Error en la predicción';
      });
    }
    if (form!.validate()) {}

    if (_prediction == 1 as String) {
      return const AlertReprobado();
    } else {
      return const AlertAprobado();
    }
  }
}
