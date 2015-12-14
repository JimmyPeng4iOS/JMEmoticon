//
//  EmoticonViewController.swift
//  JMEmoticon
//
//  Created by Jimmy on 15/11/12.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

import UIKit

class EmoticonViewController: UIViewController
{
    
    // MARK: 属性
    
    weak var textView: UITextView?
    
    private let ReuseIdentifier = "EmoticonCell"
    
    /// 按钮的tag起始值
    private let baseTag = 1000
    
    /// 所有表情包模型
    private let packages = EmoticonPackage.packages
    
    /// 构造方法
    init(textView: UITextView)
    {
        self.textView = textView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        prepareUI()
    }
    
    // 准备UI
    private func prepareUI()
    {
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        // 添加约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        // VLF
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cl]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["cl" : collectionView]))
        
        // toolBar水平方向, 左右都距离父控件0
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tb" : toolBar]))
        
        // 垂直方向.
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cl]-0-[tb(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["cl" : collectionView, "tb": toolBar]))
        
        // 设置toolBar内容
        setupToolBar()
        
        // 设置collectionView
        setupCollectionView()
    }
    
    /// 设置toolBar内容
    private func setupToolBar()
    {
        
        var items = [UIBarButtonItem]()
        // 按钮的tag
        var index = baseTag
        
        // 获取表情包模型的名称
        for package in packages
        {
            // 获取每个表情包的名称
            let title = package.group_name_cn
            
            // 创建按钮
            let button = UIButton()
            
            // 设置文字
            button.setTitle(title, forState: UIControlState.Normal)
            
            // 设置颜色
            button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
            button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Selected)
            
            // 按钮适应文字大小
            button.sizeToFit()
            
            // 添加点击事件
            button.addTarget(self, action: "itemClick:", forControlEvents: UIControlEvents.TouchUpInside)
            
            // 设置tag
            button.tag = index
            
            // 最近按钮默认高亮
            if index == baseTag {
                switchSelectedButton(button)
            }
            
            // 创建 UIBarButtonItem
            let item = UIBarButtonItem(customView: button)
            
            // 添加item到数组
            items.append(item)
            
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
            
            index++
        }
        
        // 移除最后一根弹簧
        items.removeLast()
        
        // 将items数组赋值给toolBar
        toolBar.items = items
    }
    
    // 按钮点击事件
    func itemClick(button: UIButton)
    {
        // 切换到对应的表情包的第一页表情
        let indexPath = NSIndexPath(forItem: 0, inSection: button.tag - baseTag)
        collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.Left)
        
        // 按钮高亮
        switchSelectedButton(button)
    }
    
    /**
     切换选中的按钮,让按钮高亮
     
     - parameter button: 要选中的按钮
     */
    private func switchSelectedButton(button: UIButton)
    {
        // 恢复原有
        selectedButton?.selected = false
        
        // 按钮选中
        button.selected = true
        
        // 赋值
        selectedButton = button
    }
    
    private var selectedButton: UIButton?
    
    /// 设置collectionView
    private func setupCollectionView()
    {
        // 设置背景
        collectionView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        // 注册cell
        collectionView.registerClass(EmocitonCell.self, forCellWithReuseIdentifier: ReuseIdentifier)
        
        // 数据源和代理
        collectionView.dataSource = self
        
        // 设置代理
        collectionView.delegate = self
    }
    
    // MARK: - 懒加载
    /// collectionView
    private lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonLayout())
    
    /// toolBar
    private lazy var toolBar: UIToolbar = UIToolbar()
}

// 自定义流水布局
class EmoticonLayout: UICollectionViewFlowLayout
{
    override func prepareLayout()
    {
        
        let width = collectionView!.bounds.width / 7
        
        let height = collectionView!.bounds.height / 3
        
        // layout的item大小
        itemSize = CGSize(width: width, height: height)
        // collectionView水平滚动
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        //间距
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        // 取消弹簧效果
        collectionView?.bounces = false
        // 取消滚动条
        collectionView?.showsHorizontalScrollIndicator = false
        // 分页
        collectionView?.pagingEnabled = true
    }
}

//MARK: - 代理
extension EmoticonViewController: UICollectionViewDataSource, UICollectionViewDelegate
{
    // 返回组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return packages.count
    }
    
    // 每一组
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        // 获取到每一组对应的表情包模型
        let package = packages[section]
        return package.emoticons.count
    }
    
    // 返回cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifier, forIndexPath: indexPath) as! EmocitonCell
        
        // 获取表情包里面的表情
        let emoticon = packages[indexPath.section].emoticons[indexPath.item]
        
        // 设置cell的模型
        cell.emoticon = emoticon
        
        return cell
    }
    
    // 监听collectionView停止滚动
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        
        let indexPath = collectionView.indexPathsForVisibleItems().first!
        
        // 按钮的tag是从1000(baseTag)开始的.
        let button = toolBar.viewWithTag(indexPath.section + baseTag) as! UIButton
        
        switchSelectedButton(button)
    }
    
    /// cell被点击
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
        let emoticon = packages[indexPath.section].emoticons[indexPath.item]
        
        // 插入表情
        textView?.insertEmoticon(emoticon)
        
        // 最近表情列表不需要排序
        if indexPath.section != 0
        {
            // 添加到最近表情
            EmoticonPackage.addFavorate(emoticon)
        }
        
    }
    
}

// 自定义表情键盘的cell
class EmocitonCell: UICollectionViewCell
{
    var emoticon: Emoticon? {
        didSet
        {
            // 视图根据模型来显示内容
            if emoticon?.pngPath != nil
            {    // 设置表情图片
                emoticonButton.setImage(UIImage(contentsOfFile: emoticon!.pngPath!), forState: UIControlState.Normal)
            }
            else
            {    // 没有图片
                emoticonButton.setImage(nil, forState: UIControlState.Normal)
            }
            
            emoticonButton.setTitle(emoticon?.emoji, forState: UIControlState.Normal)
            
            // 如果是删除按钮,显示删除按钮图片
            let deletePath = EmoticonPackage.bundlePath + "/compose_emotion_delete.imageset/compose_emotion_delete.png"
            
            if emoticon!.removeEmoticon
            {
                emoticonButton.setImage(UIImage(contentsOfFile:deletePath), forState: UIControlState.Normal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        prepareUI()
    }
    
    // 准备UI
    private func prepareUI()
    {
        // 添加子控件
        contentView.addSubview(emoticonButton)
        
        emoticonButton.frame = CGRectInset(bounds, 6, 6)
        
        emoticonButton.titleLabel?.font = UIFont.systemFontOfSize(32)
        
        // 禁止按钮可以和用户交互
        emoticonButton.userInteractionEnabled = false
    }
    
    /// 按钮
    private lazy var emoticonButton = UIButton()
    
}