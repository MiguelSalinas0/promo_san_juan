// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:promo_san_juan/models/models.dart';

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
  bool _activo = true;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Promoción'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 20),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CheckboxListTile(
                  title: const Text('Activo'),
                  value: _activo,
                  onChanged: (bool? value) {
                    setState(() {
                      _activo = value ?? true;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.platform,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Fecha de Inicio'),
                  subtitle: Text(_fechaInicio != null
                      ? _fechaInicio!.toLocal().toString().split(' ')[0]
                      : 'Seleccione una fecha'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, true),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Fecha de Fin'),
                  subtitle: Text(_fechaFin != null
                      ? _fechaFin!.toLocal().toString().split(' ')[0]
                      : 'Seleccione una fecha'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, false),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final newPromotion = Promocion(
                        title: _title,
                        description: _description,
                        commerceId: widget.idcomercio,
                        activo: _activo,
                        fechaInicio: _fechaInicio ?? DateTime.now(),
                        fechaFin: _fechaFin ?? DateTime.now(),
                      );

                      widget.onSave(newPromotion);

                      // Regresar a la pantalla anterior
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Guardar Promoción',
                    style: TextStyle(color: Color(0xFF00ADB5)),
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
