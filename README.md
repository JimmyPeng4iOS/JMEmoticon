# JMEmoticonDemo
#####JMEmoticonDemo 是本人 Jimmy 使用Swift语言自定义的一个表情键盘。 基于新浪的表情包来实现表情在文本框的显示，实现表情的输入，可方便的整合入app , 简单易用。 
---
#####Github地址:

<https://github.com/JimmyPeng4iOS/JMEmoticon>

---
#####可获取最近使用的表情
按使用频率排序:


![最近](http://upload-images.jianshu.io/upload_images/1115674-fae5ec655597c06f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 另外三个表情包

 * 默认
  
![默认](http://upload-images.jianshu.io/upload_images/1115674-e0a3e5cd8224386f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 * Emoji


![Emoji](http://upload-images.jianshu.io/upload_images/1115674-f3e4b8519be5e29d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 * 浪小花


![浪小花](http://upload-images.jianshu.io/upload_images/1115674-c938c5777de1b217.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
---
###使用方法:

* 自定义表请键盘的控制器

 ```objective-c
 private lazy var emoticonVC: EmoticonViewController = EmoticonViewController(textView: self.textView)
```

* 将自定义键盘的控制器管理起来

```objective-c
        addChildViewController(emoticonVC)
        textView.inputView = emoticonVC.view
        // 弹出键盘
        textView.becomeFirstResponder()
```

 当然了,如果表情键盘只是你的键盘的一部分, 还需要各位添加代码来实现 ⊙▽⊙
---
#####最后 再来一遍github地址 (๑•̀ㅂ•́)و✧

<https://github.com/JimmyPeng4iOS/JMEmoticon>

---
####个人中文博客 ┑(￣Д ￣)┍
<http://www.jianshu.com/users/53845c6b43dc/top_articles>