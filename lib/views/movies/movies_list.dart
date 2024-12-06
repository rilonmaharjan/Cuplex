import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/controller/movies_controller.dart';
import 'package:cuplex/views/movies/best_movies.dart';
import 'package:cuplex/views/movies/movie_detail.dart';
import 'package:cuplex/views/movies/view_all_movie.dart';
import 'package:cuplex/widget/custom_cached_network.dart';
import 'package:cuplex/widget/tile/media_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MoviesListPage extends StatefulWidget {
   const MoviesListPage({super.key});

  @override
  State<MoviesListPage> createState() => _MoviesListPageState();
}

class _MoviesListPageState extends State<MoviesListPage> {
  final MoviesController movieCon = Get.put(MoviesController());
  ScrollController paginationScrollController = ScrollController();
  int count = 0;
  bool showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    paginationScrollController.addListener(_scrollListener);
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

    // Load more content when reaching the bottom
    if (paginationScrollController.position.pixels ==
        paginationScrollController.position.maxScrollExtent) {
      if (movieCon.prevPageNum == movieCon.pageNum) {
        _loadMorePosts();
      }
    }
  }

  Future<void> _loadMorePosts() async {
    movieCon.pageNum = movieCon.pageNum + 1;
    await movieCon.getPagination();
    setState(() { });
  }   

  @override
  void dispose() {
    paginationScrollController.removeListener(_scrollListener);
    count = 0;
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
            await movieCon.getTrendingMoviesList();
            await movieCon.getTopRatedMovies();
            await movieCon.getMoviesList();
            setState(() {
              movieCon.pageNum = 1;
              movieCon.prevPageNum = 1;
              count = 0;
            });
          });
        },
        child: SingleChildScrollView(
          controller: paginationScrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              carosel(),
              SizedBox(height: 10.h,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //trendinglist
                    trendingMoviesList(),
                    SizedBox(height: 18.h,),
                    //topRatedMovies
                    topRatedMoviesList(),
                    SizedBox(height: 18.h,),
                    //all movies list
                    allMoviesList(),
                    //pagination
                    Obx(() => 
                      movieCon.isPageLoading.isTrue
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
              )
            ],
          ),
        ),
      ),
    );
  }

  //trending carousel
  carosel() {
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
      child: Obx(() => movieCon.isTrendingMoviesLoading.isTrue
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
          itemCount:  movieCon.trendingMovieList.length > 10 ? 10 : movieCon.trendingMovieList.length,
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
                      imageUrl: "$posterUrl${movieCon.trendingMovieList[carouselIndex]["poster_path"]}",
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
                          movieCon.trendingMovieList[carouselIndex]["title"] ?? "",
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
                                text: movieCon.trendingMovieList[carouselIndex]["vote_average"] != null &&
                                        movieCon.trendingMovieList[carouselIndex]["vote_average"] != ""
                                    ? double.parse(movieCon.trendingMovieList[carouselIndex]["vote_average"]
                                            .toStringAsFixed(1))
                                        .toString()
                                    : "",
                                style: const TextStyle(color: Color(0xffecc877)), // Yellow color for vote_average
                              ),
                              const TextSpan(text: "  •  "),
                              TextSpan(
                                text: movieCon.trendingMovieList[carouselIndex]["release_date"] != null &&
                                        movieCon.trendingMovieList[carouselIndex]["release_date"] != ""
                                    ? movieCon.trendingMovieList[carouselIndex]["release_date"].split("-")[0]
                                    : "",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        GestureDetector(
                          onTap: () {
                            count++;
                            if (count == 10) {
                              Get.to(() => const BestMovies());
                            }
                          },
                          child: SizedBox(
                            width: 280.w,
                            child: Text(
                              movieCon.trendingMovieList[carouselIndex]["overview"],
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
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => MovieDetailPage(id: movieCon.trendingMovieList[carouselIndex]["id"]));
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

  //trending Movies
  trendingMoviesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         SizedBox(height: 8.h,),
         Row(
           children: [
             Text(
              "Trending Movies",
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
                visible: movieCon.trendingMovieList.isNotEmpty,
                child: InkWell(
                  onTap: (){
                    Get.to(() => ViewAllMovie(title: "Trending Movies", movieList: movieCon.trendingMovieList,));
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
        SizedBox(height: 10.h,),
        SizedBox(
          height: 170.h,
          child: Obx(() => movieCon.isTrendingMoviesLoading.isTrue
            ? ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context,index){
                return Padding(
                  padding: EdgeInsets.only(right: 8.sp),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child:  Container(
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
              itemCount: movieCon.trendingMovieList.length,
              itemBuilder: (context,index){
                final reversedList = movieCon.trendingMovieList.reversed.toList();
                return Container(
                  height: 170.h,
                  width: 122.w,
                  padding: EdgeInsets.only(right: 8.w),
                  child: MediaCardTile(
                    title: reversedList[index]["title"] ?? "",
                    year: reversedList[index]["release_date"] != null && reversedList[index]["release_date"] != ""
                          ? reversedList[index]["release_date"].split("-")[0]
                          : "",
                    rating: reversedList[index]["vote_average"] != null && reversedList[index]["vote_average"].toString().isNotEmpty
                            ? double.parse(
                                double.tryParse(reversedList[index]["vote_average"].toString())?.toStringAsFixed(1) ?? "0.0")
                            : 0.0,
                    image: reversedList[index]["poster_path"] ?? "",
                    onTap: () {
                      Get.to(() => MovieDetailPage(id: reversedList[index]["id"]));
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
  
  //topRated Movies 
  topRatedMoviesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
            "Top Rated Movies",
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
              visible: movieCon.topRatedMovies.isNotEmpty,
              child: InkWell(
                onTap: (){
                  Get.to(() => ViewAllMovie(title: "Top Rated Movies", movieList: movieCon.topRatedMovies,));
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
                    child:  Text(
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
        SizedBox(height: 10.h,),
        SizedBox(
          height: 170.h,
          child: Obx(() => movieCon.isTopRatedMoviesLoading.isTrue
            ? ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context,index){
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
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
              itemCount: movieCon.topRatedMovies.length,
              itemBuilder: (context,index){
                return Container(
                  height: 170.h,
                  width: 122.w,
                  padding: EdgeInsets.only(right: 8.w),
                  child: MediaCardTile(
                    title: movieCon.topRatedMovies[index].title ?? "",
                    year: movieCon.topRatedMovies[index].releaseDate.split("-")[0],
                    rating: double.parse(movieCon.topRatedMovies[index].voteAverage.toStringAsFixed(1)),
                    image: movieCon.topRatedMovies[index].posterPath ?? "",
                    onTap: () {
                      Get.to(() => MovieDetailPage(id: movieCon.topRatedMovies[index].id));
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
  
  //all movies list
  allMoviesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "All Movies",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w300, 
            letterSpacing: 1,
            height: 1.6,
            color: const Color.fromARGB(255, 219, 219, 219),
          ),
        ),
         SizedBox(height: 10.h,),
        //movieslist
        Obx(() => movieCon.isLoading.isTrue
          ? GridView.builder(
              physics:  const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
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
            physics:  const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: movieCon.moviesList.length,
            itemBuilder: (context, index) {
              return MediaCardTile(
                title: movieCon.moviesList[index]["title"] ?? "",
                year: movieCon.moviesList[index]["release_date"] != null && movieCon.moviesList[index]["release_date"] != ""
                      ? movieCon.moviesList[index]["release_date"].split("-")[0]
                      : "",
                rating: movieCon.moviesList[index]["vote_average"] != null &&
                          movieCon.moviesList[index]["vote_average"].toString().isNotEmpty
                      ? double.parse(
                          double.tryParse(movieCon.moviesList[index]["vote_average"].toString())?.toStringAsFixed(1) ?? "0.0")
                      : 0.0,
                image: movieCon.moviesList[index]["poster_path"] ?? "",
                onTap: () {
                  Get.to(() => MovieDetailPage(id: movieCon.moviesList[index]["id"]));
                },
              );
            },
          ),
        ),
      ],
    );
  }
  



}
