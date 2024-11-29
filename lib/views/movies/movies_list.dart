import 'package:cuplex/controller/movies_controller.dart';
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
    if (paginationScrollController.position.pixels ==
        paginationScrollController.position.maxScrollExtent) {
      // When the user reaches the end of the list
      _loadMorePosts();
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
