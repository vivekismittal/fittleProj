
abstract class BaseApiServices{


  Future<dynamic> postApiResponse(String url, dynamic data,{bool isSearch=false});

  Future<dynamic> getApiResponse(String url);

}