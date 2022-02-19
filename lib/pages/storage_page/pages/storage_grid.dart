import 'package:flutter/material.dart';

/// 한번에 보기 페이지
class StorageGrid extends StatelessWidget {
  const StorageGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
      ),
      body: Card(
        color: const Color(0xff898989),
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(width: 2,color: Color(0xff898989))
        ),
        clipBehavior: Clip.hardEdge,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2
          ),
          addRepaintBoundaries: false,
          itemCount: 20,
          itemBuilder: (context, index) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            );
          },
        ),
      )
    );
  }
}
