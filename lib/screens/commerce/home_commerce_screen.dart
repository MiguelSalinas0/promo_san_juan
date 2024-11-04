import 'package:flutter/material.dart';
import 'package:promo_san_juan/helper/database_helper.dart';
import 'package:promo_san_juan/models/models.dart';
import 'package:promo_san_juan/screens/commerce/edit_promotion.dart';
import 'package:promo_san_juan/screens/commerce/new_promotion.dart';
import 'package:promo_san_juan/widgets/auth_service.dart';

class CommerceHome extends StatefulWidget {
  const CommerceHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CommerceHome> {
  int? idCommerce;
  bool isLoading = true; // Variable para controlar el estado de carga
  bool habilitado = false;
  List<Promocion> promotions = [];

  @override
  void initState() {
    super.initState();
    _loadCommerceId();
    _loadPromotions();
    _loadHabilitacion();
  }

  Future<void> _loadCommerceId() async {
    int? id = await AuthService.getCommerceId();
    setState(() {
      idCommerce = id;
    });
  }

  Future<void> _loadPromotions() async {
    // Simulación de carga de promociones por comercio
    int? idC = await AuthService.getCommerceId();
    List<Promocion> loadedPromotions = await DatabaseHelper.instance.getPromotionsByCommerce(idC!);
    setState(() {
      promotions = loadedPromotions;
      isLoading = false;
    });
  }

  Future<void> _loadHabilitacion() async {
    int? idC = await AuthService.getCommerceId();
    bool habilitadoResult = await DatabaseHelper.instance.consultarHabilitacion(idC!);
    setState(() {
      habilitado = habilitadoResult;
    });
  }

  void _editPromotion(Promocion promotion) async {
    final updatedPromotion = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPromotionScreen(promotion: promotion),
      ),
    );

    if (updatedPromotion != null) {
      setState(() {
        int index = promotions.indexOf(promotion);
        promotions[index] = updatedPromotion;
      });
    }
  }

  Future<void> _deletePromotion(Promocion promotion) async {
    await DatabaseHelper.instance.deletePromotion(promotion.id!, promotion.commerceId);
    setState(() {
      promotions.remove(promotion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Comercio')),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      habilitado == true
                          ? "Tu comercio está habilitado"
                          : "Tu comercio fue inhabilitado por un administrador",
                      style: TextStyle(
                        fontSize: 20,
                        color: habilitado == true ? Colors.green : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navegar a la pantalla de crear nueva promoción
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NewPromotionScreen(
                                  onSave: (newPromotion) {
                                    setState(() {
                                      promotions.add(newPromotion);
                                      DatabaseHelper.instance.addPromotion(newPromotion);
                                    });
                                  },
                                  idcomercio: idCommerce!,
                                )));
                      },
                      child: const Text('Agregar Nueva Promoción',
                          style: TextStyle(color: Color(0xFF00ADB5))),
                    ),
                  ),
                  Expanded(
                    child: promotions.isNotEmpty
                        ? ListView.builder(
                            itemCount: promotions.length,
                            itemBuilder: (context, index) {
                              final promotion = promotions[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Título y descripción a la izquierda, con Expanded para evitar overflow
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              promotion.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              promotion.description,
                                              style: const TextStyle(fontSize: 14.0),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Botones de editar y eliminar a la derecha
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Color(0xFF00ADB5)),
                                            onPressed: () => _editPromotion(promotion),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () => _deletePromotion(promotion),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text('No hay promociones disponibles')),
                  )
                ],
              ));
  }
}
