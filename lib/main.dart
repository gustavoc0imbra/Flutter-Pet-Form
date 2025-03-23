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
      theme: ThemeData(primarySwatch: Colors.orange),
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
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _observationController = TextEditingController();

  void getCEPInfo(String cep) async {
    if (cep.length != 8) {
      return;
    }

    var url = Uri.https('viacep.com.br', '/ws/$cep/json/');
    var response = await http.get(url);

    print("${response.body}");

    if (response.statusCode != HttpStatus.ok) {
      return;
    }

    var decodedJson = convert.jsonDecode(response.body) as Map<String, dynamic>;

    setState(() {
      _cityController.text = decodedJson['localidade'];
      _streetController.text = decodedJson['logradouro'];
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome do seu pet:'
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
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Telefone',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _addressController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              maxLength: 8,
              decoration: InputDecoration(
                labelText: 'Endereço (digite o CEP)'
              ),
              onChanged: (cep) {
                getCEPInfo(cep);
              },
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Cidade'
              ),
            ),
            TextField(
              controller: _streetController,
              decoration: InputDecoration(
                labelText: 'Rua'
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _observationController,
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Observação'
                ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String result = "--------Cadastro Pet--------";
                result += "\nNome Pet: ${_nameController.text}";
                result += "\nContato: ${_contactController.text}";
                result += "\nTelefone: ${_phoneController.text}";
                result += "\nEndereço (CEP): ${_addressController.text}";
                result += "\nEndereço (Cidade): ${_cityController.text}";
                result += "\nEndereço (Rua): ${_streetController.text}";
                result += "\nObservação: ${_observationController.text}";
                print(result);
              },
              child: Text('Cadastrar Pet')
            ),
          ],
        ),
      ),
    );
  }
}
