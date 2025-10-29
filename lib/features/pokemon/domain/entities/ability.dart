import 'package:equatable/equatable.dart';

class Ability extends Equatable {
  final String name;

  const Ability({required this.name});

  @override
  List<Object> get props => [name];
}
