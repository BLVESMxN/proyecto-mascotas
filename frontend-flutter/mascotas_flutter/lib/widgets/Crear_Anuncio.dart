import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  @override
  _CreateAnnouncementScreenState createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveAnnouncement() {
    final newAnnouncement = {
      "username": "Nuevo Usuario",
      "petName": _nameController.text,
      "status": "Perdido",
      "imageUrl": "assets/new_image.jpg",
      "date": _selectedDate != null ? DateFormat('MM/dd/yyyy').format(_selectedDate!) : '',
      "description": _descriptionController.text,
    };
    Navigator.pop(context, newAnnouncement);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nombre de la Mascota',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Fecha de Extravio',
                  hintText: 'MM/DD/YYYY',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? ''
                      : DateFormat('MM/dd/yyyy').format(_selectedDate!),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Descripción',
              hintText: 'Escribe una breve descripción',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              // Implementar funcionalidad para escoger imagen
            },
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 50, color: Colors.grey),
                  SizedBox(height: 8),
                  Text("Escoger Imagen"),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Volver"),
              ),
              ElevatedButton(
                onPressed: _saveAnnouncement,
                child: Text("Guardar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
