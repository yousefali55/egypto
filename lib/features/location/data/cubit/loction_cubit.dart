import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'loction_state.dart';

class LocationCubit extends Cubit<LoctionState> {
  LocationCubit() : super(LoctionInitial());
  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    try {
      emit(LoctionLoading());
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      } else if (permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition();
        print(position.latitude);
        print(position.longitude);
        emit(LoctionSuccess(position: position));
      }
    } catch (e) {
      emit(LoctionFailure());
    }
  }
}
