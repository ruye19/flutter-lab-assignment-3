import 'package:go_router/go_router.dart';
import '../../models/album.dart';
import '../../features/album/presentation/screens/album_list_screen.dart';
import '../../features/album/presentation/screens/album_detail_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AlbumListScreen(),
      ),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          final album = state.extra as Album;
          return AlbumDetailScreen(album: album);
        },
      ),
    ],
  );
}
