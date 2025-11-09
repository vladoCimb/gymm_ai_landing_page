import 'package:flutter/material.dart';

class ScrollAnimatedRichText extends StatefulWidget {
  const ScrollAnimatedRichText({
    super.key,
    required this.scrollController,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.start,
    this.triggerOffset = 200,
    this.stepSize = 20,
    this.targetColor = const Color(0xFFFFFFFF),
  });

  final ScrollController scrollController;
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final double triggerOffset;
  final double stepSize;
  final Color targetColor;

  @override
  State<ScrollAnimatedRichText> createState() => _ScrollAnimatedRichTextState();
}

class _ScrollAnimatedRichTextState extends State<ScrollAnimatedRichText> {
  final GlobalKey _textKey = GlobalKey();
  late List<_Token> _tokens;
  late List<int> _wordTokenIndices;
  double _wordProgress = 0;

  TextStyle get _baseStyle => widget.style;
  Color get _baseColor => _baseStyle.color ?? Colors.white;

  @override
  void initState() {
    super.initState();
    _setTokens();
    widget.scrollController.addListener(_handleScrollChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleScrollChange());
  }

  @override
  void didUpdateWidget(covariant ScrollAnimatedRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_handleScrollChange);
      widget.scrollController.addListener(_handleScrollChange);
    }
    if (oldWidget.text != widget.text) {
      _setTokens();
      _resetAnimation();
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _handleScrollChange()); // ensure fresh position computed
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScrollChange);
    super.dispose();
  }

  void _setTokens() {
    final tokens = <_Token>[];
    final wordIndices = <int>[];
    final whitespace = RegExp(r'(\s+)');
    var currentIndex = 0;
    final matches = whitespace.allMatches(widget.text);

    void addWordSegment(String segment) {
      if (segment.isEmpty) return;
      tokens.add(_Token(segment, false));
      wordIndices.add(tokens.length - 1);
    }

    for (final match in matches) {
      final wordSegment = widget.text.substring(currentIndex, match.start);
      addWordSegment(wordSegment);

      final separator = match.group(0);
      if (separator != null && separator.isNotEmpty) {
        tokens.add(_Token(separator, true));
      }
      currentIndex = match.end;
    }

    if (currentIndex < widget.text.length) {
      final lastSegment = widget.text.substring(currentIndex);
      addWordSegment(lastSegment);
    }

    _tokens = tokens;
    _wordTokenIndices = wordIndices;
  }

  void _resetAnimation() {
    if (!mounted) return;
    setState(() {
      _wordProgress = 0;
    });
  }

  void _handleScrollChange() {
    final renderObject = _textKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) {
      return;
    }

    final offset = renderObject.localToGlobal(Offset.zero);
    final viewportHeight = MediaQuery.of(context).size.height;
    final triggerLine = viewportHeight - widget.triggerOffset;
    final delta = triggerLine - offset.dy;

    if (delta <= 0) {
      _updateProgress(0);
      return;
    }

    final totalProgress = delta / widget.stepSize;
    final int totalWords = _wordTokenIndices.length;
    if (totalWords == 0) {
      return;
    }
    final clampedProgress =
        totalProgress.clamp(0.0, totalWords.toDouble()).toDouble();

    _updateProgress(clampedProgress);
  }

  void _updateProgress(double progress) {
    if ((_wordProgress - progress).abs() < 0.001) {
      return;
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _wordProgress = progress;
    });
  }

  Color _colorForWord(int wordIndex) {
    final progress = (_wordProgress - wordIndex).clamp(0.0, 1.0);
    if (progress <= 0) {
      return _baseColor;
    }
    if (progress >= 1) {
      return widget.targetColor;
    }
    return Color.lerp(_baseColor, widget.targetColor, progress) ?? _baseColor;
  }

  @override
  Widget build(BuildContext context) {
    var wordCounter = 0;
    final spans = _tokens.map((token) {
      if (token.isWhitespace) {
        return TextSpan(
          text: token.value,
          style: _baseStyle,
        );
      }
      final color = _colorForWord(wordCounter);
      final span = TextSpan(
        text: token.value,
        style: _baseStyle.copyWith(color: color),
      );
      wordCounter += 1;
      return span;
    }).toList();

    return SelectableText.rich(
      TextSpan(children: spans),
      key: _textKey,
      textAlign: widget.textAlign,
    );
  }
}

class _Token {
  _Token(this.value, this.isWhitespace);

  final String value;
  final bool isWhitespace;
}
