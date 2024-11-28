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
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          )
        : Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Backdrop with Play Button
                  if (movieCon.moviesDetail.backdropPath != null)
                    SizedBox(
                      height: 300.h,
                      child: CustomWebView(
                        initialUrl: "$movieEmbedUrl/${movieCon.moviesDetail.imdbId}",
                        showAppBar: false,
                        errorImageUrl: "$posterUrl${movieCon.moviesDetail.backdropPath}",
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(16.0.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Movie Title
                        Text(
                          movieCon.moviesDetail.title ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Tagline
                        if (movieCon.moviesDetail.tagline != null)
                          Text(
                            movieCon.moviesDetail.tagline ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[400],
                            ),
                          ),
                        SizedBox(height: 16.h),
                        // Poster and details
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Poster image
                            if (movieCon.moviesDetail.posterPath != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: DisplayNetworkImage(
                                  imageUrl:
                                      '$posterUrl${movieCon.moviesDetail.posterPath}',
                                  height: 150.h,
                                  width: 100.w,
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
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "Rating: ${movieCon.moviesDetail.voteAverage ?? 'N/A'}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "Runtime: ${movieCon.moviesDetail.runtime} minutes",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        // Genres
                        const Text(
                          "Genres:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8,
                          children: (movieCon.moviesDetail.genres as List)
                            .map((genre) =>  Chip(
                              label: Text(genre.name, style: const TextStyle(color: Colors.grey),),
                              backgroundColor: Colors.black,
                            ),
                          ).toList(),
                        ),
                        SizedBox(height: 16.h),
                        // Overview
                        const Text(
                          "Overview:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          movieCon.moviesDetail.overview ??
                              'No description available.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Visibility(
            //   visible: true,
            //   child: Positioned(
            //     top: 50,
            //     left: 20,
            //     child: GestureDetector(
            //       onTap:(){
            //         Get.back();
            //       },
            //       child: Container(
            //         padding : EdgeInsets.all(6),
            //         decoration: BoxDecoration(
            //           color: Colors.black.withOpacity(0.2),
            //           borderRadius: BorderRadius.circular(100)
            //         ),
            //         child: Center(
            //           child: Icon(
            //             Icons.arrow_back_ios,
            //             color: Colors.white,
            //             size : 26
            //           ),
            //         ),
            //       ),
            //     )
            //   ),
            // ),
          ],
        )
      ),
    );
  }
}
