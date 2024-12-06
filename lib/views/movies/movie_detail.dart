import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/controller/movies_controller.dart';
import 'package:cuplex/widget/custom_cached_network.dart';
import 'package:cuplex/widget/custom_webview.dart';
import 'package:cuplex/widget/loading_widget.dart';
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
                          height: 280.h,
                          width: double.infinity,
                          isFromweb: true,
                        ),
                        Container(
                          height: 280.h,
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
                      height: 280.h,
                      child: CustomWebView(
                        initialUrl: "$movieEmbedUrl/${movieCon.moviesDetail.imdbId}",
                        showAppBar: false,
                        errorImageUrl: "$posterUrl${movieCon.moviesDetail.backdropPath}",
                      ),
                    ),
                  ),
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
                  height: 532.h,
                  child: RefreshIndicator(
                    backgroundColor: const Color(0xffecc877),
                    color: Colors.black,
                    onRefresh: (){
                      return Future.delayed(const Duration(seconds: 1),()async{
                        await movieCon.getMoviesDetail(widget.id);
                      });
                    },
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0.sp,16.0.sp,16.0.sp,80.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Movie Title
                            Text(
                              movieCon.moviesDetail.title ?? '',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w300, 
                                letterSpacing: 1,
                                height: 1.6,
                                color:const Color.fromARGB(255, 219, 219, 219),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            // Tagline
                            if (movieCon.moviesDetail.tagline != "")
                              Text(
                                movieCon.moviesDetail.tagline ?? "",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w300, 
                                  letterSpacing: 1,
                                  height: 1.6,
                                  color:const Color.fromARGB(255, 219, 219, 219),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            SizedBox(height: 16.h),
                            // Poster and details
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Poster Image
                                if (movieCon.moviesDetail.posterPath != null)
                                  Container(
                                    height: 150.h,
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
                                        height: 150.h,
                                        width: 100.w,
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 16.w),
                                // Other Movie Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Release Date
                                      if (movieCon.moviesDetail.releaseDate != null)
                                        Text(
                                          "Release Date: ${movieCon.moviesDetail.releaseDate}",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w300, 
                                            letterSpacing: 1,
                                            height: 1.6,
                                            color: const Color.fromARGB(255, 219, 219, 219),
                                          ),
                                        ),
                                      if (movieCon.moviesDetail.releaseDate != null) SizedBox(height: 8.h),

                                      // Rating
                                      if (movieCon.moviesDetail.voteAverage != null)
                                        Text(
                                          "Rating: ${movieCon.moviesDetail.voteAverage}",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w300, 
                                            letterSpacing: 1,
                                            height: 1.6,
                                            color: const Color.fromARGB(255, 219, 219, 219),
                                          ),
                                        ),
                                      if (movieCon.moviesDetail.voteAverage != null) SizedBox(height: 8.h),

                                      // Runtime
                                      if (movieCon.moviesDetail.runtime != null)
                                        Text(
                                          "Runtime: ${movieCon.moviesDetail.runtime} minutes",
                                          style: TextStyle(
                                            fontSize: 14.sp,
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
                            SizedBox(height: 16.h),
                            // Genres
                            if (movieCon.moviesDetail.genres != null && movieCon.moviesDetail.genres.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Genres:",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300, 
                                      letterSpacing: 1,
                                      height: 1.6,
                                      color: const Color.fromARGB(255, 219, 219, 219),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Wrap(
                                    spacing: 8,
                                    children: (movieCon.moviesDetail.genres as List)
                                      .map((genre) => Chip(
                                        label: Text(genre.name, style: const TextStyle(
                                            fontWeight: FontWeight.w300, 
                                            letterSpacing: 1,
                                            height: 1.6,
                                            color: Color.fromARGB(255, 219, 219, 219),
                                          ),
                                        ),
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 6.0.h),
                                        side: BorderSide(
                                          color: const Color.fromARGB(255, 122, 122, 122),
                                          width: 1.0.sp
                                        ),
                                      ),
                                    ).toList(),
                                  ),
                                ],
                              ),
                            SizedBox(height: 16.h),
                            // Overview
                            if (movieCon.moviesDetail.overview != null && movieCon.moviesDetail.overview!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Overview:",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300, 
                                      letterSpacing: 1,
                                      height: 1.6,
                                      color: const Color.fromARGB(255, 219, 219, 219),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    movieCon.moviesDetail.overview ?? 'No description available.',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w300, 
                                      letterSpacing: 1,
                                      height: 1.6,
                                      color: const Color.fromARGB(255, 219, 219, 219),
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: 26.h),
                          ],
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
}
