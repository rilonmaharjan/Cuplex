import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/controller/movies_controller.dart';
import 'package:cuplex/widget/custom_cached_network.dart';
import 'package:cuplex/widget/custom_webview.dart';
import 'package:cuplex/widget/loading_widget.dart';
import 'package:cuplex/widget/tile/media_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MovieDetailPage extends StatefulWidget {
  final int? id;
  const MovieDetailPage({super.key, this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final MoviesController movieCon = Get.put(MoviesController());
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    initialise();
  }

  initialise() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await movieCon.getMoviesDetail(widget.id);
      await movieCon.getRecomendedMovies(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => movieCon.isDetailLoading.isTrue
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
          child: Center(
              child: loadingWidget()
            ),
        )
        : movieCon.moviesDetail == null
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
          child: const Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(
                  fontWeight: FontWeight.w300, 
                  letterSpacing: 1,
                  height: 1.6,
                  color:Color.fromARGB(255, 219, 219, 219),
                ),
                textAlign: TextAlign.center,
              ),
            ),
        )
        : Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Backdrop with Play Button
                if (movieCon.moviesDetail.backdropPath != null)
                  Container(
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
                    child: isPlaying == false
                    ? Stack(
                      alignment: Alignment.center,
                      children: [
                        DisplayNetworkImage(
                          imageUrl: "$posterUrl${movieCon.moviesDetail.backdropPath}",
                          height: 276.h,
                          width: double.infinity,
                          isFromweb: true,
                        ),
                        Container(
                          height: 278.h,
                          width: double.infinity,
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
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isPlaying = true;
                            });
                          },
                          child: Container(
                            width: 70.sp, 
                            height: 70.sp,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.play_arrow_rounded, 
                              color: Colors.white, 
                              size: 46.sp, 
                            ),
                          ),
                        )
                      ],
                    )
                    : SizedBox(
                      height: 276.h,
                      child: CustomWebView(
                        initialUrl: "$movieEmbedUrl/${movieCon.moviesDetail.imdbId}",
                        showAppBar: false,
                        errorImageUrl: "$posterUrl${movieCon.moviesDetail.backdropPath}",
                      ),
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    backgroundColor: const Color(0xffecc877),
                    color: Colors.black,
                    onRefresh: (){
                      return Future.delayed(const Duration(seconds: 1),()async{
                        await movieCon.getMoviesDetail(widget.id);
                        setState(() {
                          isPlaying = false;
                        });
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.grey.withOpacity(.3),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.0.sp,16.0.sp,16.0.sp, 20.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Movie Title
                              Text(
                                movieCon.moviesDetail.title ?? '',
                                style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w300, 
                                  letterSpacing: 1,
                                  height: 1.6,
                                  color:const Color.fromARGB(255, 219, 219, 219),
                                ),
                              ),
                              movieCon.moviesDetail.tagline != ""
                              ? SizedBox(height: 6.h)
                              : SizedBox(height: 8.h),
                              // Tagline
                              if (movieCon.moviesDetail.tagline != "")
                                Text(
                                  movieCon.moviesDetail.tagline ?? "",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w300, 
                                    letterSpacing: 1,
                                    height: 1.6,
                                    color:const Color(0xffeec877),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              if (movieCon.moviesDetail.tagline != "")
                              SizedBox(height: 12.h),
                              // Poster and details
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 8.0.w,),
                                  // Poster Image
                                  if (movieCon.moviesDetail.posterPath != null)
                                    Container(
                                      height: 140.h,
                                      width: 100.w,
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
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: DisplayNetworkImage(
                                          imageUrl: '$posterUrl${movieCon.moviesDetail.posterPath}',
                                          height: 140.h,
                                          width: 100.w,
                                        ),
                                      ),
                                    ),
                                  SizedBox(width: 20.w),
                                  // Other Movie Details
                                  SizedBox(
                                    height: 140.h,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Release Date
                                        if (movieCon.moviesDetail.releaseDate != null)
                                          Text(
                                            "Release Date: ${movieCon.moviesDetail.releaseDate}",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w300, 
                                              letterSpacing: 1,
                                              height: 1.6,
                                              color: const Color.fromARGB(255, 219, 219, 219),
                                            ),
                                          ),
                                        if (movieCon.moviesDetail.releaseDate != null) SizedBox(height: 8.h),
                        
                                        // Rating
                                        if (movieCon.moviesDetail.voteAverage != null)
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: 1,
                                                height: 1.6,
                                              ),
                                              children: [
                                                const TextSpan(
                                                  text: "Rating:  ",
                                                  style: TextStyle(
                                                    color: Color.fromARGB(255, 219, 219, 219),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: movieCon.moviesDetail.voteAverage.toStringAsFixed(1),
                                                  style: TextStyle(
                                                    color: const Color(0xffeec877),
                                                    fontSize: 13.sp
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (movieCon.moviesDetail.voteAverage != null) SizedBox(height: 8.h),
                        
                                        // Runtime
                                        if (movieCon.moviesDetail.runtime != null)
                                          Text(
                                            "Runtime: ${movieCon.moviesDetail.runtime} minutes",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w300, 
                                              letterSpacing: 1,
                                              height: 1.6,
                                              color: const Color.fromARGB(255, 219, 219, 219),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              // Genres
                              if (movieCon.moviesDetail.genres != null && movieCon.moviesDetail.genres.isNotEmpty)
                                Wrap(
                                  spacing: 8,
                                  children: (movieCon.moviesDetail.genres as List)
                                    .map((genre) => Chip(
                                      label: Text(genre.name, 
                                        style:  TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w300, 
                                          letterSpacing: 1,
                                          height: 1.6,
                                          color: const Color.fromARGB(255, 219, 219, 219),
                                        ),
                                      ),
                                      backgroundColor: Colors.black.withOpacity(0.75),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4.0.r),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.0.h),
                                      side: BorderSide(
                                        color: Colors.transparent,
                                        width: 0.0.sp
                                      ),
                                    ),
                                  ).toList(),
                                ),
                              if (movieCon.moviesDetail.genres != null && movieCon.moviesDetail.genres.isNotEmpty)                                                                
                              SizedBox(height: 10.h),
                              // Overview
                              if (movieCon.moviesDetail.overview != null && movieCon.moviesDetail.overview!.isNotEmpty)
                                Text(
                                  movieCon.moviesDetail.overview ?? 'No description available.',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300, 
                                    letterSpacing: 1,
                                    height: 1.6,
                                    color: const Color.fromARGB(255, 219, 219, 219),
                                  ),
                                ),
                              SizedBox(height: 14.0.h,),
                              reccomendedList(),
                              SizedBox(height: 30.0.h,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
  
  reccomendedList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "You May Also Like",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300, 
            letterSpacing: 1,
            height: 1.6,
            color: const Color.fromARGB(255, 219, 219, 219),
          ),
        ),
        SizedBox(height: 14.0.h,),
        SizedBox(
          height: 176.h,
          child: Obx(() => movieCon.isRecLoading.isTrue
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
                      height: 176.h,
                      width: 128.w,
                    ),
                  ),
                );
              }
            )
            : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: movieCon.recMoviesList.length,
              itemBuilder: (context,index){
                final recommendedList = movieCon.recMoviesList.reversed.toList();
                return Container(
                  height: 176.h,
                  width: 128.w,
                  padding: EdgeInsets.only(right: 10.w),
                  child: MediaCardTile(
                    title: recommendedList[index]["title"] ?? "",
                    year: recommendedList[index]["release_date"] != null && recommendedList[index]["release_date"] != ""
                          ? recommendedList[index]["release_date"].split("-")[0]
                          : "",
                    rating: recommendedList[index]["vote_average"] != null && recommendedList[index]["vote_average"].toString().isNotEmpty
                            ? double.parse(
                                double.tryParse(recommendedList[index]["vote_average"].toString())?.toStringAsFixed(1) ?? "0.0")
                            : 0.0,
                    image: recommendedList[index]["poster_path"] ?? "",
                    onTap: () async{
                      await movieCon.getMoviesDetail(recommendedList[index]["id"]);
                      await movieCon.getRecomendedMovies(recommendedList[index]["id"]);
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
}
