import 'package:cuplex/controller/series_controller.dart';
import 'package:cuplex/views/series/series_detail.dart';
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() => seriesCon.isLoading.isTrue
          ? const SizedBox(
            height: 700,
            child: Center(
              child: CircularProgressIndicator(color: Colors.red,),
            ),
          )
          : Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  controller: paginationScrollController,
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
                      rating: double.parse(seriesCon.seriesList[index]["vote_average"].toStringAsFixed(1)),
                      image: seriesCon.seriesList[index]["poster_path"],
                      onTap: (){
                        Get.to(() => SeriesDetailPage(id: seriesCon.seriesList[index]["id"],));
                      },
                    );
                  },
                ),
              ),
              seriesCon.isPageLoading.isTrue ?
              Container(
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
          ),
        ),
      ),
    );
  }
}
