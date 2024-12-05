import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/controller/series_controller.dart';
import 'package:cuplex/widget/custom_cached_network.dart';
import 'package:cuplex/widget/custom_webview.dart';
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
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xffecc877),
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
                            Colors.grey.withOpacity(.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
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
                  ],
                ),
                SizedBox(
                  height: 532.h,
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
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0.sp,16.0.sp,16.0.sp,50.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Series Title
                            Text(
                              seriesCon.seriesDetail.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                           SizedBox(height: 8.h),
                            // Tagline (if available)
                            if (seriesCon.seriesDetail.tagline != null &&
                                seriesCon.seriesDetail.tagline.isNotEmpty)
                              Text(
                                seriesCon.seriesDetail.tagline!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
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
                                            'https://image.tmdb.org/t/p/w500${seriesCon.seriesDetail.posterPath}',
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
                                      Text(
                                        "First Air Date: ${seriesCon.seriesDetail.firstAirDate ?? 'N/A'}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                     SizedBox(height: 8.h),
                                      Text(
                                        "Seasons: ${seriesCon.seriesDetail.numberOfSeasons}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                     SizedBox(height: 8.h),
                                      Text(
                                        "Episodes: ${seriesCon.seriesDetail.numberOfEpisodes}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                     SizedBox(height: 8.h),
                                      Text(
                                        "Rating: ${seriesCon.seriesDetail.voteAverage.toStringAsFixed(1)}",
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
                              spacing: 8.0,
                              children: List<Chip>.generate(
                                seriesCon.seriesDetail.genres.length,
                                (index) => Chip(
                                  label: Text(
                                    seriesCon.seriesDetail.genres[index].name ??
                                        'Unknown',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                              ),
                            ),
                           SizedBox(height: 16.h),
                            // Seasons Selection
                           const Text(
                              "Seasons:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                                        label: Text('Season ${season.seasonNumber}', style: TextStyle(color: selectedSeason == season.seasonNumber ? Colors.black : Colors.grey),),
                                        backgroundColor: selectedSeason == season.seasonNumber
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  );
                                } 
                              ),
                            ),
                           SizedBox(height: 8.h),
                            // Episodes Selection (only show if a season is selected)
                            if (seriesCon.episodeList.isNotEmpty)
                             const Text(
                                "Episodes:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
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
                                                    top: 1,
                                                    left: 1,
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 2.sp),
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xffecc877),
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(6),
                                                          bottomRight: Radius.circular(6)
                                                        ),
                                                      ),
                                                      child: Text(
                                                        seriesCon.episodeList[index]["episode_number"].toString(),
                                                        style: const TextStyle(color: Colors.black, fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                           SizedBox(height: 6.h,),
                                            SizedBox(
                                              width: 140.w,
                                              child: Center(child: Text(seriesCon.episodeList[index]["name"], style: const TextStyle(color: Colors.white), maxLines: 1,))
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                           SizedBox(height: 16.h),
                            // Overview Section
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
                              seriesCon.seriesDetail.overview,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                           SizedBox(height: 16.h),
                            // Additional Information
                           const Divider(color: Colors.grey),
                           const Text(
                              "Additional Info:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                           SizedBox(height: 8.h),
                            Text(
                              "Language: ${seriesCon.seriesDetail.originalLanguage.toUpperCase()}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                           SizedBox(height: 8.h),
                            Text(
                              "Status: ${seriesCon.seriesDetail.status}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                           SizedBox(height: 16.h),
                          ],
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
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffecc877),
                  ),
                ),
              )
              : const SizedBox()
          ],
        )
      ),
    );
  }
}
