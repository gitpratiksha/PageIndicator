import 'package:flutter/material.dart';

import 'package:flutter_page_indicator/flutter_page_indicator.dart';

import "package:transformer_page_view/transformer_page_view.dart";

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class RadioGroup extends StatefulWidget {
  final List<String> titles;

  final ValueChanged<int> onIndexChanged;

  const RadioGroup({Key key, this.titles, this.onIndexChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _RadioGroupState();
  }
}

class _RadioGroupState extends State<RadioGroup> {
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < widget.titles.length; ++i) {
      list.add(((String title, int index) {
        return new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Radio<int>(
                value: index,
                groupValue: _index,
                onChanged: (int index) {
                  setState(() {
                    _index = index;
                    widget.onIndexChanged(_index);
                  });
                }),
            new Text(title)
          ],
        );
      })(widget.titles[i], i));
    }

    return new Wrap(
      children: list,
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 1;

  double size = 20.0;
  double activeSize = 30.0;

  PageController controller;

  PageIndicatorLayout layout = PageIndicatorLayout.SLIDE;

  List<PageIndicatorLayout> layouts = PageIndicatorLayout.values;

  bool loop = false;

  @override
  void initState() {
    controller = new PageController();
    super.initState();
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
     
      new Container(
        color: Colors.red,
      ),
      new Container(
        color: Colors.green,
      ),
      new Container(
        color: Colors.blueAccent,
      ),
      new Container(
        color: Colors.grey,
      )
   
    ];
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('pages'),
        ),
        body: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Checkbox(value: loop, onChanged: (bool value){
                  setState(() {
                    if(value){
                      controller = new TransformerPageController(
                          itemCount: 4,
                          loop: true
                      );
                    }else{
                      controller = new PageController(
                        initialPage: 0,

                      );
                    }
                    loop = value;
                  });
                }),
                new Text("loop"),
              ],
            ),
            new RadioGroup(
              titles: layouts.map((s) {
                var str = s.toString();
                return str.substring(str.indexOf(".") + 1);
              }).toList(),
              onIndexChanged: (int index) {
                setState(() {
                  _index = index;
                  layout = layouts[index];

                });
              },
            ),
            new Expanded(
                child: new Stack(
              children: <Widget>[
                loop ? new TransformerPageView.children(
                  children: children,
                  pageController: controller,
                ):
                new PageView(
                  controller: controller,
                  children:children ,
                ),
                new Align(
                  alignment: Alignment.bottomCenter,
                  child: new Padding(
                    padding: new EdgeInsets.only(bottom: 20.0),
                    child: new PageIndicator(
                      layout: layout,
                      size: size,
                      activeSize:activeSize,
                      controller: controller,
                      space: 5.0,
                      count: 4,
                    ),
                  ),
                )
              ],
            ))
          ],
        ));
  }
}