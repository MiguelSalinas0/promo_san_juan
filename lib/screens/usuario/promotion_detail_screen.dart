// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:promo_san_juan/helper/database_helper.dart';
import 'package:promo_san_juan/models/models.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

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

  // Funcion para mostrar el QR en un dialog
  void _showQrDialog(BuildContext context, String data) {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Código QR"),
            content: SizedBox(
              height: 250,
              width: 250,
              child: QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 200.0,
                gapless: false,
                backgroundColor: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cerrar"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.75;

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

                        const SizedBox(height: 20),

                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Botón "Generar QR"
                              SizedBox(
                                width: width,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showQrDialog(context, promocion!.description);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    backgroundColor: const Color(0xFF00ADB5),
                                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(50.0)),
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  ),
                                  child: const Text(
                                    'Generar código QR',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20.0),

                              // Botón "Compartir"
                              SizedBox(
                                width: width,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Share.share(promocion!.description);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  ),
                                  child: const Text(
                                    'Compartir',
                                    style: TextStyle(color: Color(0xFF00ADB5)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )));
  }
}
