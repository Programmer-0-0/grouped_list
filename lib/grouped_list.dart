import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:grouped_list/fade_animation.dart';

import 'src/grouped_list_order.dart';

export 'src/grouped_list_order.dart';

/// A groupable list of widgets similar to [ListView], execpt that the
/// items can be sectioned into groups.
///
/// See [ListView.builder]
///
@immutable
class GroupedListView<T, E> extends StatefulWidget {
  /// Items of which [itemBuilder] or [indexedItemBuilder] produce the list.
  final List<T> elements;

  /// Defines which [elements] are grouped together.
  ///
  /// Function is called for each element in the list, when equal for two
  /// elements, those two belong to the same group.
  final E Function(T element) groupBy;

  /// Can be used to define a custom sorting for the groups.
  ///
  /// If not set groups will be sorted with their natural sorting order or their
  /// specific [Comparable] implementation.
  final int Function(E value1, E value2)? groupComparator;

  /// Can be used to define a custom sorting for the [elements] inside each
  /// group.
  ///
  /// If not set [elements] will be sorted with their natural sorting order or
  /// their specific [Comparable] implementation.
  final int Function(T element1, T element2)? itemComparator;

  /// Called to build group separators for each group.
  /// Value is always the [groupBy] result from the first element of the group.
  ///
  /// Will be ignored if [groupHeaderBuilder] is used.
  final Widget Function(E value)? groupSeparatorBuilder;

  /// Same as [groupSeparatorBuilder], will be called to build group separators
  /// for each group.
  /// The passed element is always the first element of the group.
  ///
  /// If defined [groupSeparatorBuilder] wont be used.
  final Widget Function(T element)? groupHeaderBuilder;

  /// Same as [groupHeaderBuilder], but you can define a different widget
  /// for the sticky header.
  /// The passed element is always the first element of the group.
  ///
  /// If defined [groupHeaderBuilder] wont be used.
  final Widget Function(T element)? groupStickyHeaderBuilder;

  /// Called to build children for the list with
  /// 0 <= element < elements.length.
  final Widget Function(BuildContext context, T element)? itemBuilder;

  /// Called to build the children for the list where the current element
  /// depends of the previous and next elements
  final Widget Function(BuildContext context, T? previousElement,
      T currentElement, T? nextElement)? interdependentItemBuilder;

  /// Called to build children for the list with additional information about
  /// whether the item is at the start or end of a group.
  ///
  /// The [groupStart] parameter is `true` if the item is the first in its group.
  /// The [groupEnd] parameter is `true` if the item is the last in its group.
  final Widget Function(
          BuildContext context, T element, bool groupStart, bool groupEnd)?
      groupItemBuilder;

  /// Called to build children for the list with
  /// 0 <= element, index < elements.length
  final Widget Function(BuildContext context, T element, int index)?
      indexedItemBuilder;

  /// This widget is displayed if the list is contains no [elements] and thus is
  /// empty.
  ///
  /// If no defined nothing will be displayed.
  final Widget? emptyPlaceholder;

  /// Whether the order of the list is ascending or descending.
  ///
  /// Defaults to [GroupedListOrder.ASC].
  final GroupedListOrder order;

  /// Whether the [elements] will be sorted or not. If not it must be done
  /// manually.
  ///
  /// Defauts to `true`.
  final bool sort;

  /// When set to `true` the group header of the current visible group will
  /// stick on top.
  final bool useStickyGroupSeparators;

  /// Called to build separators for between each element in the list.
  final Widget separator;

  /// Whether the group headers float over the list or occupy their own space.
  final bool floatingHeader;

  /// Background color of the sticky header.
  /// Only used if [floatingHeader] is false.
  final Color stickyHeaderBackgroundColor;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// See [ScrollView.controller]
  final ScrollController? controller;

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  ///
  /// See [ScrollView.primary]
  final bool? primary;

  /// How the scroll view should respond to user input.
  ///
  /// See [ScrollView.physics].
  final ScrollPhysics? physics;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// See [ScrollView.shrinkWrap]
  final bool shrinkWrap;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry? padding;

  /// Whether the view scrolls in the reading direction.
  ///
  /// Defaults to false.
  ///
  /// See [ScrollView.reverse].
  final bool reverse;

  /// Whether to wrap each child in an [AutomaticKeepAlive].
  ///
  /// See [SliverChildBuilderDelegate.addAutomaticKeepAlives].
  final bool addAutomaticKeepAlives;

  /// Whether to wrap each child in a [RepaintBoundary].
  ///
  /// See [SliverChildBuilderDelegate.addRepaintBoundaries].
  final bool addRepaintBoundaries;

  /// Whether to wrap each child in an [IndexedSemantics].
  ///
  /// See [SliverChildBuilderDelegate.addSemanticIndexes].
  final bool addSemanticIndexes;

  /// Creates a scrollable, linear array of widgets that are created on demand.
  ///
  /// See [ScrollView.cacheExtent]
  final double? cacheExtent;

  /// {@macro flutter.widgets.Clip}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// [ScrollViewKeyboardDismissBehavior] the defines how this [ScrollView] will
  /// dismiss the keyboard automatically.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// The number of children that will contribute semantic information.
  ///
  /// Some subtypes of [ScrollView] can infer this value automatically. For
  /// example [ListView] will use the number of widgets in the child list,
  /// while the [ListView.separated] constructor will use half that amount.
  ///
  /// For [CustomScrollView] and other types which do not receive a builder
  /// or list of widgets, the child count must be explicitly provided. If the
  /// number is unknown or unbounded this should be left unset or set to null.
  ///
  /// See also:
  ///
  /// * [SemanticsConfiguration.scrollChildCount], the corresponding semantics
  /// property.
  final int? semanticChildCount;

