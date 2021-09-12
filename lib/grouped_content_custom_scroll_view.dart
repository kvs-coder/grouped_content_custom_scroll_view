import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const double _kMaxHeightDim = 50.0;
const double _kMinHeightDim = 40.0;

class GroupedContentData<Header, Entry> {
  const GroupedContentData({
    required this.header,
    required this.entries,
  });

  final Header header;
  final List<Entry> entries;
}

/// A [GroupedContentCustomScrollView] list which wraps a [CustomScrollView]
/// providing created [_SliverGroupedHeader] and [_SliverGroupedEntry] slivers
///
/// [Builder] is used to create a list of [Widget] and set
/// is as a slivers property of [CustomScrollView]
///
/// For every [_SliverGroupedHeader] and [_SliverGroupedEntry] a separate
/// builder method is created: [bodyHeaderBuilder] and [bodyEntryBuilder]
/// if no entries, [bodyPlaceholderBuilder] is created
///
/// [data] is based on provided [Header] and [Entry] types.
///
/// To build a [GroupedContentCustomScrollView] the [Header] and [Entry] types
/// should be explicitly showed like [SliverGroupedList<String, String>]
///
/// Every item of the sliver list handles [onItemTap] event providing
/// the tapped item as a parameter.
class GroupedContentCustomScrollView<Header, Entry> extends StatelessWidget {
  const GroupedContentCustomScrollView(
      {Key? key,
      required this.data,
      this.bodyHeaderPinned = false,
      this.bodyHeaderFloating = false,
      this.bodyHeaderMinHeight = _kMinHeightDim,
      this.bodyHeaderMaxHeight = _kMaxHeightDim,
      required this.bodyHeaderBuilder,
      required this.bodyEntryBuilder,
      this.appBar,
      this.header,
      this.footer,
      this.controller,
      this.primary,
      this.physics,
      this.center,
      this.cacheExtent,
      this.semanticChildCount,
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.shrinkWrap = false,
      this.anchor = 0.0})
      : super(key: key);

  /// Set [bodyHeaderMinHeight] and [bodyHeaderMaxHeight]
  /// to make collapsable header for entry
  /// [bodyHeaderMinHeight] is 40.0 by default
  /// [bodyHeaderMaxHeight] is 50.0 by default
  final double bodyHeaderMinHeight;
  final double bodyHeaderMaxHeight;

  /// Set [bodyHeaderPinned] to pin header and
  /// to enable/prevent dismissing by scrolling
  /// by default is set to false
  final bool bodyHeaderPinned;

  /// Set [bodyHeaderFloating] to
  /// toggle visibility of top header of the first group
  /// of elements
  /// by default is set to false
  final bool bodyHeaderFloating;

  /// [bodyHeaderBuilder] is mandatory and should not be null
  /// assertion is used to check the nullability of the
  /// property and will show a stacktrace
  final Widget Function(BuildContext context, Header header) bodyHeaderBuilder;

  /// [bodyEntryBuilder] is mandatory and should not be null
  /// assertion is used to check the nullability of the
  /// property and will show a stacktrace
  final Widget Function(BuildContext context, int index, Entry item)
      bodyEntryBuilder;

  /// [data] is mandatory and should not be null
  /// assertion is used to check the nullability of the
  /// property and will show a stacktrace
  final List<GroupedContentData<Header, Entry>> data;

  /// [appBar] provide additional Sliver related widget to
  /// display content above header as an app bar.
  final Widget? appBar;

  /// [header] provide additional Sliver related widget to
  /// display content above body.
  final RenderObjectWidget? header;

  /// [footer] provide additional Sliver related widget to
  /// display content under body.
  final RenderObjectWidget? footer;

  /// Properties of [CustomScrollView]
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Key? center;
  final double anchor;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior = DragStartBehavior.start;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      var widgetList = <Widget>[];
      if (appBar != null) {
        widgetList.add(appBar!);
      }
      if (header != null) {
        widgetList.add(header!);
      }
      data.forEach((content) {
        widgetList
          ..add(
            _SliverGroupedHeader(
                minHeight: bodyHeaderMinHeight,
                maxHeight: bodyHeaderMaxHeight,
                pinned: bodyHeaderPinned,
                floating: bodyHeaderFloating,
                header: content.header,
                builder: bodyHeaderBuilder),
          )
          ..add(
            _SliverGroupedEntry(
              entries: content.entries,
              builder: bodyEntryBuilder,
            ),
          );
      });
      if (footer != null) {
        widgetList.add(footer!);
      }
      return CustomScrollView(
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        center: center,
        anchor: anchor,
        cacheExtent: cacheExtent,
        slivers: widgetList,
        semanticChildCount: semanticChildCount,
        dragStartBehavior: dragStartBehavior,
      );
    });
  }
}

/// A [SliverFixedExtentList] list wrapper
///
/// Awaits for generic entry [Entry] for preparing
/// an item [builder]
/// Inside [builder] you can create your won [Widget] which
/// will be recognized as a list item with the ability
/// to call [onItemTap] callback if [GestureDetector] detects
/// onTap event
class _SliverGroupedEntry<Entry> extends StatelessWidget {
  const _SliverGroupedEntry({
    Key? key,
    required this.entries,
    required this.builder,
  }) : super(key: key);

  /// [entries] is mandatory and should not be null
  /// assertion is used to check the nullability of the
  /// property and will show a stacktrace
  final List<Entry> entries;

  /// [builder] is mandatory and should not be null
  /// assertion is used to check the nullability of the
  /// property and will show a stacktrace
  final Widget Function(BuildContext context, int index, Entry item) builder;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = entries[index];
        return builder(context, index, item);
      }, childCount: entries.length),
    );
  }
}

/// A wrapper above [_SliverHeaderDelegate]
///
class _SliverGroupedHeader<Header> extends StatelessWidget {
  const _SliverGroupedHeader({
    Key? key,
    required this.minHeight,
    required this.maxHeight,
    required this.header,
    required this.builder,
    this.pinned = false,
    this.floating = false,
  }) : super(key: key);

  final double minHeight;
  final double maxHeight;

  /// [entries] is mandatory and should not be null
  /// assertion is used to check the nullability of the
  /// property and will show a stacktrace
  final Header header;

  /// [builder] is mandatory and should not be null
  /// assertion is used to check the nullability of the
  /// property and will show a stacktrace
  final Widget Function(BuildContext context, Header item) builder;

  final bool pinned;
  final bool floating;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        pinned: pinned,
        floating: floating,
        delegate: _SliverHeaderDelegate(
          minHeight: minHeight,
          maxHeight: maxHeight,
          builder: (context) {
            final item = header;
            return builder(context, item);
          },
        ));
  }
}

/// A header delegate extending [SliverPersistentHeaderDelegate]
///
/// Will allow to display expendables Headers
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget Function(BuildContext) builder;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: builder(context));
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        builder != oldDelegate.builder;
  }
}
