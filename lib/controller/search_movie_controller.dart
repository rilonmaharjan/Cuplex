import 'dart:developer';
import 'package:cuplex/apiConfig/api_repo.dart';
import 'package:cuplex/constant/constant.dart';
import 'package:get/get.dart';

class SearchMovieController extends GetxController {
  late RxBool isSearchListLoading = false.obs;
  late RxBool hasSearched = false.obs;
  late RxBool isPageLoading = true.obs;
  int pageNum = 1;
  int prevPageNum = 1;
  dynamic movieSearchList = [];
  String searchKeyword = "";

  searchMovie(keyword) async {
    isSearchListLoading(true);
    movieSearchList.clear();
    try {
      var response = await ApiRepo.apiGet('$searchMovieUrl?query=$keyword');
      if (response != null) {
        movieSearchList = response["results"];
      }
    } catch (e) {
      log("errror in search $e");
    } finally {
      isSearchListLoading(false);
      hasSearched(true);
    }
  }

  //search pagination
  getSearchMoviePagination() async{
    try {
      var response = await ApiRepo.apiGet("$searchMovieUrl?query=$searchKeyword&page=$pageNum&sort_by=popularity.desc&include_adult=true");
      if(response != null) {
        prevPageNum = pageNum;
        movieSearchList.addAll(response['results']);
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
