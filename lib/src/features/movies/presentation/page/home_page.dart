// SRP: This page is solely responsible for composing the tabs and routing.
// Each tab's content is its own widget — this file has one reason to change.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenge_pinapp/src/core/remote_config/remote_config_service.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/popular_movies_notifier.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/trending_movies_notifier.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/widgets/error_state_widget.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/widgets/movie_grid_widget.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/page/movie_detail_page.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/page/search_page.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_entity.dart';

// TODO: review cawu example
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  static const routeName = '/home';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToDetail(MovieEntity movie) {
    Navigator.of(
      context,
    ).pushNamed(MovieDetailPage.routeName, arguments: movie.id);
  }

  @override
  Widget build(BuildContext context) {
    // Read Remote Config flags once per build — zero network cost after Splash.
    final remoteConfig = ref.read(remoteConfigServiceProvider);
    final isSearchEnabled = remoteConfig.isSearchEnabled;
    final bannerText = remoteConfig.welcomeBannerText;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: const Color(0xFF0D0D0D),
              elevation: 0,
              pinned: false,
              floating: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PinApp Movies',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  // welcome_banner_text flag — empty string hides the subtitle.
                  if (bannerText.isNotEmpty)
                    Text(
                      bannerText,
                      style: const TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
              // is_search_enabled flag — hides the search icon when false.
              actions: [
                if (isSearchEnabled)
                  IconButton(
                    icon: const Icon(Icons.search_rounded, color: Colors.white),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(SearchPage.routeName),
                  ),
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFFE50914),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF888888),
                  tabs: const [
                    Tab(text: 'Popular'),
                    Tab(text: 'Trending'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _PopularTab(onMovieTap: _navigateToDetail),
            _TrendingTab(onMovieTap: _navigateToDetail),
          ],
        ),
      ),
    );
  }
}

// ── Tab widgets ───────────────────────────────────────────────────────────────

class _PopularTab extends ConsumerWidget {
  final void Function(MovieEntity) onMovieTap;
  const _PopularTab({required this.onMovieTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(popularMoviesProvider);
    return state.when(
      data: (movies) => MovieGridWidget(
        movies: movies,
        onMovieTap: onMovieTap,
        onLoadMore: () =>
            ref.read(popularMoviesProvider.notifier).loadNextPage(),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFFE50914)),
      ),
      error: (e, _) => ErrorStateWidget(
        message: e.toString(),
        onRetry: () => ref.read(popularMoviesProvider.notifier).refresh(),
      ),
    );
  }
}

class _TrendingTab extends ConsumerWidget {
  final void Function(MovieEntity) onMovieTap;
  const _TrendingTab({required this.onMovieTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trendingMoviesProvider);
    return state.when(
      data: (movies) => MovieGridWidget(movies: movies, onMovieTap: onMovieTap),
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFFE50914)),
      ),
      error: (e, _) => ErrorStateWidget(
        message: e.toString(),
        onRetry: () => ref.read(trendingMoviesProvider.notifier).refresh(),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: const Color(0xFF0D0D0D), child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
