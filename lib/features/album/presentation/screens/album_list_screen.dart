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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Albums",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Album>>(
        future: _albumsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Failed to load albums.",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _albumsFuture = _repository.fetchAlbums();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          }

          final albums = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              final photo = _albumThumbnails[album.id];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      context.push('/detail', extra: album);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Album thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: photo != null
                                ? Image.network(
                              photo.thumbnailUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.broken_image),
                                  ),
                            )
                                : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Icon(Icons.album),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Album title
                          Expanded(
                            child: Text(
                              album.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Forward arrow
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}