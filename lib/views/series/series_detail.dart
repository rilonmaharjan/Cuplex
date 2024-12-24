import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/controller/series_controller.dart';
import 'package:cuplex/widget/custom_cached_network.dart';
import 'package:cuplex/widget/custom_webview.dart';
import 'package:cuplex/widget/fade_in.dart';
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
  final ScrollController _scrollController = ScrollController();
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
                  alignment: Alignment.center,
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
                        height: 276.h,
                        width: double.infinity,
                        isFromweb: true,
                        alignment: Alignment.topCenter,
                      )
                      : selectedSeason != null && selectedEpisode == null
                      ? DisplayNetworkImage(
                        imageUrl: "$posterUrl/$seasonPoster",
                        height: 276.h,
                        width: double.infinity,
                        isFromweb: true,
                        alignment: Alignment.topCenter,
                      )
                      : SizedBox(
                        height: 276.h,
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
                              color: Colors.black.withOpacity(0.3),
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
                    : const SizedBox(),
                    (selectedSeason == null && selectedEpisode == null) || seasonPoster == null
                      ? GestureDetector(
                        onTap: () async{
                          await seriesCon.getEpisodeList(seriesCon.seriesDetail.id,seriesCon.seriesDetail.seasons[0].seasonNumber);
                          setState(() {
                            seasonPoster = seriesCon.seriesDetail.seasons[0].posterPath;
                            selectedSeason = seriesCon.seriesDetail.seasons[0].seasonNumber;
                            selectedEpisode = null; // Reset episode selection
                          });
                          await _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent, // Scroll to bottom
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                          );
                        },
                        child: Container(
                          width: 70.sp, 
                          height: 70.sp,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded, 
                            color: Colors.white, 
                            size: 46.sp, 
                          ),
                        ),
                      )
                      : selectedSeason != null && selectedEpisode == null
                      ? GestureDetector(
                        onTap: () {                                                                             
                          setState(() {
                            selectedEpisode = seriesCon.episodeList[0]["episode_number"];
                            synopsis = seriesCon.episodeList[0]["overview"];
                          });
                        },
                        child: Container(
                          width: 70.sp, 
                          height: 70.sp,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded, 
                            color: Colors.white, 
                            size: 46.sp, 
                          ),
                        ),
                      )
                      : const SizedBox(),
                  ],
                ),
                Expanded(
                  child: RefreshIndicator(
                    backgroundColor: const Color(0xffecc877),
                    color: Colors.white,
                    onRefresh: (){
                      return Future.delayed(const Duration(seconds: 1),()async{
                        await seriesCon.getSeriesDetail(widget.id);
                        setState((){
                          selectedSeason =  null;
                          selectedEpisode = null;
                          seasonPoster = null;
                          synopsis = "";
                        });
                      });
                    },
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 450),
                      from: 100.sp,
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
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16.0.sp,16.0.sp,16.0.sp, seriesCon.seriesDetail.overview == "" || seriesCon.seriesDetail.genres.isEmpty ? 160.sp : 80.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Series Title
                                Text(
                                  seriesCon.seriesDetail.name,
                                  style: TextStyle(
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.w300, 
                                    letterSpacing: 1,
                                    height: 1.6,
                                    color: const Color.fromARGB(255, 219, 219, 219),
                                  ),
                                ),
                                seriesCon.seriesDetail.tagline != null && seriesCon.seriesDetail.tagline.isNotEmpty 
                                  ? SizedBox(height: 6.h)
                                  : SizedBox(height: 8.h),
                                // Tagline (if available)
                                if (seriesCon.seriesDetail.tagline != null &&  seriesCon.seriesDetail.tagline.isNotEmpty)
                                  Text(
                                    seriesCon.seriesDetail.tagline!,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w300, 
                                      letterSpacing: 1,
                                      height: 1.6,
                                      color: const Color(0xffeec877),
                                    ),
                                  ),
                                if (seriesCon.seriesDetail.tagline != null && seriesCon.seriesDetail.tagline.isNotEmpty)
                                  SizedBox(height: 12.h),
                                  // Poster and Series Info
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 8.0.w,),
                                    // Poster Image
                                    if (seriesCon.seriesDetail.posterPath != null)
                                      Container(
                                        height: 140.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
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
                                            height: 140.h,
                                            width: 100.w,
                                          ),
                                        ),
                                      ),
                                    SizedBox(width: 20.w),
                                    // Other Series Details
                                    SizedBox(
                                      height: 140.h,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // First Air Date
                                          if (seriesCon.seriesDetail.firstAirDate != null)
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "First Air Date:  ",
                                                    style: TextStyle(
                                                      fontSize: 13.sp, // Static size
                                                      fontWeight: FontWeight.w300,
                                                      letterSpacing: 1,
                                                      height: 1.6,
                                                      color: const Color.fromARGB(255, 219, 219, 219),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "${seriesCon.seriesDetail.firstAirDate}", // Dynamic value
                                                    style: TextStyle(
                                                      fontSize: 13.sp, // Dynamic size
                                                      fontWeight: FontWeight.w300,
                                                      letterSpacing: 1,
                                                      height: 1.6,
                                                      color: const Color.fromARGB(255, 219, 219, 219),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (seriesCon.seriesDetail.firstAirDate != null) SizedBox(height: 8.h),
                                          
                                          // Seasons
                                          if (seriesCon.seriesDetail.numberOfSeasons != null)
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Seasons:  ", // Static text
                                                    style: TextStyle(
                                                      fontSize: 13.sp, // Static size
                                                      fontWeight: FontWeight.w300,
                                                      letterSpacing: 1,
                                                      height: 1.6,
                                                      color: const Color.fromARGB(255, 219, 219, 219),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "${seriesCon.seriesDetail.numberOfSeasons}", // Dynamic value
                                                    style: TextStyle(
                                                      fontSize: 13.sp, // Dynamic size
                                                      fontWeight: FontWeight.w300,
                                                      letterSpacing: 1,
                                                      height: 1.6,
                                                      color: const Color.fromARGB(255, 219, 219, 219),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                      
                                          if (seriesCon.seriesDetail.numberOfSeasons != null) SizedBox(height: 8.h),
                                          
                                          // Episodes
                                          if (seriesCon.seriesDetail.numberOfEpisodes != null)
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Episodes:  ", // Static text
                                                    style: TextStyle(
                                                      fontSize: 13.sp, // Static size
                                                      fontWeight: FontWeight.w300,
                                                      letterSpacing: 1,
                                                      height: 1.6,
                                                      color: const Color.fromARGB(255, 219, 219, 219),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "${seriesCon.seriesDetail.numberOfEpisodes}", // Dynamic value
                                                    style: TextStyle(
                                                      fontSize: 13.sp, // Dynamic size
                                                      fontWeight: FontWeight.w300,
                                                      letterSpacing: 1,
                                                      height: 1.6,
                                                      color: const Color.fromARGB(255, 219, 219, 219),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                      
                                          if (seriesCon.seriesDetail.numberOfEpisodes != null) SizedBox(height: 8.h),
                                          
                                          // Rating
                                            Visibility(
                                              visible: seriesCon.seriesDetail.voteAverage.toStringAsFixed(1) != "0.0",
                                              child: RichText(
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
                                                      text: seriesCon.seriesDetail.voteAverage.toStringAsFixed(1),
                                                      style: TextStyle(
                                                        color: const Color(0xffeec877),
                                                        fontSize: 13.sp
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                // Genres
                                if (seriesCon.seriesDetail.genres != null && seriesCon.seriesDetail.genres.isNotEmpty)
                                  Wrap(
                                    spacing: 8.0,
                                    children: List<Chip>.generate(
                                      seriesCon.seriesDetail.genres.length,
                                      (index) => Chip(
                                        label: Text(
                                          seriesCon.seriesDetail.genres[index].name ??
                                              'Unknown',
                                          style: TextStyle(
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
                                    ),
                                  ),
                                if (seriesCon.seriesDetail.genres != null && seriesCon.seriesDetail.genres.isNotEmpty)
                                  SizedBox(height: 10.h),
                                if(seriesCon.seriesDetail.overview != "")
                                  // Overview Section
                                  Text(
                                    seriesCon.seriesDetail.overview,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w300, 
                                      letterSpacing: 1,
                                      height: 1.6,
                                      color: const Color.fromARGB(255, 219, 219, 219),
                                    ),
                                  ),
                                if(seriesCon.seriesDetail.overview != "")
                                  SizedBox(height: 14.h),
                                // Seasons Horizontal Scroll List
                                SizedBox(
                                  height: 30.h,
                                  child: ListView.builder(
                                    itemCount: seriesCon.seriesDetail.seasons.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var season = seriesCon.seriesDetail.seasons[index];
                                      return GestureDetector(
                                        onTap: () async{
                                          if(selectedSeason != season.seasonNumber){
                                            await seriesCon.getEpisodeList(seriesCon.seriesDetail.id,season.seasonNumber);
                                            setState(() {
                                              seasonPoster = season.posterPath;
                                              selectedSeason = season.seasonNumber;
                                              selectedEpisode = null; // Reset episode selection
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(right : 8.0.sp),
                                          child: Chip(
                                            label: Text('Season ${season.seasonNumber}', 
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontWeight: selectedSeason == season.seasonNumber ? FontWeight.w400 : FontWeight.w300, 
                                                letterSpacing: 1,
                                                height: 1.6,
                                              ),
                                            ),
                                            backgroundColor: selectedSeason == season.seasonNumber
                                                ? const Color(0xffeec877)
                                                : Colors.black.withOpacity(0.75),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.0.r),
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.0.h),
                                            side: BorderSide(
                                              color: Colors.transparent,
                                              width: 0.0.sp
                                            ),
                                          ),
                                        ),
                                      );
                                    } 
                                  ),
                                ),
                                if (seriesCon.episodeList.isNotEmpty)
                                  SizedBox(height: 20.h),
                                if (seriesCon.episodeList.isNotEmpty)
                                  SizedBox(
                                    height: 120.h,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                        SizedBox(width: 12.0.w,),
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
                                                              : Colors.grey.withOpacity(0.3),
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
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w300, 
                                                    letterSpacing: 1,
                                                    height: 1.6,
                                                    color: const Color.fromARGB(255, 219, 219, 219),
                                                  ), 
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,)
                                                )
                                              )
                                            ],
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
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w300, 
                                            letterSpacing: 1,
                                            height: 1.6,
                                            color: const Color.fromARGB(255, 219, 219, 219),
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          synopsis,
                                          style: TextStyle(
                                            fontSize: 12.sp,
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
                                SizedBox(height: 10.h),
                                  // Additional Information
                                const Divider(color: Colors.grey),
                                SizedBox(height: 10.h),
                                Text(
                                  "Additional Info:",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w300, 
                                    letterSpacing: 1,
                                    height: 1.6,
                                    color: const Color.fromARGB(255, 219, 219, 219),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  "Language: ${seriesCon.seriesDetail.originalLanguage.toUpperCase()}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300, 
                                    letterSpacing: 1,
                                    height: 1.6,
                                    color: const Color.fromARGB(255, 219, 219, 219),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  "Status: ${seriesCon.seriesDetail.status}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300, 
                                    letterSpacing: 1,
                                    height: 1.6,
                                    color: const Color.fromARGB(255, 219, 219, 219),
                                  ),
                                ),
                                SizedBox(height : 30.0.h),
                              ],
                            ),
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
