import 'package:flutter/material.dart';
import "package:pull_to_zoom_refresh/pull_to_zoom_refresh.dart";

void main() {
  runApp(ZoomRefreshPage());
}

class ZoomRefreshPage extends StatefulWidget {
  @override
  _ZoomRefreshPageState createState() => _ZoomRefreshPageState();
}

class _ZoomRefreshPageState extends State<ZoomRefreshPage> with TickerProviderStateMixin{

  AnimationController rotateController;
  double refreshOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    rotateController = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ImageZoomPage",
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            PullToZoomRefresh(
              onRefresh: () async{
                print("onRefresh");
                await Future.delayed(Duration(milliseconds: 2000), (){
                  print("refresh success");
                });
                return null;
              },
              onPullZoom: (dragOffset, mode){
                print("dragOffset>>>$dragOffset");
                print("refreshMode>>>$mode");
                setState(() {
                  if(mode == PullToZoomRefreshMode.drag){
                    refreshOpacity = dragOffset / 50.0;
                    if(refreshOpacity >= 1.0){
                      refreshOpacity = 1.0;
                    }
                  }
                  if(mode == PullToZoomRefreshMode.refresh){
                    rotateController.repeat();
                  }
                  if(mode == PullToZoomRefreshMode.done){
                    refreshOpacity = 0.0;
                    rotateController.reset();
                  }
                });
              },
              imageWidget: Image.asset("assets/header_image.png", fit: BoxFit.cover, height: double.infinity),
              headerWidget: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text('登录', style: TextStyle(fontSize: 20.0),),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('注册', style: TextStyle(fontSize: 20.0),),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('关于', style: TextStyle(fontSize: 20.0),),
                    ),
                  ),
                ],
              ),
              contentWidget: getWidgetList(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              child: Opacity(
                opacity: refreshOpacity,
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(rotateController),
                  child: Image.asset("assets/ic_loading_sun.png", fit: BoxFit.cover, width: 32.0, height: 32.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getWidgetList() {
    List<Widget> widgets = List<Widget>();
    for (int i = 0; i < 50; i++) {
      widgets.add(Padding(padding: EdgeInsets.all(10.0), child: Text("Text $i", style: TextStyle(fontSize: 16.0))));
    }
    return widgets;
  }
}
