import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeState {
  final PageController pageController = PageController();
  RxInt currentIndex = 0.obs;

  HomeState() {
    ///Initialize variables
  }
}
