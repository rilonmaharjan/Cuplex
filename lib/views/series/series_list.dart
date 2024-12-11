import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/controller/movies_controller.dart';
import 'package:cuplex/controller/series_controller.dart';
import 'package:cuplex/views/series/series_detail.dart';
import 'package:cuplex/views/series/view_all_series.dart';
import 'package:cuplex/widget/custom_cached_network.dart';
import 'package:cuplex/widget/tile/media_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SeriesListPage extends StatefulWidget {
  const SeriesListPage({super.key});

  @override
  State<SeriesListPage> createState() => _SeriesListPageState();
}

class _SeriesListPageState extends State<SeriesListPage> {
  final SeriesController seriesCon = Get.put(SeriesController());
  final MoviesController movieCon = Get.put(MoviesController());
  ScrollController paginationScrollController = ScrollController();
  bool showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    paginationScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (paginationScrollController.position.userScrollDirection == ScrollDirection.forward) {
      // Scrolling down
      movieCon.isScrollUp.value = false;
    } else if (paginationScrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // Scrolling up
      movieCon.isScrollUp.value = true;
    }
    
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
              carousel(),
              SizedBox(height: 10.h,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //trendinglist
                    trendingSeriesList(),
                    SizedBox(height: 16.h,),
                    //topRatedseries
                    topRatedSeriesList(),
                    SizedBox(height: 16.h),
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
                                )
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

