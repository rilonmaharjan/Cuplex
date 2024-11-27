

import 'dart:developer';

import 'package:cuplex/apiConfig/api_repo.dart';
import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/model/movies_model.dart';
import 'package:get/get.dart';

class MoviesController extends GetxController{
  late RxBool isLoading = false.obs;
  late RxBool isPageLoading = false.obs;
  late RxBool isDetailLoading = false.obs;
  int pageNum = 0;
  dynamic moviesList = [];
  dynamic moviesDetail;

  // Start Loading
  startLoading(){
    isLoading(true);
    update();
  }

  // Stop Loading
  stopLoading(){
    isLoading(false);
    update();
  }

  // Start Pagination Loading
  startPageLoading(){
    isPageLoading(true);
    update();
  }

  // Stop Pagination Loading
  stopPageLoading(){
    isPageLoading(false);
    update();
  }

  // Start Detail Loading
  startDetailLoading(){
    isDetailLoading(true);
    update();
  }

  // Stop Detail Loading
  stopDetailLoading(){
    isDetailLoading(false);
    update();
  }

  // Get Movies List
  getMoviesList() async {
    try {
      startLoading();
      var response = await ApiRepo.apiGet(movieListUrl);
      if(response != null) {
        moviesList = response['results'];
        stopLoading();
      }
    } catch (e) {
      stopLoading();
    } finally{
      stopLoading();
    }
  }

  //movie list pagination
  getPagination() async{
    try {
      startPageLoading();
      var response = await ApiRepo.apiGet("$movieListUrl?page=$pageNum&sort_by=popularity.desc&include_adult=true");
      if(response != null) {
        moviesList.addAll(response['results']);
      }
    } catch (e) {
      log(e.toString());
    } finally{
      stopPageLoading();
    }
  }


  //movies detail
  getMoviesDetail(id) async{
    try {
      startDetailLoading();
      var response = await ApiRepo.apiGet("$movieDetailUrl/$id");
      if(response != null) {
        final allData = MovieDetailModel.fromJson(response);
        moviesDetail = allData;
      }
    } catch (e) {
      log(e.toString());
    } finally{
      stopDetailLoading();
    }
  }

}