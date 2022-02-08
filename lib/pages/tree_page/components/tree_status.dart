import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TreeStatus extends StatelessWidget {
  const TreeStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: IconButton(
              icon: Icon(
                  Icons.check_circle_outline,
                color: Colors.white,
                size: 60,
              ),
              onPressed: (){},),
          ),
          SizedBox(height: 10,),
          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white
            ),
          )
        ],
      ),
    );
  }
}
