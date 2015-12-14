//
//  ViewController.swift
//  JMEmoticonDemo
//
//  Created by JimmyPeng on 15/12/14.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 将自定义键盘的控制器管理起来
        addChildViewController(emoticonVC)
        
        textView.inputView = emoticonVC.view
        
        // 弹出键盘
        textView.becomeFirstResponder()
    }

    
    /// 自定义表请键盘的控制器
    private lazy var emoticonVC: EmoticonViewController = EmoticonViewController(textView: self.textView)
    
    
}

