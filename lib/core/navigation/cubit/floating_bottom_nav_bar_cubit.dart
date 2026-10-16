import 'package:flutter_bloc/flutter_bloc.dart';

class FloatingBottomNavBarCubit extends Cubit<int> {
  FloatingBottomNavBarCubit() : super(0);
  void changeindex(int index){
    emit(index);
  }
}
