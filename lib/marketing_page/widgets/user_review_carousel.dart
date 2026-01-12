import 'package:flutter/material.dart';
import 'package:gymm_ai_landing_page/main.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/user_review_card.dart';

class UserReview {
  final String name;
  final String review;
  final String urlLink;

  const UserReview(
    this.name,
    this.review,
    this.urlLink,
  );
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
    UserReview(
      'Simon',
      '“Clean design and surprisingly accurate analysis.”',
      'https://x.com/simonricoo',
    ),
    UserReview(
      'Jakub',
      '“Upload video, get feedback, improve. Simple and effective.”',
      'https://x.com/Jakubantalik',
    ),
    UserReview(
      'Vlad',
      '“The feedback is precise and easy to understand, especially for beginners.”',
      'https://x.com/cimbora_v',
    ),
    UserReview(
      'Alex',
      '“Finally understood why some exercises felt wrong, the feedback made it clear.”',
      'https://x.com/a_brinza',
    ),
    UserReview(
      'Tatiana',
      '“I like that I can train alone and still get real feedback on my excercises.”',
      'https://x.com/TatianaVybostok',
    ),
    UserReview(
      'Slavo',
      '“Simple to use and the feedback is clear.”',
      'https://x.com/slavomier',
    ),
    UserReview(
      'Jana',
      '“Way more helpful than just watching myself in the mirror.”',
      'https://x.com/cimbora_v',
    ),
    UserReview(
      'Adam',
      '“Caught smaller mistakes I’ve been repeating for years.”',
      'https://x.com/cimbora_v',
    ),
    UserReview(
      'Klara',
      '“Simple to use and the feedback is clear.”',
      'https://x.com/cimbora_v',
    ),
    UserReview(
      'Tom',
      '“Spot-on tips every time.”',
      'https://x.com/cimbora_v',
    ),
    UserReview(
      'Eva',
      '“It feels like a real coach watching me.”',
      'https://x.com/cimbora_v',
    ),
    UserReview(
      'Tom',
      '“Honestly didn’t expect it to catch that much.”',
      'https://x.com/cimbora_v',
    ),
  ];

  late final List<UserReview> _loopedReviews;

  // index in the looped list of the **first fully visible** card
  late int _currentIndex;

  double? _itemExtent; // width of a single item (card)
  bool _initializedScroll = false;

  int _getVisibleCount(BuildContext context) => widget.isMobile
      ? 1
      : (isTablet(context) ? 2 : 3); // 2 for tablet, 3 for desktop
  double get _sidePeekFraction =>
      widget.isMobile ? 0.35 : 0.25; // 1/4 of card on each side

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
                final visibleCount = _getVisibleCount(context);

                // 3 full + 0.25 left + 0.25 right = 3.5 cards visible (or 2 + peeks for tablet)
                final double cardWidth =
                    viewportWidth / (visibleCount + 2 * _sidePeekFraction);

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
                            urlLink: review.urlLink,
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
