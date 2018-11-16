# YLTextView
一行代码搞定textView的占位符、字数限制、行数限制
# OC版本
如何使用？
第一步
  把YLTextView文件夹拖入你的项目
```Objective-C
#import "UITextView+YLTextView.h"
```
 第二步
  ```Objective-C
   //    textView.font = [UIFont systemFontOfSize:17];
//    textView.text = @"请写在自定义属性前面，如果长度大于limitLength设置长度会被自动截断。";
    textView.placeholder = @"欢迎";
    textView.limitLength = @20;
    textView.placeholdColor = [UIColor redColor];
    textView.limitPlaceColor = [UIColor redColor];
    textView.placeholdFont = [UIFont systemFontOfSize:17];
    textView.limitPlaceFont = [UIFont systemFontOfSize:17];
    textView.autoHeight = @1;//自动计算高度 若取消不设置或 @0 即可
    //  textView.limitLines = @4;//行数限制优先级低于字数限制
    [self.view addSubview:textView];

  ```
备注：
如果你发现placeholder的位置出现在中间了，那么你加入下面代吗即可
```Objective-C
 if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
       self.automaticallyAdjustsScrollViewInsets = NO;
    }
```

## Swift版本
#### YLTextView_SwiftDemo 
下载后找到上面文件夹，打开运行项目。
```Swift
        let textview = UITextView(frame: CGRect(x: 100, y: 100, width: 200, height: 150))
//        textview.text = "如果你想对textView.text直接赋值。请在设置属性之前进行，否则影响计算"
        textview.placeholder = "喜欢请Star"
        textview.limitLength = 20
        textview.placeholdColor = .red
        textview.limitLabelColor = .red
        textview.placeholdFont = UIFont.boldSystemFont(ofSize: 17)
        textview.limitLabelFont = UIFont.boldSystemFont(ofSize: 17)
//        textview.limitLines = 4;
        textview.center = self.view.center
        view.addSubview(textview)

```

效果

![image](https://github.com/Rain-dew/YLTextView/blob/master/YLTextViewDemo/%E3%80%82.gif)
