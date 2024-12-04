import 'package:cuplex/controller/search_controller.dart';
import 'package:cuplex/views/series/series_detail.dart';
import 'package:cuplex/widget/custom_shimmer.dart';
import 'package:cuplex/widget/tile/movies_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchSeriesPage extends StatefulWidget {
  const SearchSeriesPage({super.key});

  @override
  State<SearchSeriesPage> createState() => _SearchSeriesPageState();
}

class _SearchSeriesPageState extends State<SearchSeriesPage> {
  final SearchhController searchCon = Get.put(SearchhController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        backgroundColor: const Color(0xffecc877),
        color: Colors.black,
        onRefresh: (){
          return Future.delayed(const Duration(seconds: 1),()async{
            searchCon.searchMovieAndSeries(searchCon.searchKeyword);
          });
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.0.sp,16.sp,8.sp,8.sp),
            child:  Obx(() => searchCon.isSearchListLoading.isTrue
              ? GridView.builder(
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
                      borderRadius: BorderRadius.circular(6),
                      child:  CustomShimmer(
                        height: 150.h,
                        width: 120.w,
                      ),
                    );
                  }
                )
              : searchCon.hasSearched.isFalse
              ? const SizedBox(
                height: 400,
                child: Center(
                  child: Text("Enter Keywords...", style: TextStyle(color: Colors.white),)
                ),
              )
              : searchCon.seriesSearchList.isEmpty
              ? const SizedBox(
                height: 400,
                child: Center(
                  child: Text("No Results Found", style: TextStyle(color: Colors.white),)
                ),
              )
              :  GridView.builder(
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
                  return MovieCard(
                    title: searchCon.seriesSearchList[index]["name"] ?? "",
                    year: (searchCon.seriesSearchList[index]['first_air_date'] ?? '').split('-').first,
                    rating: double.parse(searchCon.seriesSearchList[index]["vote_average"].toStringAsFixed(1)),
                    image: searchCon.seriesSearchList[index]["poster_path"] ?? "",
                    onTap: () {
                      Get.to(() => SeriesDetailPage(id: searchCon.seriesSearchList[index]["id"]));
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}