import 'package:flutter/material.dart';
import './indie_3d_model_controller.dart';
import './navigation.dart';
import './indie_app_bar.dart';
import './page.dart';
import 'main.dart';


class Indie3dHome extends StatefulWidget {
  @override
  State createState() => _Indie3dHomeState();
}

class _Indie3dHomeState extends State<Indie3dHome> with TickerProviderStateMixin {

  AnimationController _page0TopTitleController;
  AnimationController _page0BottomTitleController;
  AnimationController _page1TopTitleController;
  AnimationController _page1BottomTitleController;
  AnimationController _page2TopTitleController;
  AnimationController _page2BottomTitleController;
  Indie3dModelController _controller;

  int _pageIndex = 0;

  @override
  void initState() {

    const duration = Duration(milliseconds: 400);

    _page0TopTitleController = AnimationController(vsync: this, duration: duration, value: 1.0);
    _page0BottomTitleController = AnimationController(vsync: this, duration: duration, value: 1.0);
    _page1TopTitleController = AnimationController(vsync: this, duration: duration, value: 0.0);
    _page1BottomTitleController = AnimationController(vsync: this, duration: duration, value: 0.0);
    _page2TopTitleController = AnimationController(vsync: this, duration: duration, value: 0.0);
    _page2BottomTitleController = AnimationController(vsync: this, duration: duration, value: 0.0);

    _controller = Indie3dModelController();

    Listenable.merge([
      _page0TopTitleController,
      _page0BottomTitleController,
      _page1TopTitleController,
      _page1BottomTitleController,
      _page2TopTitleController,
      _page2BottomTitleController,
      _controller,
    ]).addListener(() {
      setState(() {
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _page0TopTitleController.dispose();
    _page0BottomTitleController.dispose();
    _page1TopTitleController.dispose();
    _page1BottomTitleController.dispose();
    _page2TopTitleController.dispose();
    _page2BottomTitleController.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(context) {
    if (!_controller.initialized){
      _controller.init(context);
    }
    _controller.setView(MediaQuery.of(context).size);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              onTapUp: _handleTap,
              child: _buildPages(),
            ),
            IndieAppBar(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Indie3dNavigationIndicator(pageIndex: _pageIndex,)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPages() {
    final result = NotificationListener<ScrollUpdateNotification>(
      onNotification: _handleScroll,
      child: PageView(
        scrollDirection: Axis.horizontal,
        onPageChanged: _handlePageChange,
        children: [
          _buildPageForIndex(0),
          _buildPageForIndex(1),
          _buildPageForIndex(2),
        ],
      ),
    );
    return result;
  }

  Widget _buildPageForIndex(int index) {
    Widget result;
    switch (index) {
      case 0:
        result = Indie3dPage(
          topTitle: 'MILES',
          bottomTitle: 'MILLER',
          backgroundColor: Color(0xFF0DD479),
          image: AssetImage('images/artist_1.png', package: App.pkg),
          pageIndex: 0,
          controller: _controller,
          topTitleClipProgress: 1.0 - _page0TopTitleController.value,
          bottomTitleClipProgress: 1.0 - _page0BottomTitleController.value,
          bottomTitleScale: 1.0,
        );
        break;
      case 1:
        result = Indie3dPage(
          topTitle: 'BRET',
          bottomTitle: 'HAMPTON',
          backgroundColor: Color(0xFFECA6C8),
          image: AssetImage('images/artist_2.png', package: App.pkg),
          pageIndex: 1,
          controller: _controller,
          topTitleClipProgress: 1.0 - _page1TopTitleController.value,
          bottomTitleClipProgress: 1.0 - _page1BottomTitleController.value,
          backgroundShapeOpacity: 1.0,
          bottomTitleScale: 0.9,
        );
        break;
      case 2:
        result = Indie3dPage(
          topTitle: 'CINDY',
          bottomTitle: 'GREY',
          backgroundColor: Color(0xFFFFD500),
          image: AssetImage('images/artist_3.png', package: App.pkg),
          pageIndex: 2,
          controller: _controller,
          topTitleClipProgress: 1.0 - _page2TopTitleController.value,
          bottomTitleClipProgress: 1.0 - _page2BottomTitleController.value,
        );
        break;
    }
    return result;
  }

  bool _handleScroll(ScrollUpdateNotification scrollUpdate) {
    setState(() {
      final appSize = MediaQuery.of(context).size;
      double pageProgress = (1.0 - ((scrollUpdate.metrics.pixels / appSize.width) - _pageIndex)
          .abs().clamp(0.0, 1.0)) * 2.0 - 1.0;
      _controller.cameraOffset = (1 - pageProgress) * 8.0 * scrollUpdate.scrollDelta.sign;

      double animValue = 0;
      switch (_pageIndex) {
        case 0: animValue = _page0TopTitleController.value; break;
        case 1: animValue = _page1TopTitleController.value; break;
        case 2: animValue = _page2TopTitleController.value; break;
      }

      if (animValue != 0) {
        switch (_pageIndex) {
          case 0:
            if (!_page0TopTitleController.isAnimating) {
              _page0TopTitleController.value = pageProgress;
              _page0BottomTitleController.value = pageProgress;
            }
            break;
          case 1:
            if (!_page1TopTitleController.isAnimating) {
              _page1TopTitleController.value = pageProgress;
              _page1BottomTitleController.value = pageProgress;
            }
            break;
          case 2:
            if (!_page2TopTitleController.isAnimating) {
              _page2TopTitleController.value = pageProgress;
              _page2BottomTitleController.value = pageProgress;
            }
            break;
        }
      }
      switch (_pageIndex) {
        case 0:
          if (pageProgress > 0.99) {
            _page0TopTitleController.animateTo(1.0);
            Future.delayed(Duration(milliseconds: 200),
              () => _page0BottomTitleController.animateTo(1.0)
            );
          }
          _page1TopTitleController.reset();
          _page1BottomTitleController.reset();
          _page2TopTitleController.reset();
          _page2BottomTitleController.reset();
          break;
        case 1:
          _page0TopTitleController.reset();
          _page0BottomTitleController.reset();
          if (pageProgress > 0.99) {
            _page1TopTitleController.animateTo(1.0);
            Future.delayed(Duration(milliseconds: 200),
              () => _page1BottomTitleController.animateTo(1.0)
            );
          }
          _page2TopTitleController.reset();
          _page2BottomTitleController.reset();
          break;
        case 2:
          _page0TopTitleController.reset();
          _page0BottomTitleController.reset();
          _page1TopTitleController.reset();
          _page1BottomTitleController.reset();
          if (pageProgress > 0.99) {
            _page2TopTitleController.animateTo(1.0);
            Future.delayed(Duration(milliseconds: 200),
              () => _page2BottomTitleController.animateTo(1.0)
            );
          }
          break;
      }
    });

    return false;
  }

  void _handleTap(TapUpDetails details) {
    _controller.triggerTap(context, details.localPosition, _pageIndex);
  }

  void _handlePageChange(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

}



