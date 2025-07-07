import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import '../core.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  Color _backgroundColor = Constants.alternateBlack;
  Color _originalBackgroundColor = Constants.alternateBlack;
  bool _hasGeneratedBackgroundColor = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Update app bar background visibility
    if (_scrollController.offset > 15 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 0 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }

    // Update background color based on scroll position
    _updateBackgroundColorOnScroll();
  }

  void _updateBackgroundColorOnScroll() {
    if (!_scrollController.hasClients) return;

    const double maxScrollForTransition = 250;
    double scrollOffset = _scrollController.offset.clamp(
      0.0,
      maxScrollForTransition,
    );

    double progress = scrollOffset / maxScrollForTransition;

    const Color targetColor = Colors.black;

    // Interpolate between original color and black
    Color newBackgroundColor =
        Color.lerp(_originalBackgroundColor, targetColor, progress) ??
        _originalBackgroundColor;

    setState(() {
      _backgroundColor = newBackgroundColor;
    });
  }

  Future<void> _generateBackgroundColor(Show featuredShow) async {
    if (_hasGeneratedBackgroundColor) return;

    try {
      if (featuredShow.imageUrl.isEmpty) {
        _setDefaultBackgroundColor();
        return;
      }

      // Generate palette from the image
      final imageProvider = NetworkImage(featuredShow.imageUrl);
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        imageProvider,
        maximumColorCount: 16,
      );

      final colors = [
        paletteGenerator.vibrantColor?.color,
        paletteGenerator.lightVibrantColor?.color,
        paletteGenerator.darkVibrantColor?.color,
        paletteGenerator.mutedColor?.color,
        paletteGenerator.lightMutedColor?.color,
        paletteGenerator.darkMutedColor?.color,
        paletteGenerator.dominantColor?.color,
      ].whereType<Color>().toList();

      if (colors.isNotEmpty) {
        final backgroundColor = _calculateOptimalBackgroundColor(colors);
        _setBackgroundColor(backgroundColor);
      } else {
        _setDefaultBackgroundColor();
      }
    } catch (e) {
      _setDefaultBackgroundColor();
    }
  }

  Color _calculateOptimalBackgroundColor(List<Color> colors) {
    // Find the brightest color by converting to HSV and checking the brightness
    Color brightestColor = colors.first;
    double maxBrightness = 0.0;

    for (final color in colors) {
      final hsv = HSVColor.fromColor(color);
      if (hsv.value > maxBrightness) {
        maxBrightness = hsv.value;
        brightestColor = color;
      }
    }

    // Make it brighter for background use but keep some of the original color
    return Color.fromRGBO(
      (brightestColor.r * 127.5).round().clamp(80, 180),
      (brightestColor.g * 127.5).round().clamp(80, 180),
      (brightestColor.b * 127.5).round().clamp(80, 180),
      1.0,
    );
  }

  void _setBackgroundColor(Color backgroundColor) {
    if (mounted) {
      setState(() {
        _originalBackgroundColor = backgroundColor;
        _backgroundColor = backgroundColor;
        _hasGeneratedBackgroundColor = true;
      });
    }
  }

  void _setDefaultBackgroundColor() {
    if (mounted) {
      setState(() {
        _originalBackgroundColor = Constants.alternateBlack;
        _backgroundColor = Constants.alternateBlack;
        _hasGeneratedBackgroundColor = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCoreCubit, AppCoreState>(
      listener: (context, state) {
        if (state is AppCoreInitialized && !_hasGeneratedBackgroundColor) {
          // generate background color based on featured show
          _generateBackgroundColor(state.appData.featuredShow);
        } else if (state is AppCoreError && !_hasGeneratedBackgroundColor) {
          // use default colors if there's an error loading data
          _setDefaultBackgroundColor();
        }
      },
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: _isScrolled
                  ? Colors.black.withValues(alpha: 0.8)
                  : Colors.transparent,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Icon(Icons.movie, color: Colors.red, size: 28),
              ),
              leadingWidth: 36,
              title: Text(
                Constants.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white, size: 26),
                  onPressed: () {},
                ),
              ],
            ),
            SliverToBoxAdapter(child: const HomeContent()),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCoreCubit, AppCoreState>(
      builder: (context, state) {
        if (state is AppCoreInitializing) {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        } else if (state is AppCoreError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else if (state is AppCoreInitialized) {
          final featuredShow = state.appData.featuredShow;
          final List<Category> categories = state.appData.categories;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Featured content banner
              FeaturedBanner(featuredShow: featuredShow),
              const SizedBox(height: 20),

              // category-shows list
              ...categories.map((category) {
                return ShowsDisplay(
                  catTitle: category.title,
                  shows: category.shows,
                );
              }),

              const SizedBox(height: 22),
            ],
          );
        } else {
          return Center(child: Text(Constants.welcomeToStreamy));
        }
      },
    );
  }
}
