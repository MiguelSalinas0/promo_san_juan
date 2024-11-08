import 'package:flutter/material.dart';
import 'package:promo_san_juan/helper/database_helper.dart';
import 'package:promo_san_juan/models/models.dart';
import 'package:promo_san_juan/widgets/commerce_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Comercio> _comercios = [];
  List<Comercio> _filteredComercios = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadComercios();
    _focusNode.requestFocus();
    _searchController.addListener(_filterComercios);
  }

  Future<void> _loadComercios() async {
    final comercios = await DatabaseHelper.instance.getComerciosUser();
    setState(() {
      _comercios = comercios;
      _filteredComercios = comercios;
    });
  }

  void _filterComercios() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredComercios = _comercios.where((comercio) {
        return comercio.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Comercios'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              focusNode: _focusNode,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Escribe para buscar...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF00ADB5),
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredComercios.isEmpty
                ? const Center(child: Text('No se encontraron comercios'))
                : ListView.builder(
                    itemCount: _filteredComercios.length,
                    itemBuilder: (context, index) {
                      final comercio = _filteredComercios[index];
                      return CommerceCard(
                        id: comercio.id,
                        nombre: comercio.name,
                        descripcion: comercio.descripcion,
                        urlImagen: comercio.imagePath,
                        isAdmin: false,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
