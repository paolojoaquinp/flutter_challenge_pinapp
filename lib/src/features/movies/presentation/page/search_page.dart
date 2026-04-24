// SRP: This page is solely responsible for the search UX —
// accepting user input and displaying results.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/page/movie_detail_page.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/movie_search_notifier.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/widgets/error_state_widget.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/widgets/movie_grid_widget.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});
  static const routeName = '/search';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(movieSearchProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search movies…',
            hintStyle: const TextStyle(color: Color(0xFF555555)),
            border: InputBorder.none,
            suffixIcon: searchState.hasValue && (searchState.value?.isNotEmpty ?? false)
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, color: Color(0xFF888888)),
                    onPressed: () => ref.read(movieSearchProvider.notifier).clearSearch(),
                  )
                : null,
          ),
          onChanged: (query) =>
              ref.read(movieSearchProvider.notifier).search(query),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: searchState.when(
        data: (movies) {
          if (movies.isEmpty) {
            return const Center(
              child: Text(
                'Search for a movie…',
                style: TextStyle(color: Color(0xFF555555), fontSize: 15),
              ),
            );
          }
          return MovieGridWidget(
            movies: movies,
            onMovieTap: (movie) => Navigator.of(context)
                .pushNamed(MovieDetailPage.routeName, arguments: movie.id),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFE50914)),
        ),
        error: (e, _) => ErrorStateWidget(message: e.toString()),
      ),
    );
  }
}
