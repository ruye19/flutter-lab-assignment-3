import '../../core/network/api_client.dart';
import '../../core/network/dio_provider.dart';
import '../../models/album.dart';
import '../../models/photo.dart';

class AlbumRepository {
  final ApiClient _apiClient = ApiClient(DioProvider.createDio());

  Future<List<Album>> fetchAlbums() => _apiClient.getAlbums();

  Future<List<Photo>> fetchPhotosByAlbumId(int albumId) =>
      _apiClient.getPhotosByAlbumId(albumId);
}
