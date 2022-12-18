import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

///
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

///
import 'package:moodexample/themes/app_theme.dart';

/// 页面
import 'package:moodexample/views/lifespan/index.dart';

/// 首页底部Tabbar
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  /// Tab控制
  late TabController _pageController;

  /// 进步按钮动画
  late AnimationController _stepButtonController;
  late Animation<double> _stepButtonAnimation;
  late CurvedAnimation _stepButtonCurve;

  bool isStartTrain = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  late AssetsAudioPlayer? _assetsAudioPlayer;

  /// 默认状态 为关闭
  ValueNotifier<DrawerState> drawerState = ValueNotifier(DrawerState.closed);

  /// Tab icon大小
  final double _tabIconSize = 20.sp;

  /// 当前页
  late int _currentPage = 0;

  /// 页面
  final List<Widget> pages = [
    /// 首页
    // const HomePage(),
    // const MoodPage(),
    // const StatisticPage(),
    const LifespanPage(),
    // const CalculatorPage(),
  ];

  @override
  void initState() {
    super.initState();

    /// 进步按钮Icon动画
    _stepButtonController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _stepButtonCurve = CurvedAnimation(
      parent: _stepButtonController,
      curve: Curves.fastOutSlowIn,
    );
    _stepButtonAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_stepButtonController);
    _stepButtonAnimation.addListener(() {
      setState(() {});
    });

    /// Tab控制
    _pageController = TabController(
      initialIndex: _currentPage,
      length: pages.length,
      vsync: this,
    );

    _animationController =
        AnimationController(duration: const Duration(seconds: 900), vsync: this);

    _animation = Tween<double>(
      begin: 1,
      end: 300,
    ).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // 动画完成后反转
          _animationController.reverse();
          // _animationController.reverse();
          // _animationController.forward();
        } else if (status == AnimationStatus.dismissed) {
          // 反转回初始状态时继续播放，实现无限循环
          _animationController.forward();
        }
      });
    _animationController.forward();


    _assetsAudioPlayer = AssetsAudioPlayer();
    // _assetsAudioPlayer?.open(Audio("assets/music/Lantern.mp3"),
    //     autoStart: true, showNotification: false, loopMode: LoopMode.single);
  }

  @override
  void dispose() {
    /// 进步按钮Icon动画
    _stepButtonController.dispose();

    /// Tab控制
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //屏幕自适应 设置尺寸（填写设计中设备的屏幕尺寸）如果设计基于360dp * 690dp的屏幕
    ScreenUtil.init(
      context,
      designSize: Size(AppTheme.wdp, AppTheme.hdp),
    );
    ThemeData appTheme = Theme.of(context);

    void callback() {
      debugPrint("--callback-----");
      // Scaffold.of(context).isDrawerOpen;
      // _scaffoldKey.currentState!.closeDrawer();
    }

    void _settle(DragEndDetails details) {
      debugPrint("--_settle-----");
      ZoomDrawer.of(context)?.toggle.call();
    }

    // void _move(DragUpdateDetails details) {
    //   debugPrint("--_move-----");
    // }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AppTheme.backgroundImage,
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          // backgroundColor: Theme.of(context).tabBarTheme.labelColor,
          backgroundColor: Colors.transparent,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              const Positioned(child: LifespanPage()),
              GestureDetector(
                  // onHorizontalDragUpdate: _move,
                  onHorizontalDragEnd: _settle,
                  behavior: HitTestBehavior.translucent,
                  excludeFromSemantics: true,
                  // dragStartBehavior: DragStartBehavior.start,
                  child: Container(
                      // decoration: BoxDecoration(
                      //   gradient: LinearGradient(
                      //     colors: [
                      //       const Color(0xFFFFBBBB),
                      //       const Color(0xFFFFBBBB)
                      //     ],
                      //   ),
                      // ),
                      width: 20.sp),
                ),
            ],
          ),
          drawerEdgeDragWidth: 100.w,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: ImageIcon(AssetImage("assets/images/life/vector.png")),
              color: Theme.of(context).textTheme.headline1!.color,
              tooltip: 'Navigation',
              onPressed: () => ZoomDrawer.of(context)?.toggle.call(),
            ),
            actions: [
              RotationTransition(
                  //设置动画的旋转中心
                  alignment: Alignment.center,
                  //动画控制器
                  turns: _animation,
                  child: IconButton(
                      onPressed: () {
                        debugPrint('Navigation button is pressed.');
                        if (isStartTrain == false) {
                          _animationController.forward();
                          _assetsAudioPlayer?.play();
                        } else {
                          _animationController.stop();
                          _assetsAudioPlayer?.pause();
                        }
                        setState(() {
                          isStartTrain = !isStartTrain;
                        });
                      },
                      color: Theme.of(context).textTheme.headline1!.color,
                      icon: ImageIcon(
                          AssetImage("assets/images/life/music.png")))),
            ],
          )),
    );
  }
}
