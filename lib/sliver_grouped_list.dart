import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const double _kMaxHeightDim = 50.0;
const double _kMinHeightDim = 40.0;

/// A [SliverGroupedList] list which wraps a [CustomScrollView]
/// providing created [_SliverGroupedHeader] and [_SliverGroupedEntry] slivers
///
/// [Builder] is used to create a list of [Widget] and set
/// is as a slivers property of [CustomScrollView]
///
/// For every [_SliverGroupedHeader] and [_SliverGroupedEntry] a separate
/// builder method is created: [bodyHeaderBuilder] and [bodyEntryBuilder]
///
/// [data] is based on provided [Header] and [Entry] types.
///
/// To build a [SliverGroupedList] the [Header] and [Entry] types
/// should be explicitly showed like [SliverGroupedList<String, String>]
///
/// Every item of the sliver list handles [onItemTap] event providing
/// the tapped item as a parameter.
class SliverGroupedList<Header, Entry> extends StatelessWidget {
  const SliverGroupedList(
      {Key key,
      this.data,
      this.bodyHeaderBuilder,
      this.bodyEntryBuilder,
      this.onItemTap,
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

  /// [bodyHeaderBuilder] is mandatory and should not be null
  /// assertion is used to check the nullability of the
  /// property and will show a stacktrace
  @required
  final Widget Function(BuildContext context, Header header) bodyHeaderBuilder;

  /// [bodyEntryBuilder] is mandatory and should not be null
  /// assertion is used to check the nullability of the
  /// property and will show a stacktrace
  @required
  final Widget Function(BuildContext context, Entry item) bodyEntryBuilder;

  /// [data] is mandatory and should not be null
  /// assertion is used to check the nullability of the
  /// property and will show a stacktrace
  @required
  final Map<Header, List<Entry>> data;

  /// [onItemTap] on tap event callback
  @required
  final Function(Entry item) onItemTap;

  /// [header] provide additional Sliver related widget to
  /// display content above body.
  final Widget header;

  /// [footer] provide additional Sliver related widget to
  /// display content under body.
  final Widget footer;

  /// Properties of [CustomScrollView]
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final Key center;
  final double anchor;
  final double cacheExtent;
  final int semanticChildCount;
  final DragStartBehavior dragStartBehavior = DragStartBehavior.start;

  @override
  Widget build(BuildContext context) {
    assert(data != null,
        '$runtimeType Data should not be null, please provide valid Data');
    assert(bodyHeaderBuilder != null,
        '$runtimeType headerBuilder should not be null');
    assert(bodyEntryBuilder != null,
        '$runtimeType runtimeType should not be null');
    return Builder(builder: (context) {
      var widgetList = <Widget>[];
      if (header != null) {
        widgetList.add(header);
      }
      data.forEach((key, value) {
        widgetList
          ..add(_SliverGroupedHeader(
              minHeight: _kMinHeightDim,
              maxHeight: _kMaxHeightDim,
              child: bodyHeaderBuilder(context, key)))
          ..add(_SliverGroupedEntry(
              entry: value, builder: bodyEntryBuilder, onItemTap: onItemTap));
      });
      if (footer != null) {
        widgetList.add(footer);
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
  const _SliverGroupedEntry({Key key, this.entry, this.onItemTap, this.builder})
      : super(key: key);

  /// [entry] is mandatory and should not be null
  /// assertion is used to check the nullability of the
  /// property and will show a stacktrace
  @required
  final List<Entry> entry;

  /// [onItemTap] is mandatory and should not be null
  @required
  final Function(Entry item) onItemTap;

  /// [builder] is mandatory and should not be null
  /// assertion is used to check the nullability of the
  /// property and will show a stacktrace
  @required
  final Widget Function(BuildContext context, Entry item) builder;

  @override
  Widget build(BuildContext context) {
    assert(entry != null,
        '$runtimeType List<Entry> should not be null, please provide valid List<Entry>');
    assert(builder != null,
        '$runtimeType builder should not be null for creating a dynamic grouped list');
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = entry[index];
        return GestureDetector(
            onTap: () => onItemTap(item), child: builder(context, item));
      }, childCount: entry.length),
    );
  }
}

/// A wrapper above [_SliverHeaderDelegate]
///
class _SliverGroupedHeader extends StatelessWidget {
  const _SliverGroupedHeader(
      {Key key, this.minHeight, this.maxHeight, this.child})
      : super(key: key);

  @required
  final double minHeight;
  @required
  final double maxHeight;
  @required
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        pinned: false,
        delegate: _SliverHeaderDelegate(
          minHeight: minHeight,
          maxHeight: maxHeight,
          child: child,
        ));
  }
}

/// A header delegate extending [SliverPersistentHeaderDelegate]
///
/// Will allow to display expendables Headers
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  @required
  final double minHeight;
  @required
  final double maxHeight;
  @required
  final Widget child;

  _SliverHeaderDelegate({
    this.minHeight,
    this.maxHeight,
    this.child,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
