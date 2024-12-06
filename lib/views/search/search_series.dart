import 'package:cuplex/controller/search_series_controller.dart';
import 'package:cuplex/views/series/series_detail.dart';
import 'package:cuplex/widget/tile/media_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchSeriesPage extends StatefulWidget {
  const SearchSeriesPage({super.key});

  @override
  State<SearchSeriesPage> createState() => _SearchSeriesPageState();
}

class _SearchSeriesPageState extends State<SearchSeriesPage> {
  final SearchSeriesController searchCon = Get.put(SearchSeriesController());
    ScrollController paginationScrollController = ScrollController();
  bool showScrollToTopButton = false;


  @override
  void initState() {
    super.initState();
    paginationScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Check if the user is near the top of the list
    if (paginationScrollController.position.pixels <= 1500 && showScrollToTopButton) {
      setState(() {
        showScrollToTopButton = false;
      });
    } 
    // Check if the user is scrolling down past a certain threshold
    else if (paginationScrollController.position.pixels > 1500 && !showScrollToTopButton) {
      setState(() {
        showScrollToTopButton = true;
      });
    }

    // Load more content when reaching the bottom
    if (paginationScrollController.position.pixels ==
        paginationScrollController.position.maxScrollExtent) {
      if (searchCon.prevPageNum == searchCon.pageNum) {
        _loadMorePosts();
      }
    }
  }

  Future<void> _loadMorePosts() async {
    searchCon.pageNum = searchCon.pageNum + 1;
    await searchCon.getSearchSeriesPagination();
    setState(() { });
  }   

  @override
  void dispose() {
    paginationScrollController.removeListener(_scrollListener);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Visibility(
        visible: showScrollToTopButton,
        child: FloatingActionButton(
          backgroundColor: const Color(0xffecc877),
          onPressed: () {
            paginationScrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
            );
          },
          child: const Icon(Icons.arrow_upward_outlined, color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: const Color(0xffecc877),
        color: Colors.black,
        onRefresh: (){
          return Future.delayed(const Duration(seconds: 1),()async{
            searchCon.searchSeries(searchCon.searchKeyword);
          });
        },
        child: SingleChildScrollView(
          controller: paginationScrollController,
          physics: const BouncingScrollPhysics(),
          child: Obx(() => searchCon.isSearchListLoading.isTrue
            ? Padding(
              padding: EdgeInsets.fromLTRB(8.0.sp,16.sp,8.sp,8.sp),
              child: GridView.builder(
                  physics:  const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                            width: 0.5,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.withOpacity(.3),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        height: 150.h,
                        width: 120.w,
                      ),
                    );
                  }
                ),
            )
            : searchCon.hasSearched.isFalse
            ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.withOpacity(.4),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              height: 400,
              child: const Center(
                child: Text(
                  "Enter Keywords...", 
                  style: TextStyle(
                    fontWeight: FontWeight.w300, 
                    letterSpacing: 1,
                    height: 1.6,
                    color:Color.fromARGB(255, 219, 219, 219),
                  ),
                )
              ),
            )
            : searchCon.seriesSearchList.isEmpty
            ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.withOpacity(.4),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              height: 400,
              child: const Center(
                child: Text("No Results Found", style: TextStyle(
                    fontWeight: FontWeight.w300, 
                    letterSpacing: 1,
                    height: 1.6,
                    color:Color.fromARGB(255, 219, 219, 219),
                  ),
                )
              ),
            )
            :  Padding(
              padding: EdgeInsets.fromLTRB(8.0.sp,16.sp,8.sp,8.sp),
              child: Column(
                children: [
                  GridView.builder(
                    physics:  const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: searchCon.seriesSearchList.length,
                    itemBuilder: (context, index) {
                      return MediaCardTile(
                        title: searchCon.seriesSearchList[index]["name"] ?? "",
                        year: (searchCon.seriesSearchList[index]['first_air_date'] ?? '').split('-').first,
                        rating: searchCon.seriesSearchList[index]["vote_average"] == null ? 0.0 :  double.parse(searchCon.seriesSearchList[index]["vote_average"].toStringAsFixed(1)),
                        image: searchCon.seriesSearchList[index]["poster_path"] ?? "",
                        onTap: () {
                          Get.to(() => SeriesDetailPage(id: searchCon.seriesSearchList[index]["id"]));
                        },
                      );
                    },
                  ),
                  //pagination
                  searchCon.seriesSearchList.length <= 14
                  ? const SizedBox()
                  : Obx(() => 
                    searchCon.isPageLoading.isTrue
                    ?  Column(
                        children: [
                          SizedBox(
                            height: 100.h,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xffecc877),
                              )
                            ),
                          ),
                        ],
                      )
                    :  const SizedBox(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}