import 'package:cuplex/controller/movies_controller.dart';
import 'package:cuplex/views/movies/movie_detail.dart';
import 'package:cuplex/widget/tile/movies_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoviesListPage extends StatefulWidget {
  const MoviesListPage({super.key});

  @override
  State<MoviesListPage> createState() => _MoviesListPageState();
}

class _MoviesListPageState extends State<MoviesListPage> {
  final MoviesController movieCon = Get.put(MoviesController());
  ScrollController paginationScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    paginationScrollController.addListener(_scrollListener);
    initialise();
  }

  initialise() async{
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await movieCon.getMoviesList();
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
    movieCon.pageNum = movieCon.pageNum + 1;
    await movieCon.getPagination();
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
        body: Obx(() => movieCon.isLoading.isTrue
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
                  itemCount: movieCon.moviesList.length,
                  itemBuilder: (context, index) {
                    return MovieCard(
                      title: movieCon.moviesList[index]["title"],
                      year: movieCon.moviesList[index]["release_date"].split("-")[0],
                      rating: double.parse(movieCon.moviesList[index]["vote_average"].toStringAsFixed(1)),
                      image: movieCon.moviesList[index]["poster_path"],
                      onTap: (){
                        Get.to(() => MovieDetailPage(id: movieCon.moviesList[index]["id"],));
                      },
                    );
                  },
                ),
              ),
              movieCon.isPageLoading.isTrue ?
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
