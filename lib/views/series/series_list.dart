import 'package:cuplex/controller/series_controller.dart';
import 'package:cuplex/views/series/series_detail.dart';
import 'package:cuplex/widget/custom_shimmer.dart';
import 'package:cuplex/widget/tile/movies_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeriesListPage extends StatefulWidget {
  const SeriesListPage({super.key});

  @override
  State<SeriesListPage> createState() => _SeriesListPageState();
}

class _SeriesListPageState extends State<SeriesListPage> {
  final SeriesController seriesCon = Get.put(SeriesController());
  ScrollController paginationScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    paginationScrollController.addListener(_scrollListener);
    initialise();
  }

  initialise() async{
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await seriesCon.getTrendingList();
      await seriesCon.getTopRatedSeries();
      await seriesCon.getSeriesList();
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
    seriesCon.pageNum = seriesCon.pageNum + 1;
    await seriesCon.getPagination();
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //trendinglist
              trendingSeriesList(),
              const SizedBox(height: 16.0,),
              //topRatedseries
              topRatedSeriesList(),
              const SizedBox(height: 16.0,),
              //all series list
              allSeriesList(),
              //pagination
              Obx(() => 
                seriesCon.isPageLoading.isTrue
                ? const Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }

  //trending Series
  trendingSeriesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8,),
        const Text(
          "Trending Series",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10.0,),
        SizedBox(
          height: 170,
          child: Obx(() => seriesCon.isTrendingSeriesLoading.isTrue
            ? ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: const CustomShimmer(
                      height: 170,
                      width: 126,
                    ),
                  ),
                );
              }
            )
            : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: seriesCon.trendingSeriesList.length,
              itemBuilder: (context,index){
                return Container(
                  height: 170,
                  width: 134,
                  padding: const EdgeInsets.only(right: 8),
                  child: MovieCard(
                    title: seriesCon.trendingSeriesList[index]["name"] ?? "",
                    year: seriesCon.trendingSeriesList[index]["first_air_date"].split("-")[0],
                    rating: seriesCon.trendingSeriesList[index]["vote_average"] == null ? 0 : double.parse(seriesCon.trendingSeriesList[index]["vote_average"].toStringAsFixed(1)),
                    image: seriesCon.trendingSeriesList[index]["poster_path"] ?? "",
                    onTap: (){
                      Get.to(() => SeriesDetailPage(id: seriesCon.trendingSeriesList[index]["id"],));
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
  
  //topRated Series 
  topRatedSeriesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Top Rated Series",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10.0,),
        SizedBox(
          height: 170,
          child: Obx(() => seriesCon.isTopRatedSeriesLoading.isTrue
            ? ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: const CustomShimmer(
                      height: 170,
                      width: 126,
                    ),
                  ),
                );
              }
            )
            : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: seriesCon.topRatedSeries.length,
              itemBuilder: (context,index){
                return Container(
                  height: 170,
                  width: 134,
                  padding: const EdgeInsets.only(right: 8),
                  child: MovieCard(
                    title: seriesCon.topRatedSeries[index].name ?? "",
                    year: seriesCon.topRatedSeries[index].firstAirDate.split("-")[0],
                    rating: seriesCon.topRatedSeries[index].voteAverage == null ? 0 : double.parse(seriesCon.topRatedSeries[index].voteAverage.toStringAsFixed(1)),
                    image: seriesCon.topRatedSeries[index].posterPath ?? "",
                    onTap: (){
                      Get.to(() => SeriesDetailPage(id: seriesCon.topRatedSeries[index].id,));
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
  
  //all Series list
  allSeriesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "All Series",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10.0,),
        //Serieslist
        Obx(() => seriesCon.isLoading.isTrue
          ? GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const CustomShimmer(
                    height: 150,
                    width: 120,
                  ),
                );
              }
            )
          :  GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: seriesCon.seriesList.length,
            itemBuilder: (context, index) {
              return MovieCard(
                title: seriesCon.seriesList[index]["name"] ?? "",
                year: seriesCon.seriesList[index]["first_air_date"].split("-")[0],
                rating: seriesCon.seriesList[index]["vote_average"] == null ? 0 : double.parse(seriesCon.seriesList[index]["vote_average"].toStringAsFixed(1)),
                image: seriesCon.seriesList[index]["poster_path"] ?? "",
                onTap: (){
                  Get.to(() => SeriesDetailPage(id: seriesCon.seriesList[index]["id"],));
                },
              );
            },
          ),
        ),
      ],
    );
  }

}
