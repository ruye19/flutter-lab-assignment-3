import 'package:flutter/material.dart';
import '../../../../models/album.dart';
import '../../../../models/photo.dart';
import '../../../../data/repositories/album_repository.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Album album;
  final AlbumRepository _repository = AlbumRepository();

  AlbumDetailScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Album ${album.id} Details")),
      body: FutureBuilder<List<Photo>>(
        future: _repository.fetchPhotosByAlbumId(album.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load photos."));
          }

          final photos = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final p = photos[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    p.thumbnailUrl,
                    width: 100,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
                title: Text(p.title),
              );
            },
          );
        },
      ),
    );
  }
}
