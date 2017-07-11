//
//  ViewController.swift
//  YLTextView_Swit
//
//  Created by 张雨露 on 2017/6/9.
//  Copyright © 2017年 张雨露. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        let textview = UITextView(frame: CGRect(x: 100, y: 100, width: 200, height: 150))
//        textview.text = "如果你想对textView.text直接赋值。请在设置属性之前进行，否则影响计算"
        textview.placeholder = "喜欢请Star"
        textview.limitLength = 20
//        textview.limitLines = 4;
        textview.center = self.view.center
        view.addSubview(textview)
    }

}

