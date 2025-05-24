import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../../../models/album.dart';
import '../../../models/photo.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/albums")
  Future<List<Album>> getAlbums();

  @GET("/photos")
  Future<List<Photo>> getPhotos();

  @GET("/photos")
  Future<List<Photo>> getPhotosByAlbumId(@Query("albumId") int albumId);
}
