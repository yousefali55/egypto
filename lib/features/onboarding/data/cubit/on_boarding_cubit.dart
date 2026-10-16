import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());
  final PageController pageController = PageController();
  void changePage(int index) {
    emit(OnBoardingInitial(currentIndex: index));
  }
  void nextPage(int totalPages){
    if(state.currentIndex < totalPages - 1){
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }
  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
