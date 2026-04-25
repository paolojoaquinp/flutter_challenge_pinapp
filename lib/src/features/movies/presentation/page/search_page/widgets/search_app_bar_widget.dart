import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/movie_search_notifier.dart';

class SearchAppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  const SearchAppBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(movieSearchProvider);

    return AppBar(
      backgroundColor: const Color(0xFF0D0D0D),
      elevation: 0,
      title: TextField(
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search movies…',
          hintStyle: const TextStyle(color: Color(0xFF555555)),
          border: InputBorder.none,
          suffixIcon:
              searchState.hasValue && (searchState.value?.isNotEmpty ?? false)
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: Color(0xFF888888),
                  ),
                  onPressed: () =>
                      ref.read(movieSearchProvider.notifier).clearSearch(),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
