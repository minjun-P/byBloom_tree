import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:flutter/material.dart';

GlobalKey tutorialKey1 = GlobalKey(debugLabel:'tutorial 1');
GlobalKey tutorialKey2 = GlobalKey(debugLabel:'tutorial 2');
GlobalKey tutorialKey3 = GlobalKey(debugLabel:'tutorial 3');
GlobalKey tutorialKey4 = GlobalKey(debugLabel:'tutorial 4');
GlobalKey tutorialKey5 = GlobalKey(debugLabel:'tutorial 5');
GlobalKey tutorialKey6 = GlobalKey(debugLabel:'tutorial 6');

List<TargetFocus> targets = [
  // 1. 하단 나무 아이콘 튜토리얼
  TargetFocus(
      identify: '1',
      keyTarget: tutorialKey1,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(messages: [
              '나의 나무를 여기서 확인할 수 있어요',
              '아이콘을 클릭해보세요'
            ], left: true
            )
        )
      ]
  ),
  // 2. 상단 알림 아이콘 튜토리얼
  TargetFocus(
      identify: '2',
      keyTarget: tutorialKey2,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            child: buildAlert(messages: [
              '나무가 성장한 기록을 확인할 수 있어요!',
              '친구가 물을 주고 간 기록도 볼 수 있구요.'
            ], left: false)
        )
      ]
  ),
  // 3. 상단 친구 목록 튜토리얼
  TargetFocus(
      identify: '3',
      keyTarget: tutorialKey3,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            child: buildAlert(
                messages: [
                  '여기서 내 친구 목록을 볼 수 있어요!',
                  '메세지를 보내거나 친구 프로필을 볼 수도 있구요'
                ], left: true)
        )
      ]
  ),
  // 4. 하단 미션목록 아이콘 튜토리얼
  TargetFocus(
      identify: '4',
      keyTarget: tutorialKey4,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(messages: ['여길 클릭해보세요'], left: true))
      ]
  ),
  TargetFocus(
      identify: '4.5',
      keyTarget: tutorialKey4,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(
                messages: [
                  '이 화면에서는 일간 미션과 주간 미션을 확인할 수 있어요!',
                  '여기 있는 미션을 수행하면 나무가 자라요!'
                ], left: true
            )
        )
      ]
  ),
  // 5. 하단 숲 아이콘 튜토리얼
  TargetFocus(
      identify: '5',
      keyTarget: tutorialKey5,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(messages: ['여길 클릭해보세요'], left: false)
        )
      ]
  ),
  TargetFocus(
      identify: '5.5',
      keyTarget: tutorialKey5,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(
                messages: [
                  '\'숲\' 화면이에요!',
                  '숲에서는 친구모임을 만들거나 개인 메세지를 보낼 수 있어요!'
                ], left: false)
        )
      ]
  ),
  // 6. 하단 저장소 아이콘 튜토리얼
  TargetFocus(
      identify: '6',
      keyTarget: tutorialKey6,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(messages: ['여기를 클릭해보세요!'], left: false)
        ),
      ]
  ),
  TargetFocus(
      identify: '6.5',
      keyTarget: tutorialKey6,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: buildAlert(
              messages: [
                '이 화면은 \'기록 저장소\'입니다',
                '여태까지 완수한 미션들을 확인할 수 있어요!'
              ],
              left: false
            )
        ),
      ]
  ),
];

Widget buildAlert({required List<String> messages,required bool left}) {
  return Column(
    crossAxisAlignment: left?CrossAxisAlignment.start:CrossAxisAlignment.end,
    children: messages.map((element) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text(element),
      );
    }).toList(),
  );
}