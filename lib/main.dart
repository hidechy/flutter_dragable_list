import 'package:flutter/material.dart';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';

import 'models/draggable_list.dart';
import 'data/draggable_lists.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

///
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

///
class _MainPageState extends State<MainPage> {
  late List<DragAndDropList> lists;

  ///
  @override
  void initState() {
    super.initState();

    lists = allLists.map(buildList).toList();
  }

  ///
  DragAndDropList buildList(DraggableList list) {
    return DragAndDropList(
      ///
      header: Text(list.header),

      ///
      children: list.items.map(
        (item) {
          return DragAndDropItem(
            child: ListTile(
              leading: Image.network(
                item.urlImage,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
              title: Text(item.title),
            ),
          );
        },
      ).toList(),
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.white.withOpacity(0.3);

    return Scaffold(
      appBar: AppBar(
        title: const Text('drag List'),
      ),
      body: DragAndDropLists(
        children: lists,

        ///
        listPadding: const EdgeInsets.all(16),
        listInnerDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(10),
        ),

        ///
        onItemReorder: onReorderListItem,
        onListReorder: onReorderList,

        ///
        itemDragHandle: buildDragHandle(),
        listDragHandle: buildDragHandle(isList: true),

        ///
        itemDivider: Divider(
          thickness: 2,
          height: 2,
          color: backgroundColor,
        ),

        ///
        itemDecorationWhileDragging: const BoxDecoration(
          color: Colors.blueGrey,
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 4,
            ),
          ],
        ),

        ///
        // lastItemTargetHeight: 50,
        // addLastItemTargetHeightToTop: true,
        // lastListTargetSize: 30,
      ),
    );
  }

  ///
  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(
      () {
        final oldListItems = lists[oldListIndex].children;
        final newListItems = lists[newListIndex].children;

        final movedItem = oldListItems.removeAt(oldItemIndex);
        newListItems.insert(newItemIndex, movedItem);
      },
    );
  }

  ///
  void onReorderList(
    int oldListIndex,
    int newListIndex,
  ) {
    setState(
      () {
        final movedList = lists.removeAt(oldListIndex);
        lists.insert(newListIndex, movedList);
      },
    );
  }

  ///
  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAlignment = (isList)
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;

    final color = (isList) ? Colors.greenAccent : Colors.yellowAccent;

    return DragHandle(
      verticalAlignment: verticalAlignment,
      child: Icon(Icons.menu, color: color),
    );
  }
}
