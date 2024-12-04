import 'dart:developer';
import 'package:cuplex/apiConfig/api_repo.dart';
import 'package:get/get.dart';

class SearchhController extends GetxController {
  late RxBool isSearchListLoading = false.obs;
  late RxBool hasSearched = false.obs;
  dynamic movieSearchList = [];
  dynamic seriesSearchList = [];
  String searchKeyword = "";

  searchMovieAndSeries(keyword) async {
    isSearchListLoading(true);
    movieSearchList.clear();
    seriesSearchList.clear();
    try {
      var response = await ApiRepo.apiGet('https://api.themoviedb.org/3/search/multi?query=$keyword');
      if (response != null) {
        for(var allData in response['results']){
          if(allData['media_type'] == "tv"){
            seriesSearchList.add(allData);
          }
          else if(allData['media_type'] == "movie"){
            movieSearchList.add(allData);
          }
        }
      }
    } catch (e) {
      log("errror in search $e");
    } finally {
      isSearchListLoading(false);
      hasSearched(true);
    }
  }
}
