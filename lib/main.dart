import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() => runApp(MyPetForm());


class MyPetForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Pets',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: CadastroScreen(),
    );
  }
}

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _observationController = TextEditingController();

  String city =  "";
  String street = "";
  
  void getCEPInfo(String cep) async {
    if(cep.length != 8) {
      AlertDialog(
        content: Text('Alerta! CEP inválido'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      );
    }else {
      var url = Uri.https('viacep.com.br', '/ws/$cep/json/');
      var response = await http.get(url);

      print("status req: ${response.statusCode}");
      print("Response body: ${response.body}");

      var decodedJson = convert.jsonDecode(response.body) as Map<String, dynamic>;

      setState(() {
        city = decodedJson['localidade'];
        street = decodedJson['logradouro'];
      });
    }

    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome do seu pet:',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(
                labelText: 'Contato'
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _addressController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              /* maxLength: 8, */
              decoration: InputDecoration(
                labelText: 'Endereço (digite o CEP)'
              ),
              onChanged: (cep) => {
                getCEPInfo(cep)
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                
              },
              child: Text('Cadastrar Pet')
            )
          ],
        ),
      ),
    );
  }
}