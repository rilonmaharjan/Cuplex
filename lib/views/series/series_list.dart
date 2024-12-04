import 'package:cuplex/controller/series_controller.dart';
import 'package:cuplex/views/series/series_detail.dart';
import 'package:cuplex/views/series/view_all_series.dart';
import 'package:cuplex/widget/custom_shimmer.dart';
import 'package:cuplex/widget/tile/movies_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SeriesListPage extends StatefulWidget {
  const SeriesListPage({super.key});

  @override
  State<SeriesListPage> createState() => _SeriesListPageState();
}

class _SeriesListPageState extends State<SeriesListPage> {
  final SeriesController seriesCon = Get.put(SeriesController());
  ScrollController paginationScrollController = ScrollController();
  bool showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    paginationScrollController.addListener(_scrollListener);
    initialise();
  }

  initialise() async{
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await seriesCon.getTrendingSeriesList();
      await seriesCon.getTopRatedSeries();
      await seriesCon.getSeriesList();
    });
  }

  void _scrollListener() {
    // Check if the user is near the top of the list
    if (paginationScrollController.position.pixels <= 2500 && showScrollToTopButton) {
      setState(() {
        showScrollToTopButton = false;
      });
    } 
    // Check if the user is scrolling down past a certain threshold
    else if (paginationScrollController.position.pixels > 2500 && !showScrollToTopButton) {
      setState(() {
        showScrollToTopButton = true;
      });
    }
    if (paginationScrollController.position.pixels ==
        paginationScrollController.position.maxScrollExtent) {
      // When the user reaches the end of the list
        if(seriesCon.prevPageNum == seriesCon.pageNum){
          _loadMorePosts();
        }
    }
  }

  Future<void> _loadMorePosts() async {
    seriesCon.pageNum = seriesCon.pageNum + 1;
    await seriesCon.getPagination();
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
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1),()async{
            await seriesCon.getTrendingSeriesList();
            await seriesCon.getTopRatedSeries();
            await seriesCon.getSeriesList();
            setState(() {
              seriesCon.pageNum = 1;
              seriesCon.prevPageNum = 1;
            });
          });
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: paginationScrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 480.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: .45,
                      child: Center(
                        child: Image.asset(
                          "assets/images/arcane.jpg",
                          width: double.infinity,
                          height: 480.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 480.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(.85),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: const Color.fromARGB(255, 224, 224, 224),
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1,
                              height: 1.5,
                            ),
                            children: const [
                              TextSpan(text: "Watch "),
                              TextSpan(
                                text: "Free",
                                style: TextStyle(color: Color(0xffecc877)),
                              ),
                              TextSpan(text: " HD Movies &\nTV shows"),
                            ],
                          ),
                        ),
                        SizedBox(height: 26.h),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: const Color.fromARGB(255, 219, 219, 219),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1,
                              height: 1.6,
                            ),
                            children: const [
                              TextSpan(text: "Enjoy your "),
                              TextSpan(
                                text: "unlimited",
                                style: TextStyle(color: Color(0xffecc877)),
                              ),
                              TextSpan(
                                  text: " Movies & TV show collection.\nWe are the definitive source for the best\n curated 720p / 1080p HD Movies & TV shows,\nviewable by mobile phone and tablet, for "),
                              TextSpan(
                                text: "free",
                                style: TextStyle(color: Color(0xffecc877)),
                              ),
                              TextSpan(text: "."),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.h,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //trendinglist
                    trendingSeriesList(),
                    SizedBox(height: 16.h),
                    //topRatedseries
                    topRatedSeriesList(),
                    SizedBox(height: 16.h,),
                    //all series list
                    allSeriesList(),
                    //pagination
                    Obx(() => 
                      seriesCon.isPageLoading.isTrue
                      ? Column(
                          children: [
                            SizedBox(
                              height: 100.h,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xffecc877),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //trending Series
  trendingSeriesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h,),
        Row(
          children: [
            const Text(
              "Trending Series",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Obx(() =>
              Visibility(
                visible: seriesCon.trendingSeriesList.isNotEmpty,
                child: InkWell(
                  onTap: (){
                    Get.to(() => ViewAllSeries(title: "Trending Series", seriesList: seriesCon.trendingSeriesList,));
                  },
                  child: Container(
                    height: 24.h,
                    width: 46.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5.sp,
                      ),
                      color: Colors.black
                    ),
                    child: Center(
                      child: Text(
                        "ALL", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w300) ,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 170.h,
          child: Obx(() => seriesCon.isTrendingSeriesLoading.isTrue
            ? ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context,index){
                return Padding(
                  padding: EdgeInsets.only(right: 8.sp),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CustomShimmer(
                      height: 170.h,
                      width: 114.w,
                    ),
                  ),
                );
              }
            )
            : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: seriesCon.trendingSeriesList.length,
              itemBuilder: (context,index){
                return Container(
                  height: 170.h,
                  width: 122.w,
                  padding: EdgeInsets.only(right: 8.sp),
                  child: MovieCard(
                    title: seriesCon.trendingSeriesList[index]["name"] ?? "",
                    year: seriesCon.trendingSeriesList[index]["first_air_date"].split("-")[0],
                    rating: seriesCon.trendingSeriesList[index]["vote_average"] == null ? 0 : double.parse(seriesCon.trendingSeriesList[index]["vote_average"].toStringAsFixed(1)),
                    image: seriesCon.trendingSeriesList[index]["poster_path"] ?? "",
                    onTap: (){
                      Get.to(() => SeriesDetailPage(id: seriesCon.trendingSeriesList[index]["id"],));
                    },
                  ),
                );
              }
            )
          ),
        ),
      ],
    );
  }
  
  //topRated Series 
  topRatedSeriesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Top Rated Series",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Obx(() =>
              Visibility(
                visible: seriesCon.topRatedSeries.isNotEmpty,
                child: InkWell(
                  onTap: (){
                    Get.to(() => ViewAllSeries(title: "Top Rated Series", seriesList: seriesCon.topRatedSeries,));
                  },
                  child: Container(
                    height: 24.h,
                    width: 46.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5.sp,
                      ),
                      color: Colors.black
                    ),
                    child: Center(
                      child: Text(
                        "ALL", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w300) ,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 10.h,),
        SizedBox(
          height: 170.h,
          child: Obx(() => seriesCon.isTopRatedSeriesLoading.isTrue
            ? ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context,index){
                return Padding(
                  padding: EdgeInsets.only(right: 8.sp),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CustomShimmer(
                      height: 170.h,
                      width: 114.w,
                    ),
                  ),
                );
              }
            )
            : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: seriesCon.topRatedSeries.length,
              itemBuilder: (context,index){
                return Container(
                  height: 170.h,
                  width: 122.w,
                  padding: EdgeInsets.only(right: 8.sp),
                  child: MovieCard(
                    title: seriesCon.topRatedSeries[index].name ?? "",
                    year: seriesCon.topRatedSeries[index].firstAirDate.split("-")[0],
                    rating: seriesCon.topRatedSeries[index].voteAverage == null ? 0 : double.parse(seriesCon.topRatedSeries[index].voteAverage.toStringAsFixed(1)),
                    image: seriesCon.topRatedSeries[index].posterPath ?? "",
                    onTap: (){
                      Get.to(() => SeriesDetailPage(id: seriesCon.topRatedSeries[index].id,));
                    },
                  ),
                );
              }
            )
          ),
        ),
      ],
    );
  }
  
  //all Series list
  allSeriesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "All Series",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.h),
        //Serieslist
        Obx(() => seriesCon.isLoading.isTrue
          ? GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CustomShimmer(
                    height: 150.h,
                    width: 120.w,
                  ),
                );
              }
            )
          :  GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: seriesCon.seriesList.length,
            itemBuilder: (context, index) {
              return MovieCard(
                title: seriesCon.seriesList[index]["name"] ?? "",
                year: seriesCon.seriesList[index]["first_air_date"].split("-")[0],
                rating: seriesCon.seriesList[index]["vote_average"] == null ? 0 : double.parse(seriesCon.seriesList[index]["vote_average"].toStringAsFixed(1)),
                image: seriesCon.seriesList[index]["poster_path"] ?? "",
                onTap: (){
                  Get.to(() => SeriesDetailPage(id: seriesCon.seriesList[index]["id"],));
                },
              );
            },
          ),
        ),
      ],
    );
  }

}
