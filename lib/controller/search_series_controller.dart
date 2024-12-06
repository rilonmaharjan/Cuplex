import 'dart:developer';
import 'package:cuplex/apiConfig/api_repo.dart';
import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/controller/search_movie_controller.dart';
import 'package:get/get.dart';

class SearchSeriesController extends GetxController {
  final SearchMovieController searchCon = Get.put(SearchMovieController());
  late RxBool isSearchListLoading = false.obs;
  late RxBool hasSearched = false.obs;
  late RxBool isPageLoading = true.obs;
  int pageNum = 1;
  int prevPageNum = 1;
  dynamic seriesSearchList = [];
  String searchKeyword = "";

  searchSeries(keyword) async {
    isSearchListLoading(true);
    seriesSearchList.clear();
    try {
      var response = await ApiRepo.apiGet('$searchShowUrl?query=$keyword&include_adult=${searchCon.isAdult}');
      if (response != null) {
        seriesSearchList = response["results"];
      }
    } catch (e) {
      log("errror in search $e");
    } finally {
      isSearchListLoading(false);
      hasSearched(true);
    }
  }

  //search pagination
  getSearchSeriesPagination() async{
    try {
      var response = await ApiRepo.apiGet("$searchShowUrl?query=$searchKeyword&page=$pageNum&sort_by=popularity.desc&include_adult=${searchCon.isAdult}");
      if(response != null) {
        prevPageNum = pageNum;
        seriesSearchList.addAll(response['results']);
        if(response["page"] == response["total_pages"]){
          isPageLoading(false);
        }
      }
      else{
        isPageLoading(false);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
