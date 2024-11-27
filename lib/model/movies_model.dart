// To parse this JSON data, do
//
//     final movieDetailModel = movieDetailModelFromJson(jsonString);

import 'dart:convert';

MovieDetailModel movieDetailModelFromJson(String str) => MovieDetailModel.fromJson(json.decode(str));

String movieDetailModelToJson(MovieDetailModel data) => json.encode(data.toJson());

class MovieDetailModel {
    bool? adult;
    String? backdropPath;
    dynamic belongsToCollection;
    int? budget;
    List<Genre>? genres;
    String? homepage;
    int? id;
    String? imdbId;
    String? originalLanguage;
    String? originalTitle;
    String? overview;
    double? popularity;
    String? posterPath;
    List<ProductionCompany>? productionCompanies;
    String? releaseDate;
    int? revenue;
    int? runtime;
    String? status;
    String? tagline;
    String? title;
    bool? video;
    double? voteAverage;
    int? voteCount;

    MovieDetailModel({
        this.adult,
        this.backdropPath,
        this.belongsToCollection,
        this.budget,
        this.genres,
        this.homepage,
        this.id,
        this.imdbId,
        this.originalLanguage,
        this.originalTitle,
        this.overview,
        this.popularity,
        this.posterPath,
        this.productionCompanies,
        this.releaseDate,
        this.revenue,
        this.runtime,
        this.status,
        this.tagline,
        this.title,
        this.video,
        this.voteAverage,
        this.voteCount,
    });

    factory MovieDetailModel.fromJson(Map<String, dynamic> json) => MovieDetailModel(
        adult: json["adult"] ?? "",
        backdropPath: json["backdrop_path"] ?? "",
        belongsToCollection: json["belongs_to_collection"] ?? "",
        budget: json["budget"] ?? "",
        genres: json["genres"] == null ? [] : List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
        homepage: json["homepage"] ?? "",
        id: json["id"],
        imdbId: json["imdb_id"] ?? "",
        originalLanguage: json["original_language"] ?? "",
        originalTitle: json["original_title"] ?? "",
        overview: json["overview"] ?? "",
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"] ?? "",
        productionCompanies: json["production_companies"] == null ? [] : List<ProductionCompany>.from(json["production_companies"].map((x) => ProductionCompany.fromJson(x))),
        releaseDate: json["release_date"] ?? "",
        revenue: json["revenue"] ?? 0,
        runtime: json["runtime"] ?? 0,
        status: json["status"] ?? "",
        tagline: json["tagline"] ?? "",
        title: json["title"] ?? "",
        video: json["video"] ?? "",
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "belongs_to_collection": belongsToCollection,
        "budget": budget,
        "genres": List<dynamic>.from(genres!.map((x) => x.toJson())),
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "production_companies": List<dynamic>.from(productionCompanies!.map((x) => x.toJson())),
        "release_date": releaseDate,
        "revenue": revenue,
        "runtime": runtime,
        "status": status,
        "tagline": tagline,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };
}

class Genre {
    int? id;
    String? name;

    Genre({
        this.id,
        this.name,
    });

    factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class ProductionCompany {
    int? id;
    String? logoPath;
    String? name;
    String? originCountry;

    ProductionCompany({
        this.id,
        this.logoPath,
        this.name,
        this.originCountry,
    });

    factory ProductionCompany.fromJson(Map<String, dynamic> json) => ProductionCompany(
        id: json["id"],
        logoPath: json["logo_path"],
        name: json["name"],
        originCountry: json["origin_country"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "logo_path": logoPath,
        "name": name,
        "origin_country": originCountry,
    };
}
