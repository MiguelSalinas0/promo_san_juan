// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:promo_san_juan/models/carousel.dart';

class NewPromotionScreen extends StatefulWidget {
  final Function(Promocion) onSave;
  final int idcomercio;

  const NewPromotionScreen(
      {super.key, required this.onSave, required this.idcomercio});

  @override
  _NewPromotionScreenState createState() => _NewPromotionScreenState();
}

class _NewPromotionScreenState extends State<NewPromotionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Promoción'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Título',
                  floatingLabelStyle: TextStyle(color: Color(0xFF00ADB5)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF00ADB5),
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un título';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value ?? '';
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  floatingLabelStyle: TextStyle(color: Color(0xFF00ADB5)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF00ADB5),
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una descripción';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newPromotion = Promocion(
                        title: _title,
                        description: _description,
                        commerceId: widget.idcomercio);

                    widget.onSave(newPromotion);

                    // Regresar a la pantalla anterior
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Guardar Promoción',
                    style: TextStyle(color: Color(0xFF00ADB5))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
