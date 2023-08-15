import 'package:flutter/material.dart';

void main() {
  runApp(InfiniteScrollApp());
}

class InfiniteScrollApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: InfiniteScrollWidget(),
    );
  }
}

class InfiniteScrollWidget extends StatefulWidget {
  _InfiniteScrollWidgetState createState() => _InfiniteScrollWidgetState();
}

class _InfiniteScrollWidgetState extends State<InfiniteScrollWidget>{
  List<String> dataList = ["@"];
  double screenHeight = 0.0;
  int currentPage = 0;
  int itemHeight = 60;
  int itemsPerPage = 20;
  int head = 0;
  int tail = 0;
  double tilesPadding = 16.0;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TODO: implement didUpdateWidget
    _calculateItemsPerPage();
    _loadData(true);
  }

  void _calculateItemsPerPage() {
    screenHeight = MediaQuery.of(context).size.height;
    itemsPerPage = (screenHeight / (itemHeight)).ceil();
  }

  void _loadData(bool down) {
    if(isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    print("list size: ${dataList.length}");

    Future.delayed(const Duration(seconds: 1), ()
    {
      if (down) {
        bool isSingleSection = dataList.length <= itemsPerPage + 1;

        bool isOnlyOnePageData = (dataList.length < 2 * itemsPerPage);

        setState(() {
          if (!isOnlyOnePageData) {
            dataList.removeRange(1, itemsPerPage + 1);
            head += itemsPerPage;
          }
          List<String> temp = [];
          for (int i = 0; i < itemsPerPage; i ++) {
            temp.add("Item ${tail + i + 1}");
          }

          dataList.insertAll(dataList.length, temp);

          tail += itemsPerPage;
          currentPage ++;
        });

        if (dataList.length < 2 * itemsPerPage) {
          print("scroll to item height");
          _scrollController.animateTo(itemHeight.toDouble(), duration: Duration(milliseconds: 200), curve: Curves.linear);

        } else {
          if (!isSingleSection) {
            double scrollOffsetChange = _scrollController.offset -
                itemHeight * itemsPerPage;
            _scrollController.jumpTo(scrollOffsetChange);
          }
        }
      } else {
        bool isOnlyOnePageData = (dataList.length < 2 * itemsPerPage);

        setState(() {
          head -= itemsPerPage;
          List<String> temp = [];
          for (int i = 0; i < itemsPerPage; i ++) {
            temp.add("Item ${head + i + 1}");
          }

          if (!isOnlyOnePageData) {
            print("${dataList.length - itemsPerPage} - ${dataList.length}");
            dataList.removeRange(dataList.length - itemsPerPage, dataList.length );
            tail -= itemsPerPage;
          }
          dataList.insertAll(1, temp);
          currentPage --;
          print("head ${head} - tail ${tail}");
        });
        _scrollController.animateTo(itemHeight.toDouble(), duration: Duration(milliseconds: 200), curve: Curves.linear);

      }

      isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      print("Max here: ${_scrollController.position.maxScrollExtent}");
      _loadData(true);
    } else if (_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
      print("Min here: ${_scrollController.position.minScrollExtent}");
      _loadData(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Infinite Scroll Example")),
      body: ListView.builder(

        controller: _scrollController,
        itemCount: dataList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(
              height: itemHeight.toDouble(),
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (index > 0 && index < dataList.length) {
            return SizedBox(
              height: itemHeight.toDouble(),
              child: ListTile(title: Text(dataList[index])),
            );
          } else {
            if ( dataList.length <= 1) {
              return null;
            }
            return SizedBox(
              height: itemHeight.toDouble(),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
        },
      )
    );
  }
}