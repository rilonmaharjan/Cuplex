import 'package:cuplex/controller/movies_controller.dart';
import 'package:cuplex/views/home_tab_page.dart';
import 'package:cuplex/views/movies/movie_detail.dart';
import 'package:cuplex/widget/custom_appbar.dart';
import 'package:cuplex/widget/loading_widget.dart';
import 'package:cuplex/widget/tile/movies_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BestMovies extends StatefulWidget {
  const BestMovies({super.key});

  @override
  State<BestMovies> createState() => _BestMoviesState();
}

class _BestMoviesState extends State<BestMovies> {
  final MoviesController movieCon = Get.put(MoviesController());
  ScrollController paginationScrollController = ScrollController();
  bool showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    paginationScrollController.addListener(_scrollListener);
    initialise();
  }

  initialise() async{
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await movieCon.getBestMoviesList();
    });
  }

  void _scrollListener() {
    // Check if the user is near the top of the list
    if (paginationScrollController.position.pixels <= 400 && showScrollToTopButton) {
      setState(() {
        showScrollToTopButton = false;
      });
    } 
    // Check if the user is scrolling down past a certain threshold
    else if (paginationScrollController.position.pixels > 400 && !showScrollToTopButton) {
      setState(() {
        showScrollToTopButton = true;
      });
    }
    if (paginationScrollController.position.pixels ==
        paginationScrollController.position.maxScrollExtent) {
      // Load more posts only if the page number hasn't already been updated
      if (movieCon.bestPrevPageNum == movieCon.bestPageNum) {
        _loadMorePosts();
      }
    }
  }

  Future<void> _loadMorePosts() async {
    movieCon.bestPageNum = movieCon.bestPageNum + 1;
    await movieCon.getBestPagination();
    setState(() {});
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
      onPopInvoked: (b){
        paginationScrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
        );
      },
      child: Scaffold(
        appBar: customAppBar(
          backButton: true,
          onTap: () {
            Get.to(() => const HomePage());
          },
        ),
        backgroundColor: Colors.black,
        floatingActionButton: Visibility(
          visible: showScrollToTopButton,
          child: FloatingActionButton(
            backgroundColor: const Color(0xffecc877),
            onPressed: () {
              paginationScrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
              );
            },
            child: const Icon(Icons.arrow_upward_outlined, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          controller: paginationScrollController,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.sp, 24.h, 8.sp, 8.sp),
            child: Column(
              children: [
                // Best movies list
                bestMoviesList(),
                // Pagination loader
                Obx(() => movieCon.isPageLoading.isTrue
                    ? Column(
                        children: [
                          SizedBox(
                            height: 100.h,
                            child: Center(
                              child: loadingWidget()
                            ),
                          ),
                        ],
                      )
                    : const SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build the best movies list
  Widget bestMoviesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Best Movies",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w300, 
            letterSpacing: 1,
            height: 1.6,
            color:const Color.fromARGB(255, 219, 219, 219),
          ),
        ),
        SizedBox(height: 10.h),
        // Movies list
        Obx(() => movieCon.isLoading.isTrue
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
                    child: Container(
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
                        borderRadius: BorderRadius.circular(6),
                      ),
                      height: 150.h,
                      width: 120.w,
                    ),
                  );
                },
              )
            : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: movieCon.bestMoviesList.length,
                itemBuilder: (context, index) {
                  return MovieCard(
                    title: movieCon.bestMoviesList[index]["title"] ?? "",
                    year: movieCon.bestMoviesList[index]["release_date"]
                        .split("-")[0],
                    rating: double.parse(movieCon.bestMoviesList[index]
                            ["vote_average"]
                        .toStringAsFixed(1)),
                    image: movieCon.bestMoviesList[index]["poster_path"] ?? "",
                    onTap: () {
                      Get.to(() => MovieDetailPage(
                          id: movieCon.bestMoviesList[index]["id"]));
                    },
                  );
                },
              )),
      ],
    );
  }
}
