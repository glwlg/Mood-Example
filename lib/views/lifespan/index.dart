import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moodexample/models/lifespan/lifespan_model.dart';
import 'package:moodexample/services/lifespan/lifespan_service.dart';
import 'package:moodexample/view_models/lifespan/lifespan_view_model.dart';
import 'package:provider/provider.dart';

///
import 'package:moodexample/themes/app_theme.dart';
import 'package:moodexample/generated/l10n.dart';
import 'package:moodexample/common/utils.dart';

/// 心情页（记录列表）
class LifespanPage extends StatefulWidget {
  const LifespanPage({Key? key}) : super(key: key);

  @override
  State<LifespanPage> createState() => _LifespanState();
}

class _LifespanState extends State<LifespanPage>
    with AutomaticKeepAliveClientMixin {
  /// AutomaticKeepAliveClientMixin
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    init(context);
  }

  @override
  Widget build(BuildContext context) {
    /// AutomaticKeepAliveClientMixin
    super.build(context);
    // 屏幕自适应 设置尺寸（填写设计中设备的屏幕尺寸）如果设计基于360dp * 690dp的屏幕
    ScreenUtil.init(
      context,
      designSize: Size(AppTheme.wdp, AppTheme.hdp),
    );
    return Container(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // backgroundColor: Colors.transparent,
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      child: const SafeArea(
        child: LifespanBody(key: Key("widget_lifespan_body")),
      ),
    );
  }
}

/// 初始化
init(BuildContext context) {
  LifespanViewModel lifespanViewModel =
      Provider.of<LifespanViewModel>(context, listen: false);

  /// 获取数据
  LifespanService.getLifespanData(lifespanViewModel);
}

/// 主体
class LifespanBody extends StatefulWidget {
  const LifespanBody({Key? key}) : super(key: key);

  @override
  State<LifespanBody> createState() => _LifespanBodyState();
}

class _LifespanBodyState extends State<LifespanBody> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      primary: false,
      shrinkWrap: false,
      slivers: [
        SliverAppBar(
          pinned: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Align(
            child: Container(
              margin: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              ),
            ),
          ),
          collapsedHeight: 100.w,
          expandedHeight: 100.w,
        ),

        /// 下拉加载
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            vibrate();
            init(context);
          },
        ),

        /// 数据
        Consumer<LifespanViewModel>(
          builder: (_, lifespanViewModel, child) {
            /// 加载数据的占位
            if (lifespanViewModel.lifespanDataLoading) {
              return SliverFixedExtentList(
                itemExtent: 280.w,
                delegate: SliverChildBuilderDelegate(
                  (builder, index) {
                    return Align(
                      child: CupertinoActivityIndicator(radius: 12.sp),
                    );
                  },
                  childCount: 1,
                ),
              );
            }

            LifespanData? lifespanData = lifespanViewModel.lifespanData;

            /// 有内容显示
            return SliverToBoxAdapter(
              child: LifespanCard(
                key: Key("widget_lifespan_body"),
                id: lifespanData?.id ?? -1,
                birthDay: lifespanData?.birthDay ?? '',
                life: lifespanData?.life ?? 0,
                createTime:
                    lifespanData?.createTime.toString().substring(0, 10) ?? '',
              ),
            );
          },
        ),

        /// 占位高度
        // SliverToBoxAdapter(child: SizedBox(height: 64.w)),
      ],
    );
  }
}

/// 寿命卡片
class LifespanCard extends StatefulWidget {
  /// id
  final int id;

  /// 标题
  final String birthDay;

  /// 分数
  final int life;

  /// 创建日期
  final String createTime;

  const LifespanCard({
    Key? key,
    required this.id,
    required this.birthDay,
    required this.life,
    required this.createTime,
  }) : super(key: key);

  @override
  State<LifespanCard> createState() => _LifespanCardState();
}

class _LifespanCardState extends State<LifespanCard> {
  String _livedDay() {
    int difference =
        DateTime.now().difference(DateTime.parse(widget.birthDay)).inMinutes;
    double dayDifference = difference / 60 / 24;
    return "${dayDifference.toStringAsFixed(0)}";
  }

  String _livedHours() {
    int difference =
        DateTime.now().difference(DateTime.parse(widget.birthDay)).inHours;
    return "${difference.toStringAsFixed(0)}";
  }

  String _livedMinutes() {
    int difference =
        DateTime.now().difference(DateTime.parse(widget.birthDay)).inMinutes;
    return "${difference.toStringAsFixed(0)}";
  }

  String _livedWeek() {
    int difference =
        DateTime.now().difference(DateTime.parse(widget.birthDay)).inMinutes;
    double weekDifference = difference / 60 / 24 / 7;
    return "${weekDifference.toStringAsFixed(0)}";
  }

  String _livedMonth() {
    var month = getAge(DateTime.parse(widget.birthDay)) * 12;

    return "${month.toStringAsFixed(0)}";
  }

  String _livedYear() {
    var age = getAge(DateTime.parse(widget.birthDay));
    return "${age.toStringAsFixed(2)}";
  }

  static num getAge(DateTime brt) {
    int age = 0;
    DateTime dateTime = DateTime.now();
    if (dateTime.isBefore(brt)) {
      //出生日期晚于当前时间，无法计算
      return 0;
    }
    int yearNow = dateTime.year; //当前年份
    int monthNow = dateTime.month; //当前月份

    int yearBirth = brt.year;
    int monthBirth = brt.month;
    age = yearNow - yearBirth; //计算整岁数

    double tureAge = age + ((monthNow - monthBirth) / 12);

    return tureAge;
  }

  String _dieDay() {
    DateTime birthDay = DateTime.parse(widget.birthDay);
    DateTime dieDay = DateTime(birthDay.year + widget.life);

    return "${getDateStringCN(dieDay)} 死去";
  }

  String _leftDay() {
    DateTime birthDay = DateTime.parse(widget.birthDay);
    DateTime dieDay = DateTime(birthDay.year + widget.life);
    int difference = dieDay.difference(DateTime.now()).inDays;

    return "$difference天";
  }

  String _livedDayPercent() {
    int livedDay =
        DateTime.now().difference(DateTime.parse(widget.birthDay)).inDays;
    int allDay = widget.life * 365;

    double livedDayPercent = livedDay / allDay * 100;
    return "${livedDayPercent.toStringAsFixed(2)}%";
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: widget.key,
      child: Container(
        margin: EdgeInsets.only(left: 0.w, right: 0.w, top: 0.w, bottom: 0.w),
        child: GestureDetector(
          child: ConstrainedBox(
              constraints: const BoxConstraints(
                  // minHeight: 10.w,
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "你 ",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _livedYear(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 38.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " 岁了",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 40.w, left: 10.w, right: 10.w),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            // backgroundColor: Colors.transparent,
                            Theme.of(context).cardColor,
                            Theme.of(context).cardColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18.w),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10.w, bottom: 20.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "在这个世界上，你已经经历了",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .color,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.w, bottom: 1.w),
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            _livedYear(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "年",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .color,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 20.w, bottom: 1.w),
                                            child: Text(
                                              _livedDay(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "天",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .color,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            _livedMonth(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "月",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .color,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 20.w, bottom: 1.w),
                                            child: Text(
                                              _livedHours(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "小时",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .color,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            _livedWeek(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "周",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .color,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 20.w, bottom: 1.w),
                                            child: Text(
                                              _livedMinutes(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "分钟",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .color,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
