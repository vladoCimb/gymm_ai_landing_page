import 'package:flutter/material.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/user_review_card.dart';

class UserReview {
  final String name;
  final String review;
  const UserReview(this.name, this.review);
}

class UserReviewsCarousel extends StatefulWidget {
  const UserReviewsCarousel({super.key, required this.isMobile});

  final bool isMobile;

  @override
  State<UserReviewsCarousel> createState() => _UserReviewsCarouselState();
}

class _UserReviewsCarouselState extends State<UserReviewsCarousel> {
  final ScrollController _scrollController = ScrollController();

  // base reviews (logical list)
  final List<UserReview> _reviews = const [
    UserReview('Slavo', '“Great app, improved my quality of life.”'),
    UserReview('Martin', '“Improved my fitness game!”'),
    UserReview('Jakub', '“Best workout tracker I’ve used.”'),
    UserReview('Lucia', '“I finally understand what I was doing wrong.”'),
    UserReview('Peter', '“Love how fast I get feedback.”'),
    UserReview('Jana', '“Amazing AI feedback on my posture.”'),
    UserReview('Adam', '“Makes working out more fun.”'),
    UserReview('Klara', '“Beautiful interface, easy to use.”'),
    UserReview('Tom', '“Spot-on tips every time.”'),
    UserReview('Eva', '“It feels like a real coach watching me.”'),
    UserReview('Slavo', '“Great app, improved my quality of life.”'),
    UserReview('Tom', '“Spot-on tips every time.”'),
  ];

  late final List<UserReview> _loopedReviews;

  // index in the looped list of the **first fully visible** card
  late int _currentIndex;

  double? _itemExtent; // width of a single item (card)
  bool _initializedScroll = false;

  int get _visibleCount => widget.isMobile ? 1 : 3; // 3 fully visible cards
  static const double _sidePeekFraction = 0.25; // 1/4 of card on each side

  @override
  void initState() {
    super.initState();

    // make an "infinite" list: prev copy + current copy + next copy
    _loopedReviews = [..._reviews, ..._reviews, ..._reviews];

    // start in the *middle* copy so we can loop both ways
    _currentIndex = _reviews.length; // first item of middle copy
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _offsetForIndex(int index) {
    // We want 3 full cards + 1/4 on both sides.
    // This means the viewport starts 0.25 * itemWidth *before* the first full card.
    return (_itemExtent! * (index - _sidePeekFraction));
  }

  void _fixIndexForInfiniteLooping() {
    if (_itemExtent == null) return;

    final int len = _reviews.length;
    final int minIndex = len; // start of middle copy
    final int maxIndex = 2 * len - 1; // end of middle copy

    if (_currentIndex > maxIndex) {
      // went too far right → wrap back by one logical length
      setState(() {
        _currentIndex -= len;
      });
      _scrollController.jumpTo(_offsetForIndex(_currentIndex));
    } else if (_currentIndex < minIndex) {
      // went too far left → wrap forward by one logical length
      setState(() {
        _currentIndex += len;
      });
      _scrollController.jumpTo(_offsetForIndex(_currentIndex));
    }
  }

  void _next() {
    if (_itemExtent == null) return;
    setState(() {
      _currentIndex++;
    });

    _scrollController
        .animateTo(
          _offsetForIndex(_currentIndex),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        )
        .then((_) => _fixIndexForInfiniteLooping());
  }

  void _prev() {
    if (_itemExtent == null) return;
    setState(() {
      _currentIndex--;
    });

    _scrollController
        .animateTo(
          _offsetForIndex(_currentIndex),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        )
        .then((_) => _fixIndexForInfiniteLooping());
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          // Carousel area
          SizedBox(
            height: 263 + 37, // match card height
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double viewportWidth = constraints.maxWidth;

                // 3 full + 0.25 left + 0.25 right = 3.5 cards visible
                final double cardWidth =
                    viewportWidth / (_visibleCount + 2 * _sidePeekFraction);

                _itemExtent = cardWidth;

                // Initial positioning: show 3 full + peeks
                if (!_initializedScroll && _itemExtent != null) {
                  _initializedScroll = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!_scrollController.hasClients) return;
                    _scrollController.jumpTo(_offsetForIndex(_currentIndex));
                  });
                }

                const double edgeFadeWidth = 100.0;

                return ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (rect) {
                    final start = edgeFadeWidth / rect.width;
                    final end = 1 - start;
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: const [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        Colors.transparent,
                      ],
                      stops: [0.0, start, end, 1.0],
                    ).createShader(rect);
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _loopedReviews.length,
                    itemBuilder: (context, index) {
                      final review = _loopedReviews[index];
                      return SizedBox(
                        width: cardWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: UserReviewCard(
                            name: review.name,
                            review: review.review,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 46),

          // Arrows
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleArrowButton(
                  icon: Icons.chevron_left,
                  enabled: true,
                  onPressed: _prev,
                ),
                const SizedBox(width: 8),
                CircleArrowButton(
                  icon: Icons.chevron_right,
                  enabled: true,
                  onPressed: _next,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircleArrowButton extends StatelessWidget {
  const CircleArrowButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color.fromRGBO(20, 22, 25, 1);
    final iconColor =
        enabled ? Colors.white : const Color.fromRGBO(108, 108, 108, 1);

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        customBorder: const CircleBorder(),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
      ),
    );
  }
}
