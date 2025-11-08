import 'package:flutter/material.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/user_review_card.dart';

class UserReview {
  final String name;
  final String review;
  const UserReview(this.name, this.review);
}

class UserReviewsCarousel extends StatefulWidget {
  const UserReviewsCarousel({super.key});

  @override
  State<UserReviewsCarousel> createState() => _UserReviewsCarouselState();
}

class _UserReviewsCarouselState extends State<UserReviewsCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 👇 example reviews
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < (_reviews.length / 3).ceil() - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _prev() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (_reviews.length / 3).ceil();

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          // Carousel area
          SizedBox(
            height: 263 + 37, // match card height
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: totalPages,
              itemBuilder: (context, pageIndex) {
                final start = pageIndex * 3;
                final end =
                    (start + 3) > _reviews.length ? _reviews.length : start + 3;
                final visibleReviews = _reviews.sublist(start, end);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var review in visibleReviews) ...[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: UserReviewCard(
                            name: review.name,
                            review: review.review,
                          ),
                        ),
                      ),
                    ],
                  ],
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleArrowButton(
                  icon: Icons.chevron_left,
                  enabled: _currentPage > 0,
                  onPressed: _prev,
                ),
                const SizedBox(width: 8),
                CircleArrowButton(
                  icon: Icons.chevron_right,
                  enabled: _currentPage < totalPages - 1,
                  onPressed: _next,
                ),
              ],
            ),
          )
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
    final iconColor = enabled ? Colors.white : Color.fromRGBO(108, 108, 108, 1);

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
