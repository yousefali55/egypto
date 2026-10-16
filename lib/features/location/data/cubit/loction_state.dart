part of 'loction_cubit.dart';

@immutable
sealed class LoctionState {}

final class LoctionInitial extends LoctionState {}

final class LoctionLoading extends LoctionState {}

final class LoctionSuccess extends LoctionState {
  final Position? position;

  new({required this.position});
}

final class LoctionFailure extends LoctionState {
  String errorMessage = 'Unkown place';
}
