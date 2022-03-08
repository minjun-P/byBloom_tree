import 'package:flutter/material.dart';

class SurveyB extends StatefulWidget {
  final List choices;
  const SurveyB({
    Key? key,
    required this.choices
  }) : super(key: key);

  @override
  _SurveyBState createState() => _SurveyBState();
}

class _SurveyBState extends State<SurveyB> {
  int selectedIndex = 0;
  bool submitted = false;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 210,left: 20,right: 20),
      children: [
        Table(
          children: [
            TableRow(
                children: [
                  _buildTableContainer(1,widget.choices[0]),
                  _buildTableContainer(2,widget.choices[1])
                ]
            ),
            TableRow(
                children: [
                  _buildTableContainer(3, widget.choices[2]),
                  _buildTableContainer(4, widget.choices[3])
                ]
            )
          ],
        ),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ElevatedButton(
            onPressed: (){
              setState(() {
                submitted = !submitted;
              });
            },
            child: Text('선택하기',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
            style: ElevatedButton.styleFrom(
                primary: Colors.greenAccent,
                minimumSize: Size.fromHeight(45)
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTableContainer(int index, String title) {
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedIndex = index;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.green.shade200,
                  borderRadius: BorderRadius.circular(10),
                  border: selectedIndex == index&&!submitted?Border.all(color: Colors.amber,width: 4):null
              ),
              clipBehavior: Clip.hardEdge,
              margin: EdgeInsets.all(15),
              height: 150,
              alignment: Alignment(0,01),
              child: Visibility(
                visible: submitted,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 0.1*index,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ),
              )
          ),
          Positioned(
              bottom: 30,
              child: Visibility(
                visible: !submitted,
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              )
          ),
          Positioned(
              child: Visibility(
                visible: submitted,
                child: Text(
                  '${index*10}%',
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              )
          )

        ],
      ),
    );
  }
}
