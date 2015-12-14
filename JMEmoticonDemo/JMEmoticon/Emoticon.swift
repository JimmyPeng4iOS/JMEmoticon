//
//  Emoticon.swift
//  JMEmoticon
//
//  Created by Jimmy on 15/11/12.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

import UIKit

/// 表情包模型
class EmoticonPackage: NSObject
{
    
    // 表情包对应的文件夹名称
    var id: String?
    
    // 表情包名称
    var group_name_cn: String?
    
    // 表情模型数组
    var emoticons = [Emoticon]()
    
    /// 字典转模型
    init(id: String)
    {
        self.id = id
        super.init()
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // 获取Emoticons.bundle的路径
    static let bundlePath = NSBundle.mainBundle().pathForResource("Emoticons", ofType: "bundle")!
    
    /// 静态属性,保存表情包模型数据, 只会加载一次
    static let packages = EmoticonPackage.loadPackages()
    
    // 加载表情包
    class func loadPackages() -> [EmoticonPackage]
    {
        // 获取 emoticons.plist的路径
        let plistPath =  (bundlePath as NSString).stringByAppendingPathComponent("emoticons.plist")
        
        // 获取 emoticons.plist 内容
        let emoticonsDict = NSDictionary(contentsOfFile: plistPath)!
        
        // 获取表情包文件夹名称
        let packageArr = emoticonsDict["packages"] as! [[String: AnyObject]]
        
        // 存放表情包模型的数组
        var packages = [EmoticonPackage]()
        
        // 创建 `最近` 表情包
        let recentPackage = EmoticonPackage(id: "")
        
        // 设置表情包名称
        recentPackage.group_name_cn = "最近"
        
        // 追加20个空表情和一个删除按钮
        recentPackage.appendEmptyEmoticon()
        
        // 添加到表情包
        packages.append(recentPackage)
        
        
        // 遍历获取每一个表情包文件名称
        for dict in packageArr
        {
            // 获取id
            let id = dict["id"] as! String
            
            // 创建表情包
            let package = EmoticonPackage(id: id)
            
            // 根据当前表情包模型,加载表情包名称和所有的表情模型
            package.loadEmoticon()
            
            packages.append(package)
        }
        
        // 返回加载到的表情包模型
        return packages
    }
    
    /// 根据当前表情包模型,加载表情包名称和所有的表情模型
    func loadEmoticon()
    {
        
        let infoPlist = EmoticonPackage.bundlePath + "/\(id!)" + "/info.plist"
        
        // 把infoPlist的内容加载到内存
        let infoDict = NSDictionary(contentsOfFile: infoPlist)!
        
        // 获取到表情包名称
        group_name_cn = infoDict["group_name_cn"] as? String
        
        // 获取表情包里面的所有表情模型
        let emoticonArr = infoDict["emoticons"] as! [[String: AnyObject]]
        
        // 记录
        var index = 0
        
        // 遍历 emoticonArr 数组,生成表情模型
        for dict in emoticonArr
        {
            let emoticon = Emoticon(id: id!, dict: dict)
            emoticons.append(emoticon)
            
            index++
            
            //添加删除按钮
            if index == 20
            {
                // 创建删除按钮
                let removeEmoticon = Emoticon(removeEmoticon: true)
                
                // 添加到表情模型数组
                emoticons.append(removeEmoticon)
                
                // 清空index
                index = 0
            }
        }
        //填充空白按钮
        appendEmptyEmoticon()
    }
    
    /// 填充空白按钮,并在最后添加一个删除按钮
    func appendEmptyEmoticon()
    {
        
        let count = emoticons.count % 21
        
        if count > 0 || emoticons.count == 0
        {
            // 追加按钮
            for _ in count..<20
            {
                // 创建空白按钮模型
                let emptyEmoticon = Emoticon(removeEmoticon: false)
                // 添加到表情模型数组
                emoticons.append(emptyEmoticon)
            }
            emoticons.append(Emoticon(removeEmoticon: true))
        }
    }
    
    /*
    最近表情包,永远都只有21个表情,而且最后一个是删除按钮,表情需要按使用次数,多的排在前面
    */
    class func addFavorate(emoticon: Emoticon)
    {
        // 如果是删除按钮不需要添加
        if emoticon.removeEmoticon
        {
            return
        }
        
        // 如果是空白按钮不需要添加
        if emoticon.pngPath == nil && emoticon.emoji == nil
        {
            return
        }
        //使用次数
        emoticon.times++
        
        var recentEmoticons = packages[0].emoticons
        
        // 先移除删除按钮
        let removeEmoticon = recentEmoticons.removeLast()
        
        // 判断重复添加
        let contains = recentEmoticons.contains(emoticon)
        
        // 不重复才需要添加
        if !contains
        {
            // 添加表情模型
            recentEmoticons.append(emoticon)
        }
        
        // 排序
        recentEmoticons = recentEmoticons.sort { (e1, e2) -> Bool in
            // 使用次数多得排在前面
            return e1.times > e2.times
        }
        
        if !contains
        {
            // 移除最后一个
            recentEmoticons.removeLast()
        }
        
        // 将删除按钮添加回去
        recentEmoticons.append(removeEmoticon)
        
        // 赋值数组
        packages[0].emoticons = recentEmoticons
    }
}

/// 表情模型
class Emoticon: NSObject
{
    // 表情包文件夹名称
    var id: String?
    
    // 表情传输名称
    var chs: String?
    
    // 表情对应的图片
    var png: String?{
        didSet
        {
            // 计算图片的完整路径
            pngPath = EmoticonPackage.bundlePath + "/\(id!)" + "/\(png!)"
        }
    }
    
    // 图片的完整路径
    var pngPath: String?
    
    // code emoji的16进制字符串
    var code: String? {
        didSet
        {
            // 扫描
            let scanner = NSScanner(string: code!)
            
            var result: UInt32 = 0
            
            // 将结果赋值给result
            scanner.scanHexInt(&result)
            
            let char = Character(UnicodeScalar(result))
            
            // 将code转成emoji表情
            emoji = "\(char)"
        }
    }
    
    // emoji表情
    var emoji: String?
    
    // 使用次数
    var times = 0
    
    // false表示空表情, true表示删除按钮
    var removeEmoticon = false
    // 构造方法
    init(removeEmoticon: Bool)
    {
        self.removeEmoticon = removeEmoticon
        
        super.init()
    }
    
    /// 字典转模型
    init(id: String, dict: [String: AnyObject])
    {
        self.id = id
        
        super.init()
        // KVC字典转模型
        setValuesForKeysWithDictionary(dict)
    }
    
    // kvc找不到对应的属性-空实现
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}

}
