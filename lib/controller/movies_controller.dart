

import 'dart:developer';

import 'package:cuplex/apiConfig/api_repo.dart';
import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/model/movies_model.dart';
import 'package:get/get.dart';

class MoviesController extends GetxController{
  late RxBool isLoading = true.obs;
  late RxBool isPageLoading = true.obs;
  late RxBool isDetailLoading = true.obs;
  int pageNum = 0;
  dynamic moviesList = [];
  dynamic moviesDetail;

  // Get Movies List
  getMoviesList() async {
    try {
      isLoading(true);
      var response = await ApiRepo.apiGet(movieListUrl);
      if(response != null) {
        moviesList = response['results'];
        isLoading(false);
      }
    } catch (e) {
      isLoading(false);
    } finally{
      isLoading(false);
    }
  }

  //movie list pagination
  getPagination() async{
    try {
      isPageLoading(true);
      var response = await ApiRepo.apiGet("$movieListUrl?page=$pageNum&sort_by=popularity.desc&include_adult=true");
      if(response != null) {
        moviesList.addAll(response['results']);
      }
    } catch (e) {
      log(e.toString());
    } finally{
      isPageLoading(false);
    }
  }


  //movies detail
  getMoviesDetail(id) async{
    try {
      isDetailLoading(true);
      var response = await ApiRepo.apiGet("$movieDetailUrl/$id");
      if(response != null) {
        final allData = MovieDetailModel.fromJson(response);
        moviesDetail = allData;
      }
    } catch (e) {
      log(e.toString());
    } finally{
      isDetailLoading(false);
    }
  }

}