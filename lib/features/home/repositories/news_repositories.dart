import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_imagekit/flutter_imagekit.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:news_application/core/services/isar_database_service.dart';
import 'package:news_application/features/home/models/article_model.dart';
import 'package:news_application/features/home/models/news_model.dart';
import 'package:news_application/features/utils/app_texts.dart';
import 'package:news_application/features/utils/constants.dart';

class NewsRepositories {
  final IsarDatabaseService databaseService = IsarDatabaseService();
  Future fetchNews({String? country, String? category}) async {
    final String apiKey = Constants.key;

    final String type =
        country == null ? "category=$category" : "country=$country";
    final String url =
        'https://newsapi.org/v2/top-headlines?$type&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final allNews = NewsModel.fromJson(data);
        return allNews.articles;
      } else {
        log('Error: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      log('Exception $e');
      return null;
    }
  }

  Future<List<Article>> setAndGetNews(
      {String? country, String? category, bool isTesla = false}) async {
    final String filterBy = country ?? category ?? AppTexts.tesla;
    List<Article> newsFromAPI = await databaseService.getAllArticles(
        getCategory: filterBy, isFromAPI: true);
    List<Article> newsAddedByUser = await databaseService.getAllArticles(
        getCategory: filterBy, isFromAPI: false);
    if (newsFromAPI.isEmpty && !isTesla) {
      newsFromAPI = await fetchNews(
        category: category,
        country: country,
      );
    } else if (newsFromAPI.isEmpty && isTesla) {
      newsFromAPI = await getTeslaNews();
    }
    await databaseService.saveArticles(
      articles: newsAddedByUser + newsFromAPI,
      category: filterBy,
    );
    return newsAddedByUser + newsFromAPI;
  }

  Future<String> getImageLink() async {
    String imageLink = '';
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File file = File(image.path);
      try {
        await ImageKit.io(file, privateKey: Constants.imageKitKey).then(
          (link) {
            imageLink = link;
          },
        );
      } catch (e) {
        log('error $e');
      }
    }
    return imageLink;
  }

  Future<List<Article>> getTeslaNews({String? query}) async {
    final String apiKey = Constants.key;
    final String url =
        "https://newsapi.org/v2/everything?q=tesla&apiKey=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final allNews = NewsModel.fromJson(data);
        return allNews.articles ?? [];
      }
      return [];
    } catch (e) {
      log('error on getNewsByQuery $e');
      return [];
    }
  }
}
