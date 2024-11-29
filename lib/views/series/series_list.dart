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
    if (paginationScrollController.position.pixels ==
        paginationScrollController.position.maxScrollExtent) {
      // When the user reaches the end of the list
      _loadMorePosts();
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
      body: SingleChildScrollView(
        controller: paginationScrollController,
        child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: Colors.red,
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
