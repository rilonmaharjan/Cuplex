import 'package:cuplex/controller/search_movie_controller.dart';
import 'package:cuplex/controller/search_series_controller.dart';
import 'package:cuplex/views/search/search_movie.dart';
import 'package:cuplex/views/search/search_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  final int? tabIndex;
  const SearchPage({super.key, this.tabIndex});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin{
  final SearchMovieController searchCon = Get.put(SearchMovieController());
  final SearchSeriesController searchSeriesCon = Get.put(SearchSeriesController());
  final TextEditingController _searchController = TextEditingController();
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: widget.tabIndex ?? 0, vsync: this); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.black,
      appBar: customAppBar(),
      body: SafeArea(
        top: true,
        bottom: false,
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
                          color:const Color.fromARGB(255, 219, 219, 219),
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
                          color:const Color.fromARGB(255, 219, 219, 219),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    SearchMoviePage(),
                    SearchSeriesPage(),
                  ],
                ),
              ),
            ],
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
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: SizedBox(
                    width: 30.w,
                    child: const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 219, 219, 219),),
                  ),
                ),
                SizedBox(
                  height: 36.h,
                  width: 280.0.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: TextFormField(
                      controller: _searchController,
                      autofocus: true,
                      onFieldSubmitted: (value) async{
                        if(_searchController.text != ""){
                          await searchCon.searchMovie(_searchController.text);
                          setState(() {
                            searchCon.searchKeyword = _searchController.text;
                          });
                          await searchSeriesCon.searchSeries(_searchController.text);
                          setState(() {
                            searchSeriesCon.searchKeyword = _searchController.text;
                          });
                        }
                      },
                      cursorRadius: const Radius.circular(6),
                      cursorHeight: 20.sp,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: EdgeInsets.only(top: 6.0.sp, left: 15.0.sp, right: 10.sp),
                        fillColor: const Color.fromARGB(255, 221, 221, 221),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(fontSize: 14.sp, color: const Color.fromARGB(255, 20, 20, 20),
                          fontWeight: FontWeight.w300, 
                          letterSpacing: 1,
                          height: 1.6,
                        ),
                        prefixIconConstraints: BoxConstraints(
                          maxWidth: 52.0.w,
                          minWidth: 52.0.w
                        ),
                        prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 110, 108, 110)),
                        suffixIconConstraints: BoxConstraints(
                          maxWidth: 52.0.w,
                          minWidth: 52.0.w
                        ),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            _searchController.clear();
                          },
                          child: Icon(Icons.clear_rounded, size: 20.sp, color: const Color.fromARGB(255, 110, 108, 110))
                        )
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

