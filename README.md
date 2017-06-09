# YLTextView
一行代码搞定textView占位符和字数限制
# OC版本
如何使用？
第一步
  把YLTextView文件夹拖入你的项目
```Objective-C
#import "UITextView+YLTextView.h"
```
 第二步
  ```Objective-C
    //实例化你的textView
    //两个属性可分别使用，互不影响
//    textView.text = @"请写在自定义属性前面，如果长度大于limitLength设置长度会被自动截断。";
    textView.placeholder = @"欢迎star";
    textView.limitLength = @20;
    [self.view addSubview:textView];

  ```
备注：
如果你发现placeholder的位置出现在中间了，那么你加入下面代吗即可
```Objective-C
   self.automaticallyAdjustsScrollViewInsets = NO;
```

## Swift版本
#### YLTextView_SwitDemo 
下载后找到上面文件夹，打开运行项目。
```Swift
        let textview = UITextView(frame: CGRect(x: 100, y: 100, width: 200, height: 150))
//        textview.text = "如果你想对textView.text直接赋值。请在设置属性之前进行，否则影响计算"
        textview.placeholder = "喜欢请Star"
        textview.limitLength = 20
        textview.center = self.view.center
        view.addSubview(textview)

```

效果

![image] (https://github.com/Rain-dew/YLTextView/blob/master/YLTextViewDemo/%E3%80%82.gif)