  /// If non-null, forces the children to have the given extent in the scroll
  /// direction.
  ///
  /// Specifying an [itemExtent] is more efficient than letting the children
  /// determine their own extent because the scrolling machinery can make use of
  /// the foreknowledge of the children's extent to save work, for example when
  /// the scroll position changes drastically.
  final double? itemExtent;

  /// Widget to be placed at the bottom of the list.
  final Widget? footer;

  /// Creates a [GroupedListView].
  /// This constructor requires that [elements] and [groupBy] are provieded.
  /// [elements] defines a list of elements which are displayed in the list and
  /// [groupBy] defindes a function which returns the value on which the
  /// elements are grouped.
  ///
  /// Additionally at least one of [itemBuilder] or [indexedItemBuilder] and one
  /// of [groupSeparatorBuilder] or [groupHeaderBuilder] must be provieded.
  const GroupedListView({
    super.key,
    required this.elements,
    required this.groupBy,
    this.groupComparator,
    this.groupSeparatorBuilder,
    this.groupHeaderBuilder,
    this.groupStickyHeaderBuilder,
    this.emptyPlaceholder,
    this.itemBuilder,
    this.groupItemBuilder,
    this.indexedItemBuilder,
    this.interdependentItemBuilder,
    this.itemComparator,
    this.order = GroupedListOrder.ASC,
    this.sort = true,
    this.useStickyGroupSeparators = false,
    this.separator = const SizedBox.shrink(),
    this.floatingHeader = false,
    this.stickyHeaderBackgroundColor = const Color(0xffF7F7F7),
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.reverse = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.clipBehavior = Clip.hardEdge,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.dragStartBehavior = DragStartBehavior.start,
    this.restorationId,
    this.semanticChildCount,
    this.itemExtent,
    this.footer,
  })  : assert(itemBuilder != null ||
            indexedItemBuilder != null ||
            interdependentItemBuilder != null ||
            groupItemBuilder != null),
        assert(groupSeparatorBuilder != null || groupHeaderBuilder != null);

  @override
  State<StatefulWidget> createState() => GroupedListViewState<T, E>();
}

class GroupedListViewState<T, E> extends State<GroupedListView<T, E>> {
  // final StreamController<int> _streamController = StreamController<int>();
  // final LinkedHashMap<String, GlobalKey> _keys = LinkedHashMap();
  // final GlobalKey _key = GlobalKey();
  // late final ScrollController _controller;
  // GlobalKey? _groupHeaderKey;
  // List<T> _sortedElements = [];
  // int _topElementIndex = 0;
  // RenderBox? _headerBox;
  // RenderBox? _listBox;

  /// Fix for backwards compatability
  ///
  /// See:
  /// * https://docs.flutter.dev/development/tools/sdk/release-notes/release-notes-3.0.0#your-code
  late Map<E, List<T>> _groupedElements;
  late List<E> _sortedGroups;
  final Map<E, GlobalKey<AnimatedListState>> _animatedListKeys = {};

  @override
  void initState() {
    super.initState();
    _updateGroupedElements();
  }

  @override
  void didUpdateWidget(GroupedListView<T, E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.elements != widget.elements) {
      _updateGroupedElements();
    }
  }

  void _updateGroupedElements() {
    _groupedElements = _groupElements();
    _sortedGroups = _sortGroups();

    // Initialize keys for new groups
    for (var group in _sortedGroups) {
      _animatedListKeys.putIfAbsent(
          group, () => GlobalKey<AnimatedListState>());
    }
  }

  Map<E, List<T>> _groupElements() {
    var groupedElements = <E, List<T>>{};
    for (var element in widget.elements) {
      var group = widget.groupBy(element);
      groupedElements.putIfAbsent(group, () => []).add(element);
    }
    return groupedElements;
  }

  List<E> _sortGroups() {
    var groups = _groupedElements.keys.toList();
    if (widget.sort && widget.groupComparator != null) {
      groups.sort(widget.groupComparator);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _sortedGroups.length,
      itemBuilder: (context, index) {
        var group = _sortedGroups[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.groupSeparatorBuilder!(group),
            AnimatedList(
              key: _animatedListKeys[group],
              initialItemCount: _groupedElements[group]!.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index, animation) {
                return FadeAnimation(
                  (1.0 + index) / 4.0,
                  FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      child: widget.itemBuilder!(
                          context, _groupedElements[group]![index]),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Add methods for inserting and removing items
  void addItem(T item) {
    setState(() {
      var group = widget.groupBy(item);
      if (!_groupedElements.containsKey(group)) {
        _groupedElements[group] = [];
        _sortedGroups.add(group);
        _animatedListKeys[group] = GlobalKey<AnimatedListState>();
      }
      _groupedElements[group]!.insert(0, item);
      _animatedListKeys[group]!
          .currentState
          ?.insertItem(0, duration: Duration(milliseconds: 400));
    });
  }

  void removeItem(T item) {
    setState(() {
      var group = widget.groupBy(item);
      var index = _groupedElements[group]!.indexOf(item);
      if (index != -1) {
        _groupedElements[group]!.removeAt(index);
        _animatedListKeys[group]!.currentState?.removeItem(
              index,
              (context, animation) => SizeTransition(
                sizeFactor: animation,
                child: widget.itemBuilder!(context, item),
              ),
            );
        if (_groupedElements[group]!.isEmpty) {
          _groupedElements.remove(group);
          _sortedGroups.remove(group);
          _animatedListKeys.remove(group);
        }
      }
    });
  }
}
