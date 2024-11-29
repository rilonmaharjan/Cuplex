

import 'dart:developer';

import 'package:cuplex/apiConfig/api_repo.dart';
import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/model/series_model.dart';
import 'package:cuplex/model/top_series_model.dart';
import 'package:get/get.dart';

class SeriesController extends GetxController{
  late RxBool isLoading = true.obs;
  late RxBool isTrendingSeriesLoading = true.obs;
  late RxBool isTopRatedSeriesLoading = true.obs;
  late RxBool isPageLoading = true.obs;
  late RxBool isDetailLoading = true.obs;
  late RxBool isEpisodeLoading = false.obs;
  int pageNum = 0;
  dynamic seriesList = [];
  dynamic episodeList = [];
  dynamic seriesDetail;
  dynamic trendingSeriesList = [].obs;
  var topRatedSeries = [].obs;

  // Get Series List
  getSeriesList() async {
    try {
      isLoading(true);
      var response = await ApiRepo.apiGet(showListUrl);
      if(response != null) {
        seriesList = response['results'];
      }
    } catch (e) {
      log(e.toString());
    } finally{
      isLoading(false);
    }
  }

  //series list pagination
  getPagination() async{
    try {
      var response = await ApiRepo.apiGet("$showListUrl?page=$pageNum&sort_by=popularity.desc&include_adult=true");
      if(response != null) {
        seriesList.addAll(response['results']);
        if(response["page"] == response["total_pages"]){
          isPageLoading(false);
        }
      }else{
        isPageLoading(false);
      }
    } catch (e) {
      log(e.toString());
    }
  }


  //series detail
  getSeriesDetail(id) async{
    try {
      isDetailLoading(true);
      episodeList.clear();
      var response = await ApiRepo.apiGet("$showDetailUrl/$id");
      if(response != null) {
        final allData = SeriesDetailModel.fromJson(response);
        seriesDetail = allData;
      }
    } catch (e) {
      log(e.toString());
    } finally{
      isDetailLoading(false);
    }
  }

  //getEpisodelist
  getEpisodeList(seriesId, seasonNo) async{
    try {
      isEpisodeLoading(true);
      episodeList.clear();
      var response = await ApiRepo.apiGet("$showDetailUrl/$seriesId?api_key=$apiKey&append_to_response=season/$seasonNo");
      if(response != null) {
        episodeList = response["season/$seasonNo"]["episodes"];
      }
    } catch (e) {
      log(e.toString());
    } finally{
      isEpisodeLoading(false);
    }
  }

  // Get Trending Series List
  getTrendingSeriesList() async {
    try {
      isTrendingSeriesLoading(true);
      var response = await ApiRepo.apiGet(trendingSeriesUrl);
      if(response != null) {
        trendingSeriesList.value = response['results'];
        isTrendingSeriesLoading(false);
      }
    } catch (e) {
      log('Error fetching trending series: $e');
    } finally {
      isTrendingSeriesLoading(false);
    }
  }

  
  // Get Top Rated Series from API
  getTopRatedSeries() async {
    try {
      isTopRatedSeriesLoading(true);

      // Fetch data from the API
      var response = await ApiRepo.apiGet(
        'https://api.themoviedb.org/3/tv/top_rated',
      );
      if (response != null) {
        topRatedSeries.value = (response['results'] as List)
          .map((item) => TopRatedSeriesModel.fromJson(item))
          .toList();
      }
    } catch (e) {
      log('Error fetching top rated series: $e');
    } finally {
      isTopRatedSeriesLoading(false);
    }
  }


}