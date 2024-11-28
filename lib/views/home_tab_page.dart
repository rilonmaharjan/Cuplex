import 'package:cuplex/views/movies/movies_list.dart';
import 'package:cuplex/views/series/series_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this); 
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: customAppBar(),
        body: SafeArea(
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              children: [
                Container(
                  height: 50.0.h,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.5.w
                      )
                    )
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.red,
                    labelColor: Colors.white,
                    indicatorWeight: 2,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 40.sp),
                    labelStyle: const TextStyle(fontSize: 16),
                    unselectedLabelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                    isScrollable: false,
                    physics: const NeverScrollableScrollPhysics(),
                    tabs: const [
                      Tab(
                        child: Text(
                          'Movies',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Series', 
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
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
  
  customAppBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 65.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 26.h,),
          Container(
            padding: EdgeInsets.only(top : 18.sp, bottom : 0, left : 18.sp),
            child: Row(
              children: [
                SizedBox(width: 30.w),
                SizedBox(
                  height: 36.h,
                  width: 280.0.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: TextFormField( 
                      onTap: () {
                        // Get.to(() => const Settings(), transition: Transition.downToUp, duration: const Duration(milliseconds: 350));
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: EdgeInsets.only(top: 6.0.sp, left: 15.0.sp, right: 10.sp),
                        fillColor: const Color.fromARGB(255, 221, 221, 221),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: 'Search',
                        hintStyle:  const TextStyle(fontSize: 14, color: Color.fromARGB(255, 110, 108, 110)),
                        prefixIconConstraints: BoxConstraints(
                          maxWidth: 62.0.w,
                          minWidth: 52.0.w
                        ),
                        prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 110, 108, 110))
                      ),
                    ),
                  ),
                ),                
                SizedBox(width: 30.w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}