import 'package:cuplex/controller/movies_controller.dart';
import 'package:cuplex/views/movies/best_movies.dart';
import 'package:cuplex/views/movies/movie_detail.dart';
import 'package:cuplex/views/movies/view_all_movie.dart';
import 'package:cuplex/widget/custom_shimmer.dart';
import 'package:cuplex/widget/tile/movies_list_tile.dart';
import 'package:flutter/material.dart';
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
    initialise();
  }

  initialise() async{
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await movieCon.getTrendingMoviesList();
      await movieCon.getTopRatedMovies();
      await movieCon.getMoviesList();
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
    count;
    movieCon.pageNum;
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
      body: SingleChildScrollView(
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
                        "assets/images/gof.jpg",
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
                      GestureDetector(
                        onTap: (){
                          count++;
                          if(count == 10){
                            Get.to(() => const BestMovies());
                          }
                        },
                        child: RichText(
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
                  trendingMoviesList(),
                  SizedBox(height: 16.h,),
                  //topRatedMovies
                  topRatedMoviesList(),
                  SizedBox(height: 16.h,),
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
                              ),
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
             const Text(
              "Trending Movies",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
                    child:  CustomShimmer(
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
                return Container(
                  height: 170.h,
                  width: 122.w,
                  padding: EdgeInsets.only(right: 8.w),
                  child: MovieCard(
                    title: movieCon.trendingMovieList[index]["title"] ?? "",
                    year: movieCon.trendingMovieList[index]["release_date"].split("-")[0],
                    rating: double.parse(movieCon.trendingMovieList[index]["vote_average"].toStringAsFixed(1)),
                    image: movieCon.trendingMovieList[index]["poster_path"] ?? "",
                    onTap: () {
                      Get.to(() => MovieDetailPage(id: movieCon.trendingMovieList[index]["id"]));
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
             const Text(
              "Top Rated Movies",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
                    child:  CustomShimmer(
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
                  child: MovieCard(
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
         const Text(
          "All Movies",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
                  child:  CustomShimmer(
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
              return MovieCard(
                title: movieCon.moviesList[index]["title"] ?? "",
                year: movieCon.moviesList[index]["release_date"].split("-")[0],
                rating: double.parse(movieCon.moviesList[index]["vote_average"].toStringAsFixed(1)),
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
