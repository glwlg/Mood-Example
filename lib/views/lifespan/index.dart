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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: const SafeArea(
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
                children: [
                  Flexible(
                    child: Text(
                      S.of(context).lifespan_title,
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                          ),
                      semanticsLabel:
                          S.of(context).app_bottomNavigationBar_title_lifespan,
                    ),
                  ),
                  Image.asset(
                    "assets/images/woolly/woolly-heart.png",
                    height: 60.w,
                    excludeFromSemantics: true,
                  ),
                ],
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
                key: Key("widget_lifespan_body_calendar"),
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
        SliverToBoxAdapter(child: SizedBox(height: 64.w)),
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
  String livedDay() {
    int difference =
        DateTime.now().difference(DateTime.parse(widget.birthDay)).inMinutes;
    double yearDifference = difference / 60 / 24;
    return "${yearDifference.toStringAsFixed(2)}天";
  }

  String dieDay() {
    DateTime birthDay = DateTime.parse(widget.birthDay);
    DateTime dieDay = DateTime(birthDay.year + widget.life);

    return "${getDateStringCN(dieDay)} 死去";
  }

  String leftDay() {
    DateTime birthDay = DateTime.parse(widget.birthDay);
    DateTime dieDay = DateTime(birthDay.year + widget.life);
    int difference = dieDay.difference(DateTime.now()).inDays;

    return "$difference天";
  }

  String livedDayPercent() {
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
        margin:
            EdgeInsets.only(left: 24.w, right: 24.w, top: 0.w, bottom: 12.w),
        child: GestureDetector(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 420.w,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).cardColor,
                    Theme.of(context).cardColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(18.w),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 请输入您的出生日期
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            bottom: 10.w,
                          ),
                          child: Text(
                            "请选择您的出生日期",
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 20.w,
                                bottom: 15.w,
                              ),
                                child: TextField(
                                  controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                          text: widget.birthDay)),
                                  readOnly: true,

                                    // overflow: TextOverflow.ellipsis,
                                  // softWrap: true,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                    fontSize: 16.sp,
                                  ),
                                    onTap: () async {
                                      DateTime? selectedDay = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.parse(widget.birthDay),
                                        firstDate: DateTime(1900, 1, 1),
                                        lastDate: DateTime.now(),
                                      );
                                      if (selectedDay != null) {
                                        LifespanViewModel lifespanViewModel =
                                        Provider.of<LifespanViewModel>(context,
                                            listen: false);

                                        String selected =
                                        selectedDay.toString().substring(0, 10);

                                        /// 之前选择的日期
                                        String oldSelectedDay = lifespanViewModel
                                            .lifespanData!.birthDay;
                                        //
                                        /// 选择的日期相同则不操作
                                        if (oldSelectedDay == selected) {
                                          return;
                                        }
                                        lifespanViewModel.setBirthday(selectedDay);
                                        lifespanViewModel
                                            .setLifespanDataLoading(true);
                                        //
                                        LifespanService.editLifespan(
                                            lifespanViewModel.lifespanData!);
                                        LifespanService.getLifespanData(
                                            lifespanViewModel);
                                      }
                                    }
                                ),
                                )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 预计可以活到的年龄
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            bottom: 5.w,
                          ),
                          child: Text(
                            "预计可以活到的年龄",
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(
                                  left: 20.w,
                                  bottom: 15.w,
                                ),
                                child: TextField(
                                    controller: TextEditingController.fromValue(
                                        TextEditingValue(
                                            text: widget.life.toString())),
                                    keyboardType: TextInputType.number,
                                    //限定数字键盘
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9]"))
                                    ],
                                    //限定数字输入
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontSize: 16.sp,
                                    ),
                                    minLines: 1,
                                    // maxLength: 3,
                                    onSubmitted: (value) async {
                                      debugPrint("年龄变更");

                                      if (value == "") {
                                        return;
                                      }

                                      LifespanViewModel lifespanViewModel =
                                          Provider.of<LifespanViewModel>(
                                              context,
                                              listen: false);

                                      int newLife = int.parse(value);

                                      int oldLife =
                                          lifespanViewModel.lifespanData!.life;

                                      if (oldLife == newLife) {
                                        return;
                                      }
                                      lifespanViewModel.setLife(newLife);
                                      lifespanViewModel
                                          .setLifespanDataLoading(true);
                                      //
                                      LifespanService.editLifespan(
                                          lifespanViewModel.lifespanData!);
                                      LifespanService.getLifespanData(
                                          lifespanViewModel);
                                    })))
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 您已经在这世上过了
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            bottom: 5.w,
                          ),
                          child: Text(
                            "您已经在这世上过了",
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 标题
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            bottom: 15.w,
                          ),
                          child: Text(
                            livedDay(),
                            maxLines: 5,
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
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 标题
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            bottom: 5.w,
                          ),
                          child: Text(
                            "按照您的预期您可能会在",
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 标题
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            bottom: 15.w,
                          ),
                          child: Text(
                            dieDay(),
                            maxLines: 5,
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
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 标题
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            bottom: 5.w,
                          ),
                          child: Text(
                            "还剩下",
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 标题
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            bottom: 15.w,
                          ),
                          child: Text(
                            leftDay(),
                            maxLines: 5,
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
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 标题
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            bottom: 5.w,
                          ),
                          child: Text(
                            "粗略的估计大概已经活了",
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 标题
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            bottom: 15.w,
                          ),
                          child: Text(
                            livedDayPercent(),
                            maxLines: 5,
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
