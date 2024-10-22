import 'package:flutter/material.dart';
import 'package:promo_san_juan/helper/database_helper.dart';
import 'package:promo_san_juan/models/carousel.dart';

class EditPromotionScreen extends StatefulWidget {
  final Promocion promotion;

  const EditPromotionScreen({super.key, required this.promotion});

  @override
  // ignore: library_private_types_in_public_api
  _EditPromotionScreenState createState() => _EditPromotionScreenState();
}

class _EditPromotionScreenState extends State<EditPromotionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.promotion.title);
    _descriptionController = TextEditingController(text: widget.promotion.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _savePromotion() async {
    if (_formKey.currentState!.validate()) {
      // Crear una nueva instancia de la promoción con los datos actualizados
      Promocion updatedPromotion = Promocion(
        id: widget.promotion.id,
        commerceId: widget.promotion.commerceId,
        title: _titleController.text,
        description: _descriptionController.text,
      );

      // Llamar al método para actualizar la promoción en la base de datos
      await DatabaseHelper.instance.updatePromotion(updatedPromotion);

      // ignore: use_build_context_synchronously
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
              const SizedBox(height: 16),
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
            ],
          ),
        ),
      ),
    );
  }
}
