import 'package:cuplex/views/movies/movie_detail.dart';
import 'package:cuplex/widget/tile/movies_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ViewAllMovie extends StatefulWidget {
  final dynamic movieList;
  final String title;
  const ViewAllMovie({super.key, this.movieList, required this.title});

  @override
  State<ViewAllMovie> createState() => _ViewAllMovieState();
}

class _ViewAllMovieState extends State<ViewAllMovie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10.h),
              //Serieslist
              GridView.builder(
                physics:  const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: widget.movieList.length,
                itemBuilder: (context, index) {
                  return widget.title == "Trending Series" 
                  ? MovieCard(
                    title: widget.movieList[index]["title"] ?? "",
                    year: widget.movieList[index]["release_date"].split("-")[0],
                    rating: double.parse(widget.movieList[index]["vote_average"].toStringAsFixed(1)),
                    image: widget.movieList[index]["poster_path"] ?? "",
                    onTap: () {
                      Get.to(() => MovieDetailPage(id: widget.movieList[index]["id"]));
                    },
                  )
                  : MovieCard(
                    title: widget.movieList[index].title ?? "",
                    year: widget.movieList[index].releaseDate.split("-")[0],
                    rating: double.parse(widget.movieList[index].voteAverage.toStringAsFixed(1)),
                    image: widget.movieList[index].posterPath ?? "",
                    onTap: () {
                      Get.to(() => MovieDetailPage(id: widget.movieList[index].id));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}