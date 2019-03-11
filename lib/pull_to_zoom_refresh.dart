import 'package:flutter/material.dart';

///refresh call back
typedef Future<void> RefreshCallback();

///pull to zoom call back
///[offset]drag offset, [mode]refresh status
typedef PullZoomCallback(double offset, PullToZoomRefreshMode mode);

///default header height
const double _defHeaderHeight = 200.0;

///default header to zoom height
const double _defHeaderZoomHeight = 50.0;

///pull to zoom refresh status
enum PullToZoomRefreshMode {
  drag, // 下拉中
  release, //下拉临界点
  refresh, // 刷新中
  done, // 完成
}

///support ScrollView/ListView pull to zoom header and refresh
///author guoyuanzhuang@gmail.com
class PullToZoomRefresh extends StatefulWidget {

  final RefreshCallback onRefresh;
  final PullZoomCallback onPullZoom;

  final Widget headerWidget;
  final double headerHeight;
  final double headerZoomHeight;
  final Widget imageWidget;
  final List<Widget> contentWidget;

  PullToZoomRefresh({
    Key key,
    @required this.onRefresh,
    @required this.onPullZoom,
    @required this.imageWidget,
    @required this.headerWidget,
    this.contentWidget = const <Widget>[],
    this.headerHeight = _defHeaderHeight,
    this.headerZoomHeight = _defHeaderZoomHeight,
  }): assert(onRefresh != null),
        assert(onPullZoom != null),
        assert(imageWidget != null),
        assert(headerWidget != null),
        super(key: key);

  @override
  _PullToZoomRefreshState createState() => _PullToZoomRefreshState();
}

class _PullToZoomRefreshState extends State<PullToZoomRefresh> with TickerProviderStateMixin{

  ScrollPhysics scrollPhysics = AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics());  //AlwaysScrollableScrollPhysics

  double dragOffset;
  double dycHeaderHeight;
  PullToZoomRefreshMode refreshMode;

  ///pull to back animation
  AnimationController pullDoneController;
  Animation<double> pullDoneAnimation;

  @override
  void initState() {
    super.initState();
    dycHeaderHeight = widget.headerHeight;
    pullDoneController = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
  }

  ///handle to scroll notification
  bool _handleScrollNotification(ScrollNotification notification) {
    if(notification is ScrollStartNotification){
      return false;
    }

    if(notification is UserScrollNotification){
      return false;
    }

    if(notification is ScrollUpdateNotification){
      if(dycHeaderHeight > widget.headerHeight){
        refreshMode = PullToZoomRefreshMode.drag;
        setState(() {
          dycHeaderHeight -= notification.scrollDelta;
          if(dycHeaderHeight <= widget.headerHeight){
            dycHeaderHeight = widget.headerHeight;
            refreshMode = PullToZoomRefreshMode.done;
            widget.onPullZoom(0.0, refreshMode);
          }
        });
      }
    }

    if(notification is ScrollEndNotification){
      //pull to [PullToZoomRefreshMode.release]
      if(dycHeaderHeight >= widget.headerZoomHeight + widget.headerHeight){
        setState(() {
          scrollPhysics = NeverScrollableScrollPhysics();
        });
        refreshMode = PullToZoomRefreshMode.refresh;
        Future<void> callback = widget.onRefresh();
        callback.whenComplete((){
          setState(() {
            scrollPhysics = AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics());  //AlwaysScrollableScrollPhysics
          });
          refreshMode = PullToZoomRefreshMode.done;
          pullToRefreshBack();
          widget.onPullZoom(dragOffset, refreshMode);
        });
      }
      //not pull to [PullToZoomRefreshMode.release]
      if(dycHeaderHeight > widget.headerHeight && dycHeaderHeight < widget.headerZoomHeight + widget.headerHeight){
        refreshMode = PullToZoomRefreshMode.done;
        pullToRefreshBack();
      }
    }
    if(notification is OverscrollNotification){
      //pull down Over scroll
      if(notification.overscroll < 0){
        if(dycHeaderHeight <= widget.headerZoomHeight + widget.headerHeight){
          refreshMode = PullToZoomRefreshMode.drag;
          setState(() {
            dycHeaderHeight += notification.overscroll.abs();
          });
        }else{
          refreshMode = PullToZoomRefreshMode.release;
        }
      }
      //pull up Over scroll
      //Resolves a situation where the ScrollView cannot be manually restored when it is pulled down on a single screen
      if(notification.overscroll > 0){
        if(dycHeaderHeight > widget.headerHeight){
          refreshMode = PullToZoomRefreshMode.drag;
          setState(() {
            dycHeaderHeight -= notification.overscroll;
            if(dycHeaderHeight <= widget.headerHeight){
              dycHeaderHeight = widget.headerHeight;
              refreshMode = PullToZoomRefreshMode.done;
              widget.onPullZoom(0.0, refreshMode);
            }
          });
        }
      }
    }

    //pull to zoom call back
    if(dycHeaderHeight > widget.headerHeight){
      dragOffset = dycHeaderHeight - widget.headerHeight;
      widget.onPullZoom(dragOffset, refreshMode);
    }

    return false;
  }

  ///pull to back animation
  void pullToRefreshBack(){
    pullDoneAnimation = new Tween(begin: dycHeaderHeight, end: widget.headerHeight).animate(pullDoneController)
      ..addListener((){
        setState(() {
          dycHeaderHeight = pullDoneAnimation.value;
        });
      })
      ..addStatusListener((status){
        /*if(status == AnimationStatus.completed){
          widget.onPullZoom(dragOffset, refreshMode);
        }*/
      });
    pullDoneController.reset();
    pullDoneController.forward();
  }

  ///delete android over scroll ripple
  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    notification.disallowGlow();
    return true;
  }

  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Widget child = NotificationListener<ScrollNotification>(
      key: _key,
      onNotification: _handleScrollNotification,
      child:  NotificationListener<OverscrollIndicatorNotification>(
//        onNotification: _handleGlowNotification,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                  getViewList()
              ),
            ),
          ],
          physics: scrollPhysics,
        ),
      ),
    );
    return child;
  }

  getViewList(){
    return List<Widget>()
      ..add(Container(
        height: dycHeaderHeight,
        child: Stack(
          children: <Widget>[
            widget.imageWidget,
            widget.headerWidget,
          ],
        ),
      ))
      ..addAll(widget.contentWidget);
  }

}
