import 'package:flutter/material.dart';

class ZoomableContainerWithButton extends StatefulWidget {
  @override
  _ZoomableContainerWithButtonState createState() => _ZoomableContainerWithButtonState();
}

class _ZoomableContainerWithButtonState extends State<ZoomableContainerWithButton> {
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    // 设置初始缩放为0.7倍
    _transformationController.value = Matrix4.identity()..scale(0.6);
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dialog'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  print('Button 1 clicked');
                  Navigator.of(context).pop();
                },
                child: Text('Button 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  print('Button 2 clicked');
                  Navigator.of(context).pop();
                },
                child: Text('Button 2'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View the map'),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              transformationController: _transformationController,
              constrained: false,
              boundaryMargin: EdgeInsets.zero,
              minScale: 0.1,
              maxScale: 2.0,
              child: Stack(
                children: [
                  Image(
                    image: AssetImage('assets/62741.jpg'),
                  ),
                  Positioned(
                    left: 150,
                    top: 850,
                    child: ElevatedButton(
                      onPressed: () {
                        _showDialog(context);
                      },
                      child: Text('Button'),
                    ),
                  ),
                  Positioned(
                    left: 1200,
                    top: 500,
                    child: ElevatedButton(
                      onPressed: () {
                        _showDialog(context);
                      },
                      child: Text('Button'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50, // 调整这个值以设置底部空白行的高度
          ),
        ],
      ),
    );
  }
}
