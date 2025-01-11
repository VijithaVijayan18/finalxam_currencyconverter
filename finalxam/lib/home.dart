import 'package:finalxam/splasscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  double _amount = 1.0;
  double _result = 0.0;
  bool _loading = false;

  final List<String> _currencies = ['USD', 'INR', 'EUR', 'JPY', 'GBP', 'AUD'];

  final TextEditingController _amountController = TextEditingController();

  Future<void> _convertCurrency() async {
    if (_amountController.text.isEmpty) {

      showDialog(

        context: context,

        builder: (BuildContext context) {

          return AlertDialog(

            title: const Text('Error'),

            content: const Text('Please enter an amount to convert.'),
            actions: <Widget>[
             TextButton(
             child: const Text('OK'),
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
    setState(() {
      _loading = true;
    });
       final response = await http.get(Uri.parse('https://v6.exchangerate-api.com/v6/1e72dd3f3be5c3d7a1fc1e86/latest/$_fromCurrency'));
        if (response.statusCode == 200) {
      final rates = json.decode(response.body)['conversion_rates'];
      setState(() {
        _result = _amount * rates[_toCurrency];
        _loading = false;
      });
    } else {
       setState(() {
        _loading = false;
        _result = 0.0;
      });
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to fetch exchange rates. Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXLHbTuJOgtVq7788Rbt3BVUgoUxwppJs34w&s'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter The Amount To Convert'),
                onChanged: (value) {
                  setState(() {
                    _amount = double.parse(value);
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  DropdownButton<String>(
                    value: _fromCurrency,
                    items: _currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _fromCurrency = value!;
                      });
                    },
                  ),
                  const Icon(Icons.arrow_forward),
                  DropdownButton<String>(
                    value: _toCurrency,
                    items: _currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _toCurrency = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _convertCurrency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 214, 210, 199),
                ),
                 child: const Text('Convert',
                 style: TextStyle(
                 color: Colors.black,
                  fontWeight: FontWeight.bold,
                  ),

                ),
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : Text(
                      'Result: $_result $_toCurrency',
                      style: const TextStyle(fontSize: 20),
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  //SystemNavigator.pop();
                    Navigator.pushReplacement(
                    context,
                     MaterialPageRoute(builder: (context) => const SplashScreen()),
                     );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 214, 210, 199),
                ),
                 child: const Text('Back',
                 style: TextStyle(
                 color: Colors.black,
                 fontWeight: FontWeight.bold,
                 ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
