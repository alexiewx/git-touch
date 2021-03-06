import 'package:flutter/material.dart';
import '../widgets/empty.dart';

class ListGroup<T> extends StatelessWidget {
  final Widget title;
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;

  ListGroup({this.title, this.items, this.itemBuilder});

  Widget _buildItem(MapEntry<int, T> entry) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: itemBuilder(entry.value, entry.key),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              color: Color(0x10000000),
              child: title,
            ),
            items.isEmpty
                ? EmptyWidget()
                : Column(
                    children: items.asMap().entries.map(_buildItem).toList())
          ],
        ),
      ),
    );
  }
}
