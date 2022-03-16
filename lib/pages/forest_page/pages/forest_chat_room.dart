import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../forest_model.dart';

/// 채팅방 UI
/// 대강 만들어 놓긴 했는데 보내는 버튼도 안 넣어놨고
/// 주환 너가 직접 만들어본 경험 있으니깐 여기는 직접 다루는게 더 편할 듯 해서 더 안 건드림
/// 채팅 목록은 forest_model에서 가져왔으.
class ForestChatRoom extends StatelessWidget {
  final Forest forest;
  ForestChatRoom({
    Key? key,
    required this.forest
  }) : super(key: key);
  /// 나중에 이 친구들 controller로 보내는게 깔끔할지도?
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(forest.name),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xffFAE7E2),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              /// 키보드가 생겨날 때, 화면이 그에 따라 움직일 수 있도록 만드는게 중요했다.
              /// 사용자경험 차원에서 보던 메시지가 계속 보여야 함. 여러방법을 찾아봤는데
              /// reverse를 활용하는 방법이 제일 좋음. 그래서 코드가 좀 더러워지긴 함.
              /// 원래는 이렇게 키보드가 생길 때 보이던 화면이 그대로 올라가질 않았음.
              reverse: true,
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index){
                /// 조건문으로 상대가 보낸 메시지와 내가 보낸 메시지를 구분해놓음
                // 상대가 보낸 메시지
                if (messages[messages.length-1-index].user !='나') {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 20,
                        ),
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(messages[messages.length-1-index].user,style: const TextStyle(color: Colors.grey, fontSize: 14),),
                            const SizedBox(height: 5,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  // overflow 방지 위해 with 명시적 설정
                                  constraints: BoxConstraints(maxWidth: Get.width*0.6),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Text(
                                      messages[messages.length-1-index].content),
                                ),
                                const SizedBox(width: 10,),
                                Text(messages[messages.length-1-index].getTime(),style: const TextStyle(color: Colors.grey, fontSize: 12),),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  // 내가 보낸 메시지
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(messages[messages.length-1-index].getTime(),style: const TextStyle(color: Colors.grey, fontSize: 12),),
                        const SizedBox(width: 10,),
                        Container(

                          constraints: BoxConstraints(maxWidth: Get.width*0.6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(
                              messages[messages.length-1-index].content),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            // border Radius 가 내가 원하는 데로 적용이 안됨. 나중에 수정이 필요함.
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
            ),
            alignment: Alignment.center,
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 80
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              child: TextFormField(
                controller: textEditingController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  border: InputBorder.none
                ),
                // 알아서 line이 늘어나고 스크롤도 됨
                maxLines: null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
