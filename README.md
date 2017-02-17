# YLTextView
一行代码搞定textView占位符和字数限制
# YLTextView
##如何使用？
*第一步
  把YLTextView文件夹拖入你的项目
```Objective-C
#include "UITextView+YLTextView.h"
```
  *第二步
  ```Objective-C
    //实例化你的textView
    //两个属性可分别使用，互不影响
//    textView.text = @"请写在自定义属性前面，如果长度大于limitLength设置长度会被自动截断。";
    textView.placeholder = @"欢迎star";
    textView.limitLength = @20;
    [self.view addSubview:textView];

  ```
##效果
![image] (https://github.com/Rain-dew/YLTextView/blob/master/YLTextViewDemo/%E3%80%82.gif)
