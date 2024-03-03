import 'dart:convert';
import '../handlers/endpoints.dart';
import '../handlers/response_channel.dart';
import '../models/responseModels/news_response_model.dart';

class SearchNewsRepo {
  ApiEndpoints apiEndpoints = ApiEndpoints();
  final ResponseChannel _responseChannel = ResponseChannel();

  Future<NewsResponseModel> searchewsRequest(String search) async {
    final response = await _responseChannel
        .doGet(apiEndpoints.searchNews(search));

    print("News api response ------> $response");

    Map<String, dynamic> dynamicResponse = json.decode(response);

    return NewsResponseModel.fromJson(dynamicResponse);
  }
}
