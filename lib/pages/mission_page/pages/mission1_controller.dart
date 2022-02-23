import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Choice {yet,q1,q2,q3,q4}


class Mission1Controller {
  var submitted = false.obs;
  void updateSubmitted () {
    submitted(!submitted.value);
  }
  var choiceChecked = Choice.yet.obs;


}