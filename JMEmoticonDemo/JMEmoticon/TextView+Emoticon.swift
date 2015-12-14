//
//  TextView+Emoticon.swift
//  JMEmoticon
//
//  Created by Jimmy on 15/11/12.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

import UIKit

extension UITextView
{
    
    /// 获取带表情图片的字符串
    func emoticonText() -> String
    {
        var strM = ""
        // 遍历属性
        attributedText.enumerateAttributesInRange(NSRange(location: 0, length: attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (result, range, _) -> Void in
            // 如果retult字典中包含 "NSAttachment" 是一个表情.
            if let attachment = result["NSAttachment"] as? EmoticonTextAttachment
            {
                // 获取表情的名称
                strM += attachment.name!
            }
            else
            {
                //截取字符串
                let str = (self.attributedText.string as NSString).substringWithRange(range)
                // 拼接
                strM += str
            }
        }
        // 返回拼接好的字符串
        return strM
    }
    
    /**
     添加一个表情到textView
     
     - parameter emoticon: 要添加的表情模型
     */
    func insertEmoticon(emoticon: Emoticon)
    {
        // 判断是否指删除按钮
        if emoticon.removeEmoticon
        {
            // 删除文本内容
            deleteBackward()
            return
        }
        
        // 添加emoji表情
        if emoticon.emoji != nil
        {
            // 添加emoji表情
            insertText(emoticon.emoji!)
        }
        
        // 添加图片表情
        if emoticon.pngPath != nil
        {
            // 创建附件
            let attachment = EmoticonTextAttachment()
            
            let width = font!.lineHeight
            
            // 设置附件的大小
            attachment.bounds = CGRect(x: 0, y: -4, width: width, height: width)
            
            // 给附件添加图片
            attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
            
            // 将表情名称赋值给attachment附件
            attachment.name = emoticon.chs
            
            // 创建一个属性文本,属性文本有一个附件,附件里面有一张图片
            let attrString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            
            // 给附件添加Font属性
            attrString.addAttribute(NSFontAttributeName, value: font!, range: NSRange(location: 0, length: 1))
            
            // 拿出textView内容
            let attrM = NSMutableAttributedString(attributedString: attributedText)
            
            // 把图片添加到已有内容里面,
            // 获取textView选中的范围
            let sRange = self.selectedRange
            attrM.replaceCharactersInRange(sRange, withAttributedString: attrString)
            
            // 在重新赋值回去
            attributedText = attrM
            
            // 重新设置选中范围,让光标在插入表情后面
            self.selectedRange = NSRange(location: selectedRange.location + 1, length: 0)
            
            // 手动触发textView文本改变
            // 发送通知,文字改变
            NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self)
            
            // 调用代理,文字改变
            delegate?.textViewDidChange?(self)
        }
    }
}
