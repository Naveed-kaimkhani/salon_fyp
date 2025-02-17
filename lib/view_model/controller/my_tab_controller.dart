import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  var selectedTab = 0.obs;

  MyTabController(int length) {
    tabController = TabController(length: length, vsync: this);
  }

  void changeTab(int index) {
    selectedTab.value = index;
    tabController.animateTo(index);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
