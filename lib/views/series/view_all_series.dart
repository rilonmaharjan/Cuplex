import 'package:cuplex/views/series/series_detail.dart';
import 'package:cuplex/widget/custom_appbar.dart';
import 'package:cuplex/widget/tile/movies_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ViewAllSeries extends StatefulWidget {
  final dynamic seriesList;
  final String title;
  const ViewAllSeries({super.key, this.seriesList, required this.title});

  @override
  State<ViewAllSeries> createState() => _ViewAllSeriesState();
}

class _ViewAllSeriesState extends State<ViewAllSeries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: customAppBar(backButton: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(8.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h,),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w300, 
                  letterSpacing: 1,
                  height: 1.6,
                  color: const Color.fromARGB(255, 219, 219, 219),
                ),
              ),
              SizedBox(height: 20.h),
              //Serieslist
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: widget.seriesList.length,
                itemBuilder: (context, index) {
                  return widget.title == "Trending Series" 
                  ? MovieCard(
                    title: widget.seriesList[index]["name"] ?? "",
                    year: widget.seriesList[index]["first_air_date"].split("-")[0],
                    rating: widget.seriesList[index]["vote_average"] == null ? 0 : double.parse(widget.seriesList[index]["vote_average"].toStringAsFixed(1)),
                    image: widget.seriesList[index]["poster_path"] ?? "",
                    onTap: (){
                      Get.to(() => SeriesDetailPage(id: widget.seriesList[index]["id"],));
                    },
                  )
                  : MovieCard(
                    title: widget.seriesList[index].name ?? "",
                    year: widget.seriesList[index].firstAirDate.split("-")[0],
                    rating: widget.seriesList[index].voteAverage == null ? 0 : double.parse(widget.seriesList[index].voteAverage.toStringAsFixed(1)),
                    image: widget.seriesList[index].posterPath ?? "",
                    onTap: (){
                      Get.to(() => SeriesDetailPage(id: widget.seriesList[index].id,));
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