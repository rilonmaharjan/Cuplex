import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/controller/movies_controller.dart';
import 'package:cuplex/widget/custom_cached_network.dart';
import 'package:cuplex/widget/custom_webview.dart';
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
          child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xffecc877),
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
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        height: 280.h,
                        child: CustomWebView(
                          initialUrl: "$movieEmbedUrl/${movieCon.moviesDetail.imdbId}",
                          showAppBar: false,
                          errorImageUrl: "$posterUrl${movieCon.moviesDetail.backdropPath}",
                        ),
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
                                // Poster image
                                if (movieCon.moviesDetail.posterPath != null)
                                  Container(
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: DisplayNetworkImage(
                                        imageUrl:
                                            '$posterUrl${movieCon.moviesDetail.posterPath}',
                                        height: 150.h,
                                        width: 100.w,
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 16.w),
                                // Other movie details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Release Date: ${movieCon.moviesDetail.releaseDate ?? 'N/A'}",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300, 
                                          letterSpacing: 1,
                                          height: 1.6,
                                          color:const Color.fromARGB(255, 219, 219, 219),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        "Rating: ${movieCon.moviesDetail.voteAverage ?? 'N/A'}",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300, 
                                          letterSpacing: 1,
                                          height: 1.6,
                                          color:const Color.fromARGB(255, 219, 219, 219),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        "Runtime: ${movieCon.moviesDetail.runtime} minutes",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300, 
                                          letterSpacing: 1,
                                          height: 1.6,
                                          color:const Color.fromARGB(255, 219, 219, 219),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            // Genres
                            Text(
                              "Genres:",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w300, 
                                letterSpacing: 1,
                                height: 1.6,
                                color:const Color.fromARGB(255, 219, 219, 219),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Wrap(
                              spacing: 8,
                              children: (movieCon.moviesDetail.genres as List)
                                .map((genre) =>  Chip(
                                  label: Text(genre.name, style: const TextStyle(
                                      fontWeight: FontWeight.w300, 
                                      letterSpacing: 1,
                                      height: 1.6,
                                      color:Color.fromARGB(255, 219, 219, 219),
                                    ),
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                              ).toList(),
                            ),
                            SizedBox(height: 16.h),
                            // Overview
                            Text(
                              "Overview:",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w300, 
                                letterSpacing: 1,
                                height: 1.6,
                                color:const Color.fromARGB(255, 219, 219, 219),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              movieCon.moviesDetail.overview ??
                                  'No description available.',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w300, 
                                letterSpacing: 1,
                                height: 1.6,
                                color:const Color.fromARGB(255, 219, 219, 219),
                              ),
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
