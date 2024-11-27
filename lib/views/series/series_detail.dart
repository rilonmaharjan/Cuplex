import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/controller/series_controller.dart';
import 'package:cuplex/widget/custom_cached_network.dart';
import 'package:cuplex/widget/custom_webview.dart';
import 'package:flutter/material.dart';
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
              color: Colors.red,
            ),
          )
        : Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Backdrop Image
                  if (seriesCon.seriesDetail.backdropPath != null)
                  (selectedSeason == null && selectedEpisode == null) || seasonPoster == null
                      ? DisplayNetworkImage(
                          imageUrl: "$posterUrl${seriesCon.seriesDetail.backdropPath}",
                          height: 300,
                          width: double.infinity,
                        )
                      : selectedSeason != null && selectedEpisode == null
                      ? DisplayNetworkImage(
                          imageUrl: "$posterUrl/$seasonPoster",
                          height: 300,
                          width: double.infinity,
                        )
                      : SizedBox(
                          height: 300,
                          child: CustomWebView(
                            initialUrl: "$showEmbedUrl?tmdb=${seriesCon.seriesDetail.id}&season=$selectedSeason&episode=$selectedEpisode",
                            showAppBar: false,
                            errorImageUrl: "$posterUrl${seriesCon.seriesDetail.backdropPath}",
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 16),
                        // Poster and Series Info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Poster Image
                            if (seriesCon.seriesDetail.posterPath != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: DisplayNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w500${seriesCon.seriesDetail.posterPath}',
                                  height: 150,
                                  width: 100,
                                ),
                              ),
                            const SizedBox(width: 16),
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
                                  const SizedBox(height: 8),
                                  Text(
                                    "Seasons: ${seriesCon.seriesDetail.numberOfSeasons}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Episodes: ${seriesCon.seriesDetail.numberOfEpisodes}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
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
                        const SizedBox(height: 16),
                        // Genres
                        const Text(
                          "Genres:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
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
                        const SizedBox(height: 16),
                        // Seasons Selection
                        const Text(
                          "Seasons:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Seasons Horizontal Scroll List
                        SizedBox(
                          height: 70,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: seriesCon.seriesDetail.seasons.length,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Chip(
                                    label: Text('Season ${season.seasonNumber}', style: TextStyle(color: selectedSeason == season.seasonNumber ? Colors.black : Colors.grey),),
                                    backgroundColor: selectedSeason == season.seasonNumber
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Episodes Selection (only show if a season is selected)
                        // if (seriesCon.episodeList != null)
                        //   const Text(
                        //     "Episodes:",
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // const SizedBox(height: 8),
                        // if (seriesCon.episodeList != null)
                        //   SizedBox(
                        //     height: 120,
                        //     child: ListView.builder(
                        //       scrollDirection: Axis.horizontal,
                        //       itemCount: seriesCon.episodeList.length,
                        //       itemBuilder: (context, index) {
                        //         return GestureDetector(
                        //           onTap: () {
                        //             setState(() {
                        //               selectedEpisode = episode.episodeNumber;
                        //             });
                        //           },
                        //           child: Stack(
                        //             children: [
                        //               Container(
                        //                 width: 100,
                        //                 height: 60,
                        //                 decoration: BoxDecoration(
                        //                   border: Border.all(
                        //                     color: selectedEpisode == episode.episodeNumber
                        //                         ? Colors.red
                        //                         : Colors.white,
                        //                   ),
                        //                   borderRadius: BorderRadius.circular(8),
                        //                 ),
                        //                 child: DisplayNetworkImage(
                        //                   imageUrl:
                        //                       "$posterUrl${episode.stillPath ?? seriesCon.seriesDetail.backdropPath}",
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //               ),
                        //               Positioned.fill(
                        //                 child: Center(
                        //                   child: Icon(
                        //                     Icons.play_circle_outline,
                        //                     color: selectedEpisode == episode.episodeNumber
                        //                         ? Colors.red
                        //                         : Colors.white,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        const SizedBox(height: 16),
                        // Overview Section
                        const Text(
                          "Overview:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          seriesCon.seriesDetail.overview,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
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
                        const SizedBox(height: 8),
                        Text(
                          "Language: ${seriesCon.seriesDetail.originalLanguage.toUpperCase()}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Status: ${seriesCon.seriesDetail.status}",
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
            ),
            seriesCon.isEpisodeLoading.isTrue 
              ? Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.grey.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
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
