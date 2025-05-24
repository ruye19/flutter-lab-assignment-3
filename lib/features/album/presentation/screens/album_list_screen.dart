import 'package:flutter/material.dart';
import '../../../../data/repositories/album_repository.dart';
import '../../../../models/album.dart';
import '../../../../models/photo.dart';
import 'package:go_router/go_router.dart';

class AlbumListScreen extends StatefulWidget {
  const AlbumListScreen({super.key});

  @override
  State<AlbumListScreen> createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  final AlbumRepository _repository = AlbumRepository();
  late Future<List<Album>> _albumsFuture;
  final Map<int, Photo> _albumThumbnails = {};

  @override
  void initState() {
    super.initState();
    _albumsFuture = _repository.fetchAlbums();
    _albumsFuture.then((albums) async {
      for (var album in albums) {
        final photos = await _repository.fetchPhotosByAlbumId(album.id);
        if (photos.isNotEmpty) {
          _albumThumbnails[album.id] = photos.first;
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Albums")),
      body: FutureBuilder<List<Album>>(
        future: _albumsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Failed to load albums."),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _albumsFuture = _repository.fetchAlbums();
                      });
                    },
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          }

          final albums = snapshot.data!;
          return ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              final photo = _albumThumbnails[album.id];

              return ListTile(
                title: Text(album.title),
                leading: photo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          photo.thumbnailUrl,
                          width: 100,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        ),
                      )
                    : Container(
                        width: 100,
                        height: 60,
                        color: Colors.grey,
                        child: const Icon(Icons.image),
                      ),
                onTap: () {
                  context.push('/detail', extra: album);
                },
              );
            },
          );
        },
      ),
    );
  }
}
