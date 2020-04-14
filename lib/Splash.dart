//import 'package:flutter/material.dart';
//
//class Splash1 extends StatefulWidget {
//  @override
//  _Splash1State createState() => _Splash1State();
//}
//
//class _Splash1State extends State<Splash1> with SingleTickerProviderStateMixin {
//  Animation<double> animation;
//
//  AnimationController controller;
//
//  @override
//  void initState() {
//    super.initState();
//    controller =
//        AnimationController(duration: Duration(seconds: 1), vsync: this);
//    final CurvedAnimation curve =
//    CurvedAnimation(parent: controller, curve: Curves.ease);
//    animation = Tween(begin: 1.0, end: 0.2).animate(curve);
//    animation.addStatusListener((status) {
//      if (status == AnimationStatus.completed)
//        controller.reverse();
//      else if (status == AnimationStatus.dismissed) controller.forward();
//    });
//    controller.forward();
//  }
//
//  @override
//  void dispose() {
//    controller.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//        color: Theme
//            .of(context)
//            .accentColor,
//        width: MediaQuery
//            .of(context)
//            .size
//            .width,
//        height: MediaQuery
//            .of(context)
//            .size
//            .height,
//
//        child: FadeTransition(
//          opacity: animation,
//          child: FlutterLogo(),
//        ));
//  }
//}

import 'package:dog/Wrapper.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){

    _controller = VideoPlayerController.asset("assets/splash/splash.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(false);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();

    super.initState();
    _function().then(
            (status){
          _navigatetohome();
        }
    );
  }
  Future<bool> _function() async{
    await Future.delayed(Duration(milliseconds: 4000),(){});
    return true;
  }

  void _navigatetohome() async{
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context)=>Wrapper(),
        )
    );
  }
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Container(child: VideoPlayer(_controller),width: 300,height: 300,),
        ),
      ),
    );
  }
}
