// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:promo_san_juan/helper/database_helper.dart';
import 'package:promo_san_juan/models/models.dart';

class PromotionDetailScreen extends StatefulWidget {
  const PromotionDetailScreen({super.key, required this.id});
  final int id;

  @override
  _PromotionDetailState createState() => _PromotionDetailState();
}

class _PromotionDetailState extends State<PromotionDetailScreen> {
  Promocion? promocion;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPromocionDetalles();
  }

  Future<void> _loadPromocionDetalles() async {
    final detalles = await DatabaseHelper.instance.getPromotionById(widget.id);
    setState(() {
      promocion = detalles;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Detalles de Promoción')),
        body: SingleChildScrollView(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          promocion!.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          promocion!.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Fecha de inicio: ${promocion!.fechaInicio.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Fecha de fin: ${promocion!.fechaFin.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )));
  }
}
