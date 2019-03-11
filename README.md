# pull_to_zoom_refresh
the flutter plugin, It realizes the function of enlarging and refreshing the top picture, Support for Android and iOS.
这个插件实现了下拉顶部图片放大和刷新功能，支持Android和iOS。

## Project presentations
![](https://github.com/guoyuanzhuang/pull_to_zoom_refresh/blob/master/art/pull_to_zoom_refresh.gif)

## Sample
```dart
  PullToZoomRefresh(
    onRefresh: () async{
      ....
    },
    onPullZoom: (dragOffset, mode){
      ....
      ....
    },
    imageWidget: ....,
    headerWidget: ...,
    contentWidget: ...,
  ),
```


## Open source licenses
```dart
MIT License

Copyright (c) 2019 John

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```