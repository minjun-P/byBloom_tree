import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DraggablePage extends StatefulWidget {
  const DraggablePage({Key? key}) : super(key: key);

  @override
  State<DraggablePage> createState() => _DraggablePageState();
}

class _DraggablePageState extends State<DraggablePage> {
  bool _opend = true;
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        bottomSheet: _opend?null:Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
            boxShadow: [
              BoxShadow(
                offset: Offset(0,-0.7),
                color: Colors.grey,
                blurRadius: 5,
                spreadRadius: 0.1
              )
            ]
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.amber,
              ),
              SizedBox(width:10),
              Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: '랄라블라로 의견 남기기'
                    ),
                    maxLines: 2,
                  )
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: (){},
              )
            ],
          ),
        ),
        body: SlidingUpPanel(
          padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 0),
          defaultPanelState: PanelState.OPEN,
          onPanelClosed: (){
            print('closed');
            setState(() {
              _opend = false;
            });
          },
          onPanelOpened: (){
            print('open');
            setState(() {
              _opend = true;
            });
          },
          slideDirection: SlideDirection.DOWN,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
          minHeight: 150,
          panel: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                  'assets/bible_sample.png',
                width: 200,

              ),
              SizedBox(height: 20,),
              Text('오늘의 말씀', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
              SizedBox(height: 40,),
              Container(
                color: Colors.grey.shade50,
                  child: Column(
                    children: [
                      Text('그런데 뱀은 여호와 하나님이 지으신 들짐승 중에 가장 간교하니라 뱀이 여자에게 물어 이르되 하나님이 참으로 너희에게 동산, 모든 나무의 열매를 먹지 말라 하시더냐 여자가 뱀에게 말하되 동산 나무의 열매를 우리가 먹을 수 있으나'),
                      SizedBox(height: 20,),

                    ],
                  ),
              ),
              Visibility(
                child: Column(
                  children: [
                    Align(child: Text('창세기 3:3'), alignment: Alignment.centerLeft,),
                    Text('위로 밀어올리기',style: TextStyle(color: Colors.grey,fontSize: 13),),
                    SizedBox(height: 10,)
                  ],
                ),
                visible: _opend,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 170,left: 20,right: 20,bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('인기순'),
                SizedBox(height: 10,),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.red,
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('세요나프레', style: TextStyle(color: Colors.grey),),
                                  Text('아멘'),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.event,color: Colors.grey,),
                                      Text(index.toString(),style: TextStyle(color: Colors.grey),)
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(thickness: 2,);
                      },
                      itemCount: 20
                  ),
                ),

              ],
            )
          ),
        ),
      ),
    );
  }
}
