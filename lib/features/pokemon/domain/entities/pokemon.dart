import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  final int id;
  final String nombre;
  final String imageUrl;
  final List<String> types;

  const Pokemon({
    required this.id,
    required this.nombre,
    required this.imageUrl,
    required this.types,
  });

  @override
  List<Object> get props => [id, nombre, imageUrl, types];
}
