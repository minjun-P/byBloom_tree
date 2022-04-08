import 'package:bybloom_tree/DBcontroller.dart';
import 'package:bybloom_tree/main_controller.dart';
import 'package:bybloom_tree/pages/mission_page/mission_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class MissionDPage extends StatelessWidget {
  const MissionDPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('D'),
        )
      ),
    );
  }
}
