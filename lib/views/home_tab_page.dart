import 'package:cuplex/controller/movies_controller.dart';
import 'package:cuplex/controller/series_controller.dart';
import 'package:cuplex/views/movies/movies_list.dart';
import 'package:cuplex/views/series/series_list.dart';
import 'package:cuplex/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  final MoviesController movieCon = Get.put(MoviesController());
  final SeriesController seriesCon = Get.put(SeriesController());
  late final TabController _tabController;
  int? tabIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    initialise();
  }

  initialise() async{
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await movieCon.getTrendingMoviesList();
      await movieCon.getTopRatedMovies();
      await movieCon.getMoviesList();
      await seriesCon.getTrendingSeriesList();
      await seriesCon.getTopRatedSeries();
      await seriesCon.getSeriesList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: customAppBar(tabIndex: tabIndex),
        body: SafeArea(
          top: true,
          bottom: false,
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              children: [
                Obx(() => 
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: movieCon.isScrollUp.isFalse ? 40.0.h : 0.0.h,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 0.3.w
                        )
                      )
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: const Color(0xffecc877),
                      labelColor: Colors.white,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 40.sp),
                      labelStyle: const TextStyle(fontSize: 16),
                      unselectedLabelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                      isScrollable: false,
                      physics: const NeverScrollableScrollPhysics(),
                      tabs: [
                        Tab(
                          child: Text(
                            'Movies',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w300, 
                              letterSpacing: 1,
                              height: 1.6,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Series', 
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w300, 
                              letterSpacing: 1,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                      onTap: (val){
                        setState(() {
                          tabIndex = val;
                        });
                      },
                    ),
                  )
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: const [
                      MoviesListPage(),
                      SeriesListPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}