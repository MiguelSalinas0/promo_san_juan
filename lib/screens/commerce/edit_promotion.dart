// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:promo_san_juan/helper/database_helper.dart';
import 'package:promo_san_juan/models/models.dart';

class EditPromotionScreen extends StatefulWidget {
  final Promocion promotion;

  const EditPromotionScreen({super.key, required this.promotion});

  @override
  _EditPromotionScreenState createState() => _EditPromotionScreenState();
}

class _EditPromotionScreenState extends State<EditPromotionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _fechaInicio;
  late DateTime _fechaFin;
  bool _activo = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.promotion.title);
    _descriptionController =
        TextEditingController(text: widget.promotion.description);
    _fechaInicio = widget.promotion.fechaInicio;
    _fechaFin = widget.promotion.fechaFin;
    _activo = widget.promotion.activo;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(
      {required BuildContext context, required bool isStart}) async {
    DateTime initialDate = isStart ? _fechaInicio : _fechaFin;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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

  void _savePromotion() async {
    if (_formKey.currentState!.validate()) {
      Promocion updatedPromotion = Promocion(
        id: widget.promotion.id,
        commerceId: widget.promotion.commerceId,
        title: _titleController.text,
        description: _descriptionController.text,
        activo: _activo,
        fechaInicio: _fechaInicio,
        fechaFin: _fechaFin,
      );

      await DatabaseHelper.instance.updatePromotion(updatedPromotion);

      Navigator.pop(context, updatedPromotion);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Promoción'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePromotion,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
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
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
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
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Fecha de Inicio'),
                  TextButton(
                    onPressed: () => _pickDate(context: context, isStart: true),
                    child: Text(
                      '${_fechaInicio.toLocal()}'.split(' ')[0],
                      style: const TextStyle(color: Color(0xFF00ADB5)),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Fecha de Fin'),
                  TextButton(
                    onPressed: () =>
                        _pickDate(context: context, isStart: false),
                    child: Text(
                      '${_fechaFin.toLocal()}'.split(' ')[0],
                      style: const TextStyle(color: Color(0xFF00ADB5)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
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
            ],
          ),
        ),
      ),
    );
  }
}