  //trending carousel
  carousel() {
    return Container(
      height: 475.0.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(.3),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Obx(() => seriesCon.isTrendingSeriesLoading.isTrue
        ? CarouselSlider.builder(
          initialPage: 0,
          unlimitedMode: true,
          autoSliderDelay: const Duration(seconds: 12),
          autoSliderTransitionTime: const Duration(milliseconds: 1500),
          enableAutoSlider: true,
          itemCount: 10,
          scrollPhysics: const BouncingScrollPhysics(),
          slideIndicator: CircularSlideIndicator(
            itemSpacing: 13.sp,
            indicatorRadius: 4.r,
            indicatorBackgroundColor: const Color.fromARGB(255, 151, 151, 151),
            padding: EdgeInsets.only(bottom: 40.0.h),
            indicatorBorderColor: Colors.transparent,
            currentIndicatorColor: const Color(0xffecc877),
          ),
          slideBuilder: (int carouselIndex) {
            return SizedBox(
              height: 480.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.withOpacity(.3),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    width: double.infinity,
                    height: 475.0.h,
                  ),
                ],
              ),
            );
          }
        )
        : CarouselSlider.builder(
          initialPage: 0,
          unlimitedMode: true,
          autoSliderDelay: const Duration(seconds: 12),
          autoSliderTransitionTime: const Duration(milliseconds: 2500),
          enableAutoSlider: true,
          itemCount:  seriesCon.trendingSeriesList.length > 10 ? 10 : seriesCon.trendingSeriesList.length,
          scrollPhysics: const BouncingScrollPhysics(),
          slideIndicator: CircularSlideIndicator(
            itemSpacing: 13.sp,
            indicatorRadius: 4.r,
            indicatorBackgroundColor: const Color.fromARGB(255, 151, 151, 151),
            padding: EdgeInsets.only(bottom: 40.0.h),
            indicatorBorderColor: Colors.transparent,
            currentIndicatorColor: const Color(0xffecc877),
          ),
          slideBuilder: (int carouselIndex) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: .65,
                  child: Center(
                    child: DisplayNetworkImage(
                      imageUrl: "$posterUrl${seriesCon.trendingSeriesList[carouselIndex]["poster_path"]}",
                      width: double.infinity,
                      height: 475.h,
                      fit: BoxFit.cover,
                      isFromCarousel : true,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 475.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 78.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                          seriesCon.trendingSeriesList[carouselIndex]["name"] ?? "",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 219, 219, 219),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w300, 
                            letterSpacing: 1,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: const Color.fromARGB(255, 219, 219, 219),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w300, 
                              letterSpacing: 1,
                              height: 1.6,
                            ),
                            children: [
                              const TextSpan(text: "Rating  •  "),
                              TextSpan(
                                text: seriesCon.trendingSeriesList[carouselIndex]["vote_average"] != null &&
                                        seriesCon.trendingSeriesList[carouselIndex]["vote_average"] != ""
                                    ? double.parse(seriesCon.trendingSeriesList[carouselIndex]["vote_average"]
                                            .toStringAsFixed(1))
                                        .toString()
                                    : "",
                                style: const TextStyle(color: Color(0xffecc877)), // Yellow color for vote_average
                              ),
                              const TextSpan(text: "  •  "),
                              TextSpan(
                                text: seriesCon.trendingSeriesList[carouselIndex]["first_air_date"] != null &&
                                        seriesCon.trendingSeriesList[carouselIndex]["first_air_date"] != ""
                                    ? seriesCon.trendingSeriesList[carouselIndex]["first_air_date"].split("-")[0]
                                    : "",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: 280.w,
                          child: Text(
                            seriesCon.trendingSeriesList[carouselIndex]["overview"],
                            style: TextStyle(
                              color: const Color.fromARGB(255, 219, 219, 219),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300, 
                              letterSpacing: 1,
                              height: 1.6,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => SeriesDetailPage(id: seriesCon.trendingSeriesList[carouselIndex]["id"],));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffecc877).withOpacity(.9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 55.w),
                          ),
                          child: Text(
                            "WATCH",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w300, 
                              letterSpacing: 1,
                              height: 1.6,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "FREE | UNLIMITED | CUPLEX",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 219, 219, 219),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w300, 
                            letterSpacing: 1,
                            height: 1.6,
                          ),
                        ),
                    ],
                  ),
                )
              ],
            );
          }
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
            Text(
              "Trending Series",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w300, 
                letterSpacing: 1,
                height: 1.6,
                color: const Color.fromARGB(255, 219, 219, 219),
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
                        "ALL", style: TextStyle(
                        color: Colors.white.withOpacity(0.8), 
                        fontSize: 12.sp, 
                          fontWeight: FontWeight.w300, 
                          letterSpacing: 1,
                          height: 1.6,
                        ) ,
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
                        borderRadius: BorderRadius.circular(6),
                      ),
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
                final reversedList = seriesCon.trendingSeriesList.reversed.toList();
                return Container(
                  height: 170.h,
                  width: 122.w,
                  padding: EdgeInsets.only(right: 8.sp),
                  child: MediaCardTile(
                    title: reversedList[index]["name"] ?? "",
                    year: reversedList[index]["first_air_date"] != null &&
                              reversedList[index]["first_air_date"] != ""
                          ? reversedList[index]["first_air_date"].split("-")[0]
                          : "",
                    rating: reversedList[index]["vote_average"] == null ? 0.0 : double.parse(reversedList[index]["vote_average"].toStringAsFixed(1)),
                    image: reversedList[index]["poster_path"] ?? "",
                    onTap: (){
                      Get.to(() => SeriesDetailPage(id: reversedList[index]["id"],));
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
            Text(
              "Top Rated Series",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w300, 
                letterSpacing: 1,
                height: 1.6,
                color: const Color.fromARGB(255, 219, 219, 219),
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
                        "ALL", style: TextStyle(
                          fontSize: 12.sp, 
                          color: Colors.white.withOpacity(0.8), 
                          fontWeight: FontWeight.w300, 
                          letterSpacing: 1,
                          height: 1.6,
                        ) ,
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
                        borderRadius: BorderRadius.circular(6),
                      ),
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
                  child: MediaCardTile(
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
        Text(
          "All Series",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w300, 
            letterSpacing: 1,
            height: 1.6,
            color: const Color.fromARGB(255, 219, 219, 219),
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
                      borderRadius: BorderRadius.circular(6),
                    ),
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
              return MediaCardTile(
                title: seriesCon.seriesList[index]["name"] ?? "",
                year: seriesCon.seriesList[index]["first_air_date"] != null &&
                          seriesCon.seriesList[index]["first_air_date"] != ""
                      ? seriesCon.seriesList[index]["first_air_date"].split("-")[0]
                      : "",
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
