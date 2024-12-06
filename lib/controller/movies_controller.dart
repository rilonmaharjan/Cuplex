

import 'dart:developer';

import 'package:cuplex/apiConfig/api_repo.dart';
import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/controller/search_movie_controller.dart';
import 'package:cuplex/model/movies_model.dart';
import 'package:cuplex/model/top_movies_model.dart';
import 'package:get/get.dart';

class MoviesController extends GetxController{
  final SearchMovieController searchCon = Get.put(SearchMovieController());
  late RxBool isLoading = true.obs;
  late RxBool isTrendingMoviesLoading = true.obs;
  late RxBool isTopRatedMoviesLoading = true.obs;
  late RxBool isPageLoading = true.obs;
  late RxBool isDetailLoading = true.obs;
  int pageNum = 1;
  int prevPageNum = 1;
  int bestPageNum = 1;
  int bestPrevPageNum = 1;
  dynamic moviesList = [];
  dynamic moviesDetail;
  dynamic trendingMovieList = [].obs;
  dynamic topRatedMovies = [].obs;
  dynamic bestMoviesList = [].obs;

  // Get Movies List
  getMoviesList() async {
    try {
      isLoading(true);
      var response = await ApiRepo.apiGet(movieListUrl);
      if(response != null) {
        moviesList = response['results'];
      }
    } catch (e) {
      log(e.toString());
    } finally{
      isLoading(false);
    }
  }

  //movie list pagination
  getPagination() async{
    try {
      var response = await ApiRepo.apiGet("$movieListUrl?page=$pageNum&sort_by=popularity.desc&include_adult=${searchCon.isAdult}");
      if(response != null) {
        prevPageNum = pageNum;
        moviesList.addAll(response['results']);
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

  // Get Trending Movies List
  getTrendingMoviesList() async {
    try {
      isTrendingMoviesLoading(true);
      var response = await ApiRepo.apiGet(trendingMovieUrl);
      if(response != null) {
        trendingMovieList.value = response['results'];
      }
    } catch (e) {
      log('Error fetching trending movies: $e');
    } finally {
      isTrendingMoviesLoading(false);
    }
  }

  // Get Top Rated Movies
  getTopRatedMovies() async {
    try {
      isTopRatedMoviesLoading(true);
      var response = await ApiRepo.apiGet(
        'https://api.themoviedb.org/3/movie/top_rated',
      );
      if (response != null) {
        topRatedMovies.value = (response['results'] as List)
            .map((item) => TopRatedMoviesModel.fromJson(item))
            .toList();
        isTopRatedMoviesLoading(false);
      }
    } catch (e) {
      log('Error fetching top rated movies: $e');
    } finally {
      isTopRatedMoviesLoading(false);
    }
  }

  getBestMoviesList() async {
    try {
      isLoading(true);
      var response = await ApiRepo.apiGet(movieListUrl);
      if(response != null) {
        bestMoviesList = response['results'];
      }
    } catch (e) {
      log(e.toString());
    } finally{
      isLoading(false);
    }
  }

    //movie list pagination
  getBestPagination() async{
    try {
      var response = await ApiRepo.apiGet("$movieListUrl?page=$bestPageNum&sort_by=popularity.desc&include_adult=true");
      if(response != null) {
        bestPrevPageNum = bestPageNum;
        if(response["page"] == response["total_pages"]){
          isPageLoading(false);
        }
        for(var bestList in response['results']){
          if(bestList['adult'] == true){
            bestMoviesList.add(bestList);
          }
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