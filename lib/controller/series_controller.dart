

import 'dart:developer';

import 'package:cuplex/apiConfig/api_repo.dart';
import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/model/series_model.dart';
import 'package:get/get.dart';

class SeriesController extends GetxController{
  late RxBool isLoading = false.obs;
  late RxBool isPageLoading = false.obs;
  late RxBool isDetailLoading = false.obs;
  late RxBool isEpisodeLoading = false.obs;
  int pageNum = 0;
  dynamic seriesList = [];
  dynamic episodeList = [];
  dynamic seriesDetail;


  // Get Series List
  getSeriesList() async {
    try {
      isLoading(true);
      var response = await ApiRepo.apiGet(showListUrl);
      if(response != null) {
        seriesList = response['results'];
        isLoading(false);
      }
    } catch (e) {
      isLoading(false);
    } finally{
      isLoading(false);
    }
  }

  //series list pagination
  getPagination() async{
    try {
      isPageLoading(true);
      var response = await ApiRepo.apiGet("$showListUrl?page=$pageNum&sort_by=popularity.desc&include_adult=true");
      if(response != null) {
        seriesList.addAll(response['results']);
      }
    } catch (e) {
      log(e.toString());
    } finally{
      isPageLoading(false);
    }
  }


  //series detail
  getSeriesDetail(id) async{
    try {
      isDetailLoading(true);
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
      var response = await ApiRepo.apiGet("$showDetailUrl/$seriesId?api_key=$apiKey&append_to_response=season/$seasonNo");
      if(response != null) {
        episodeList = response;
      }
    } catch (e) {
      log(e.toString());
    } finally{
      isEpisodeLoading(false);
    }
  }

}