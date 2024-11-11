import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/crear_anuncio.dart';
import '../widgets/pet_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> petData = [
    {"username": "usuario1", "petName": "Dama", "status": "Perdido", "imageUrl": "assets/dummy.jpg"},
    {"username": "usuario2", "petName": "Fede", "status": "Encontrado", "imageUrl": "assets/dummy.jpg"},
    {"username": "usuario3", "petName": "Kira", "status": "Perdido", "imageUrl": "assets/dummy.jpg"},
    {"username": "usuario4", "petName": "Luna", "status": "Encontrado", "imageUrl": "assets/dummy.jpg"},
  ];

  List<Map<String, String>> filteredPetData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Cambiamos a 4 pestañas
    _tabController.addListener(_filterPets);
    filteredPetData = List.from(petData); // Mostramos todos los datos inicialmente
  }

  void _filterPets() {
    setState(() {
      switch (_tabController.index) {
        case 0: // Inicio: muestra todas las mascotas
          filteredPetData = List.from(petData);
          break;
        case 1: // Perdidos: muestra solo las mascotas con estado "Perdido"
          filteredPetData = petData.where((pet) => pet['status'] == 'Perdido').toList();
          break;
        case 2: // Encontrados: muestra solo las mascotas con estado "Encontrado"
          filteredPetData = petData.where((pet) => pet['status'] == 'Encontrado').toList();
          break;
        case 3: // Crear Anuncio: muestra el modal de creación de anuncios
          _openCreateAnnouncementModal();
          break;
      }
    });
  }

  void _openCreateAnnouncementModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CreateAnnouncementScreen(), // Muestra directamente tu pantalla de creación de anuncios aquí
          ),
        );
      },
    ).then((newAnnouncement) {
      if (newAnnouncement != null) {
        setState(() {
          petData.add(newAnnouncement);
          filteredPetData = List.from(petData); // Actualiza la lista después de agregar el nuevo anuncio
        });
      }
    });
  }


  @override
  void dispose() {
    _tabController.removeListener(_filterPets);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        tabController: _tabController,
        onCreateAnnouncement: _openCreateAnnouncementModal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Anuncios Recientes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredPetData.length,
              itemBuilder: (context, index) {
                final pet = filteredPetData[index];
                return PetCard(
                  username: pet['username']!,
                  petName: pet['petName']!,
                  status: pet['status']!,
                  imageUrl: pet['imageUrl']!,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        onTap: (index) {
          setState(() {
            _tabController.index = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Perdidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Encontrados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Crear Anuncio',
          ),
        ],
      ),
    );
  }
}
