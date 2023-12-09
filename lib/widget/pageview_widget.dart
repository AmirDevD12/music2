
import 'package:first_project/screen/album/albom_page.dart';
import 'package:first_project/screen/artist/count_artist.dart';
import 'package:first_project/screen/folder/folder_song.dart';
import 'package:first_project/screen/list_song.dart';
import 'package:first_project/widget/them_seitcher.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PageController controller=PageController();
  final List<Widget> _list=<Widget>[
    const Center(child:ListMusic() ),
    const Center(child: Artist()),
    const Center(child: AlbumPage()),
    Center(child: AlbumList()),
  ];
  int curr=0;
List<String> ListIssue=<String>["Songs ","Artist","Album","Folder"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        actions: [ThemeSwitcher()],
        backgroundColor:const Color(0xff1a1b1d),
        title: Text('My music',textAlign: TextAlign.center,),
      ),
        body: Column(
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.red,
              height: 40,
              child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {

                        return Column(crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30,right: 30),
                              child: SizedBox(
                                child: InkWell(
                                  onTap: (){
                                    controller.animateToPage(index,
                                        duration: Duration(milliseconds: 10),
                                        curve: Curves.easeOut);
                                  },
                                  child:  Text(ListIssue[index],
                                       ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                           curr==index? SmoothPageIndicator(
                              controller: controller,
                              count:  1,
                              axisDirection: Axis.horizontal,
                              effect:  const SlideEffect(
                                  spacing:  8.0,
                                  radius:  14.0,
                                  dotWidth:  24.0,
                                  dotHeight:  6.0,
                                  paintStyle:  PaintingStyle.fill,

                              ),
                            ):const SizedBox(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ), Expanded(
              child: PageView(
                children:
                _list,
                scrollDirection: Axis.horizontal,
                // reverse: true,
                // physics: BouncingScrollPhysics(),
                controller: controller,
                onPageChanged: (num){
                   setState(() {
                     curr=num;
                   });
                },
              ),
            ),
          ],
        ),

    );
  }
}

