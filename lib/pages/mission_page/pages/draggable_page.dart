import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DraggablePage2 extends StatefulWidget {
  final String missionType;
  final String missionQuestion;
  const DraggablePage2({
    Key? key,
    required this.missionType,
    required this.missionQuestion
  }) : super(key: key);

  @override
  State<DraggablePage2> createState() => _DraggablePage2State();
}

class _DraggablePage2State extends State<DraggablePage2> {
  bool _opened = true;
  int _selectedIndex = 0;
  bool _submitted = false;
  PanelController controller = PanelController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SlidingUpPanel(
          controller: controller,
          // panel open 시, 뒷 화면 검은색
          backdropEnabled: true,
          // panel 세팅
          defaultPanelState: PanelState.OPEN,
          slideDirection: SlideDirection.DOWN,
          minHeight: 200,
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft:  Radius.circular(20)),
          // open, close 시 변수 변경 및 rebuild
          onPanelOpened: (){
            setState(() {
              _opened = true;
            });
          },
          onPanelClosed: (){
            setState(() {
              _opened = false;
            });
          },

          panel: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 이미지
              Image.asset(
                'assets/bible_sample.png',
                width: 200,
              ),
              Spacer(),
              // 미션타입 ex) 오늘의 질문
              Text(widget.missionType, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              // 미션 구절
              Container(
                width:200,
                height: 200,
                alignment: Alignment.center,
                child: Text(
                  widget.missionQuestion,
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              Visibility(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        Text('위로 밀어올리기',style: TextStyle(color: Colors.grey,fontSize: 13),),
                        Positioned(
                          bottom: -50,
                          child: IconButton(
                            icon:Icon(Icons.arrow_upward,size: 50,),
                            onPressed: (){
                              controller.close();
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
                visible: _opened,
              )
            ],
          ),
          body: ListView(
            padding: EdgeInsets.only(top: 210,left: 20,right: 20),
            children: [
              Table(
                children: [
                  TableRow(
                    children: [
                      _buildTableContainer(1,'모세'),
                      _buildTableContainer(2, '아브라함')
                    ]
                  ),
                  TableRow(
                    children: [
                      _buildTableContainer(3, '사도바울'),
                      _buildTableContainer(4, '베드로')
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
                      _submitted = !_submitted;
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
          ),
        ),
      ),
    );
  }

  Widget _buildTableContainer(int index, String title) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: BorderRadius.circular(10),
              border: _selectedIndex == index&&!_submitted?Border.all(color: Colors.amber,width: 4):null
            ),
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.all(15),
            height: 150,
            alignment: Alignment(0,01),
            child: Visibility(
              visible: _submitted,
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
                visible: !_submitted,
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
                visible: _submitted,
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
