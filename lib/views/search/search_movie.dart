import 'package:cuplex/controller/search_controller.dart';
import 'package:cuplex/views/movies/movie_detail.dart';
import 'package:cuplex/widget/tile/media_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchMoviePage extends StatefulWidget {
  const SearchMoviePage({super.key});

  @override
  State<SearchMoviePage> createState() => _SearchMoviePageState();
}

class _SearchMoviePageState extends State<SearchMoviePage> {
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
          child: Container(
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
                )
              : searchCon.hasSearched.isFalse
              ? const SizedBox(
                height: 400,
                child: Center(
                  child: Text("Enter Keywords...", style: TextStyle(
                      fontWeight: FontWeight.w300, 
                      letterSpacing: 1,
                      height: 1.6,
                      color:Color.fromARGB(255, 219, 219, 219),
                    ),
                  )
                ),
              )
              : searchCon.movieSearchList.isEmpty
              ? const SizedBox(
                height: 400,
                child: Center(
                  child: Text("No Results Found", style: TextStyle(
                      fontWeight: FontWeight.w300, 
                      letterSpacing: 1,
                      height: 1.6,
                      color:Color.fromARGB(255, 219, 219, 219),
                    ),
                  )
                ),
              )
              : GridView.builder(
                physics:  const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: searchCon.movieSearchList.length,
                itemBuilder: (context, index) {
                  return MediaCardTile(
                    title: searchCon.movieSearchList[index]["title"] ?? "",
                    year: searchCon.movieSearchList[index]["release_date"].split("-")[0] ?? "",
                    rating: double.parse(searchCon.movieSearchList[index]["vote_average"].toStringAsFixed(1)),
                    image: searchCon.movieSearchList[index]["poster_path"] ?? "",
                    onTap: () {
                      Get.to(() => MovieDetailPage(id: searchCon.movieSearchList[index]["id"]));
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