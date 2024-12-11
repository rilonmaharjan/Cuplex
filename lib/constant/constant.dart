const String apiKey = 'Your API key here';
const String bearerToken = 'Bearer Token here';

const String baseUrl = 'https://api.themoviedb.org/3';

// MOVIES
const String movieListUrl = '$baseUrl/discover/movie';
const String movieDetailUrl = '$baseUrl/movie';
const String searchMovieUrl = '$baseUrl/search/movie';

//SHOWS
const String showListUrl = '$baseUrl/discover/tv';
const String showDetailUrl = '$baseUrl/tv';
const String searchShowUrl = '$baseUrl/search/tv';


// video embed url
const String movieEmbedUrl = 'https://vidsrc.xyz/embed/movie';
const String showEmbedUrl = 'https://vidsrc.xyz/embed/tv';

//MISC 
const String posterUrl = 'https://image.tmdb.org/t/p/original';

//Trending
const String trendingMovieUrl = "https://api.themoviedb.org/3/trending/movie/day";
const String trendingSeriesUrl = "https://api.themoviedb.org/3/trending/tv/day";