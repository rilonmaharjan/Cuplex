import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/controller/series_controller.dart';
import 'package:cuplex/widget/custom_cached_network.dart';
import 'package:cuplex/widget/custom_webview.dart';
import 'package:cuplex/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SeriesDetailPage extends StatefulWidget {
  final int? id;
 const SeriesDetailPage({super.key, this.id});

  @override
  State<SeriesDetailPage> createState() => _SeriesDetailPageState();
}

class _SeriesDetailPageState extends State<SeriesDetailPage> {
  final SeriesController seriesCon = Get.put(SeriesController());
  int? selectedSeason;
  int? selectedEpisode;
  String? seasonPoster;
  String synopsis = "";

  @override
  void initState() {
    super.initState();
    initialise();
  }

  initialise() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await seriesCon.getSeriesDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => seriesCon.isDetailLoading.isTrue
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
        : seriesCon.seriesDetail == null
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
                // Backdrop Image
                if (seriesCon.seriesDetail.backdropPath != null)
                Stack(
                  children: [
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
                      child: (selectedSeason == null && selectedEpisode == null) || seasonPoster == null
                      ? DisplayNetworkImage(
                        imageUrl: "$posterUrl${seriesCon.seriesDetail.backdropPath}",
                        height: 280.h,
                        width: double.infinity,
                        isFromweb: true,
                      )
                      : selectedSeason != null && selectedEpisode == null
                      ? DisplayNetworkImage(
                        imageUrl: "$posterUrl/$seasonPoster",
                        height: 280.h,
                        width: double.infinity,
                        isFromweb: true,
                      )
                      : SizedBox(
                        height: 280.h,
                        child: CustomWebView(
                          key: ValueKey('$selectedSeason-$selectedEpisode'),
                          initialUrl: "$showEmbedUrl?tmdb=${seriesCon.seriesDetail.id}&season=$selectedSeason&episode=$selectedEpisode",
                          showAppBar: false,
                          errorImageUrl: "$posterUrl${seriesCon.seriesDetail.backdropPath}",
                        ),
                      ),
                    ),
                    Visibility(
                      visible: selectedEpisode == null,
                      child: Positioned(
                        top: 50.sp,
                        left: 20.sp,
                        child: GestureDetector(
                          onTap:(){
                            Get.back();
                          },
                          child: Container(
                            height: 36.h,
                            width: 36.w,
                            padding: EdgeInsets.only(left: 6.sp),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(100)
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size : 26
                              ),
                            ),
                          ),
                        )
                      ),
                    ),
                    selectedEpisode == null 
                    ? Container(
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
                    )
                    : const SizedBox()
                  ],
                ),
                Expanded(
                  child: RefreshIndicator(
                    backgroundColor: const Color(0xffecc877),
                    color: Colors.black,
                    onRefresh: (){
                      return Future.delayed(const Duration(seconds: 1),()async{
                        await seriesCon.getSeriesDetail(widget.id);
                      });
                    },
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
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
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.0.sp,16.0.sp,16.0.sp,50.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Series Title
                              Text(
                                seriesCon.seriesDetail.name,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w300, 
                                  letterSpacing: 1,
                                  height: 1.6,
                                  color: const Color.fromARGB(255, 219, 219, 219),
                                ),
                              ),
                             SizedBox(height: 8.h),
                              // Tagline (if available)
                              if (seriesCon.seriesDetail.tagline != null &&
                                  seriesCon.seriesDetail.tagline.isNotEmpty)
                                Text(
                                  seriesCon.seriesDetail.tagline!,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300, 
                                    letterSpacing: 1,
                                    height: 1.6,
                                    color: const Color.fromARGB(255, 219, 219, 219),
                                  ),
                                ),
                             SizedBox(height: 16.h),
                              // Poster and Series Info
                             Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Poster Image
                                if (seriesCon.seriesDetail.posterPath != null)
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
                                        imageUrl: 'https://image.tmdb.org/t/p/w500${seriesCon.seriesDetail.posterPath}',
                                        height: 150.h,
                                        width: 100.w,
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 16.w),
                                // Other Series Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // First Air Date
                                      if (seriesCon.seriesDetail.firstAirDate != null)
                                        Text(
                                          "First Air Date: ${seriesCon.seriesDetail.firstAirDate}",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w300, 
                                            letterSpacing: 1,
                                            height: 1.6,
                                            color: const Color.fromARGB(255, 219, 219, 219),
                                          ),
                                        ),
                                      if (seriesCon.seriesDetail.firstAirDate != null) SizedBox(height: 8.h),
                                      
                                      // Seasons
                                      if (seriesCon.seriesDetail.numberOfSeasons != null)
                                        Text(
                                          "Seasons: ${seriesCon.seriesDetail.numberOfSeasons}",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w300, 
                                            letterSpacing: 1,
                                            height: 1.6,
                                            color: const Color.fromARGB(255, 219, 219, 219),
                                          ),
                                        ),
                                      if (seriesCon.seriesDetail.numberOfSeasons != null) SizedBox(height: 8.h),
                                      
                                      // Episodes
                                      if (seriesCon.seriesDetail.numberOfEpisodes != null)
                                        Text(
                                          "Episodes: ${seriesCon.seriesDetail.numberOfEpisodes}",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w300, 
                                            letterSpacing: 1,
                                            height: 1.6,
                                            color: const Color.fromARGB(255, 219, 219, 219),
                                          ),
                                        ),
                                      if (seriesCon.seriesDetail.numberOfEpisodes != null) SizedBox(height: 8.h),
                                      
                                      // Rating
                                      if (seriesCon.seriesDetail.voteAverage != null)
                                        Text(
                                          "Rating: ${seriesCon.seriesDetail.voteAverage.toStringAsFixed(1)}",
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
                            if (seriesCon.seriesDetail.genres != null && seriesCon.seriesDetail.genres.isNotEmpty)
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
                                  // Display genres here if needed
                                ],
                              ),
                              Wrap(
                                spacing: 8.0,
                                children: List<Chip>.generate(
                                  seriesCon.seriesDetail.genres.length,
                                  (index) => Chip(
                                    label: Text(
                                      seriesCon.seriesDetail.genres[index].name ??
                                          'Unknown',
                                      style: const TextStyle(
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
                                ),
                              ),
                              SizedBox(height: 16.h),
                              // Seasons Selection
                              Text(
                                "Seasons:",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w300, 
                                  letterSpacing: 1,
                                  height: 1.6,
                                  color: const Color.fromARGB(255, 219, 219, 219),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              // Seasons Horizontal Scroll List
                              SizedBox(
                                height: 60.h,
                                child: ListView.builder(
                                  itemCount: seriesCon.seriesDetail.seasons.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var season = seriesCon.seriesDetail.seasons[index];
                                    return GestureDetector(
                                      onTap: () async{
                                        await seriesCon.getEpisodeList(seriesCon.seriesDetail.id,season.seasonNumber);
                                        setState(() {
                                          seasonPoster = season.posterPath;
                                          selectedSeason = season.seasonNumber;
                                          selectedEpisode = null; // Reset episode selection
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right : 8.0.sp),
                                        child: Chip(
                                          label: Text('Season ${season.seasonNumber}', 
                                            style: TextStyle(
                                              color: selectedSeason == season.seasonNumber ? Colors.black : const Color.fromARGB(255, 219, 219, 219),
                                              fontWeight: selectedSeason == season.seasonNumber ? FontWeight.w400 : FontWeight.w300, 
                                              letterSpacing: 1,
                                              height: 1.6,
                                            ),
                                          ),
                                          backgroundColor: selectedSeason == season.seasonNumber
                                              ? const Color.fromARGB(255, 189, 188, 188)
                                              : Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 6.0.h),
                                          side: BorderSide(
                                            color: selectedSeason == season.seasonNumber ? const Color.fromARGB(255, 189, 188, 188) : const Color.fromARGB(255, 122, 122, 122),
                                            width: 1.0.sp
                                          ),
                                        ),
                                      ),
                                    );
                                  } 
                                ),
                              ),
                             SizedBox(height: 8.h),
                              // Episodes Selection (only show if a season is selected)
                              if (seriesCon.episodeList.isNotEmpty)
                                Text(
                                  "Episodes:",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w300, 
                                    letterSpacing: 1,
                                    height: 1.6,
                                    color: const Color.fromARGB(255, 219, 219, 219),
                                  ),
                                ),
                             SizedBox(height: 8.h),
                              if (seriesCon.episodeList.isNotEmpty)
                                SizedBox(
                                  height: 120.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: seriesCon.episodeList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {                                                                             
                                          setState(() {
                                            selectedEpisode = seriesCon.episodeList[index]["episode_number"];
                                            synopsis = seriesCon.episodeList[index]["overview"];
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 7.sp),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 140.w,
                                                height: 90.h,
                                                child: Stack(
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
                                                        border: Border.all(
                                                          width: selectedEpisode == seriesCon.episodeList[index]["episode_number"]
                                                              ? 1.sp
                                                              : 0.5.sp,
                                                          color: selectedEpisode == seriesCon.episodeList[index]["episode_number"]
                                                              ? const Color(0xffecc877)
                                                              : Colors.grey.withOpacity(0.5),
                                                        ),
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(4),
                                                        child: DisplayNetworkImage(
                                                          width: 140.w,
                                                          height: 90.h,
                                                          imageUrl: seriesCon.episodeList[index]["still_path"] == "" || seriesCon.episodeList[index]["still_path"] == null
                                                            ? "$posterUrl${seriesCon.seriesDetail.backdropPath}"
                                                            : "$posterUrl${seriesCon.episodeList[index]["still_path"]}",
                                                        ),
                                                      ),
                                                    ),
                                                   const Positioned.fill(
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.play_circle_outline,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 0.5,
                                                      left: 0.5,
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 2.sp),
                                                        decoration: const BoxDecoration(
                                                          color: Color(0xffecc877),
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(4),
                                                            bottomRight: Radius.circular(4)
                                                          ),
                                                        ),
                                                        child: Text(
                                                          seriesCon.episodeList[index]["episode_number"].toString(),
                                                          style: TextStyle(
                                                            color: Colors.black, 
                                                            fontSize: 12.sp,
                                                            fontWeight: FontWeight.w300, 
                                                            letterSpacing: 1,
                                                            height: 1.6,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                             SizedBox(height: 6.h,),
                                              SizedBox(
                                                width: 140.w,
                                                child: Center(child: Text(
                                                  seriesCon.episodeList[index]["name"], 
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w300, 
                                                    letterSpacing: 1,
                                                    height: 1.6,
                                                    color: Color.fromARGB(255, 219, 219, 219),
                                                  ), 
                                                  maxLines: 1,)
                                                )
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: synopsis != "",
                                  child: SizedBox(height: 16.0.h,)
                                ),
                                // Synopsis Section
                                Visibility(
                                  visible: synopsis != "", 
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.0.sp,vertical: 8.0.sp),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.r),
                                      color: Colors.white.withOpacity(0.15)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Synopsis:",
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
                                          synopsis,
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
                                ),
                              SizedBox(height: 16.h),
                              if(seriesCon.seriesDetail.overview != "")
                              // Overview Section
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
                                seriesCon.seriesDetail.overview,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300, 
                                  letterSpacing: 1,
                                  height: 1.6,
                                  color: const Color.fromARGB(255, 219, 219, 219),
                                ),
                              ),
                              SizedBox(height: 16.h),
                                // Additional Information
                              const Divider(color: Colors.grey),
                              Text(
                                "Additional Info:",
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
                                "Language: ${seriesCon.seriesDetail.originalLanguage.toUpperCase()}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300, 
                                  letterSpacing: 1,
                                  height: 1.6,
                                  color: const Color.fromARGB(255, 219, 219, 219),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Status: ${seriesCon.seriesDetail.status}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300, 
                                  letterSpacing: 1,
                                  height: 1.6,
                                  color: const Color.fromARGB(255, 219, 219, 219),
                                ),
                              ),
                             SizedBox(height: 16.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            seriesCon.isEpisodeLoading.isTrue 
              ? Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.grey.withOpacity(0.2),
                child: Center(
                  child: loadingWidget()
                ),
              )
              : const SizedBox()
          ],
        )
      ),
    );
  }
}
