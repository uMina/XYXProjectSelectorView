//
//  XYXProjectSelectorView.swift
//  XYXProjectSelectorView
//
//  Created by Teresa on 17/5/8.
//  Copyright © 2017年 Teresa. All rights reserved.
//

import Foundation
import UIKit

protocol XYXProjectSelectorViewDelegate {
    func frameDidChanged(newFrame:CGRect) -> Void
    func didSelect(title:String, shouldRemove:Bool) -> Void
}

class XYXProjectSelectorView: UIView {
    
    //MARK: - Property
    //  UI Property
    struct MinSpacing {
        var row:CGFloat = 6
        var line:CGFloat = 8
    }
    
    struct ViewInsets {
        var top:CGFloat = 0
        var left:CGFloat = 16
        var bottom:CGFloat = 0
        var right:CGFloat = 16
    }
    
    var minSpacing = MinSpacing()
    var viewInsets = ViewInsets(){
        didSet{
            configureUI()
        }
    }
    let XYX_SCREEN_WIDTH = UIScreen.main.bounds.size.width
    
    //  DataSource
    
    var maxSelectedItemCount = 3    //可选择的最大数量
    var defaultItem = "选择项目"{   //默认选择按钮名称
        didSet{
            print(oldValue)
            print(defaultItem)
            if oldValue != defaultItem {
                items.remove(at: items.endIndex-1)
                items.append(defaultItem)
            }
            configureUI()
        }
    }
    fileprivate var items:Array<String> = []    //所有现实出来的结果名称
    let labelBaseTag = 1000         //给按钮们Tag排序
    var delegate : XYXProjectSelectorViewDelegate?
    
    //MARK: - Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(titles:Array<String>?){
        super.init(frame:CGRect.zero)
        configureData(titles: titles)
        configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        configureData(titles: items)
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    //MARK: - Configure Data
    func add(titles:Array<String>,shouldChangeMaxCount:Bool) {
        guard titles.count > 0 else {
            return
        }
        
        if shouldChangeMaxCount == true {
            maxSelectedItemCount = titles.count + items.count
            
            if items.last == defaultItem {
                items.insert(contentsOf: titles, at: items.endIndex-1)
            }else{
                items.append(contentsOf: titles)
            }
            
        }else{
            
            if items.last == defaultItem {
               items.remove(at: items.endIndex-1)
            }
            
            let maxToAdd = maxSelectedItemCount - items.count
            
            switch titles.count {
            case 0..<maxToAdd:
                for item in titles {
                    items.append(item)
                }
                items.append(defaultItem)
            case maxToAdd:
                for item in titles {
                    items.append(item)
                }
            default:
                for index in 0...maxToAdd {
                    items.append(titles[index])
                }
            }
            
        }
        
        configureUI()
    }
    
    fileprivate func configureData(titles:Array<String>?){
        
        if let senderTitles = titles {
            if maxSelectedItemCount < senderTitles.count {
                maxSelectedItemCount = senderTitles.count
            }
            
            switch senderTitles.count {
            case 0:
                items.append(defaultItem)
            case 1 ..< maxSelectedItemCount:
                for item in senderTitles {
                    items.append(item)
                }
                items.append(defaultItem)
            case maxSelectedItemCount:
                items = senderTitles
            default:
                for index in 0...maxSelectedItemCount {
                    items.append(senderTitles[index])
                }
            }
        }else{
            items.append(defaultItem)
        }

    }
    
    //MARK: - Configure UI
    
    fileprivate func configureUI() {
        backgroundColor = UIColor.cyan
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        
        var tagIndex = 0
        for text in items {
            var imageName = ""
            if text == defaultItem{
                imageName = "image_add"
            }else{
                imageName = "image_close"
            }
            
            let button = createButton(tagIndex: tagIndex, title: text, fontSize: 14.0, imageName: imageName)
            addSubview(button)
            
            let buttonSize = button.frame.size
            if tagIndex == 0 {
                button.frame = CGRect(x: viewInsets.left, y: viewInsets.top, width: buttonSize.width, height: buttonSize.height)
                
            } else if let lastButton = self.viewWithTag(labelBaseTag+tagIndex-1){
                
                if lastButton.frame.maxX + minSpacing.line + buttonSize.width + viewInsets.right < frame.width {
                    //不需要换行
                    button.frame = CGRect(x: lastButton.frame.maxX + minSpacing.line, y: lastButton.frame.minY,  width: buttonSize.width, height: buttonSize.height)
                }else{
                    //需要换行
                    button.frame = CGRect(x: viewInsets.left, y: lastButton.frame.maxY + minSpacing.row,  width: buttonSize.width, height: buttonSize.height)
                }
            }
            tagIndex += 1
        }
        
        if let lastButton = self.viewWithTag(labelBaseTag+items.count-1){
            if frame.height != lastButton.frame.maxY + viewInsets.bottom {
                self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: lastButton.frame.maxY + viewInsets.bottom)
                
                if delegate != nil {
                    delegate?.frameDidChanged(newFrame: frame)
                }
            }
        }
    
    }
    
    func createButton(tagIndex:Int, title:String, fontSize:CGFloat, imageName:String) -> UIButton {
        let font = UIFont.systemFont(ofSize: fontSize);
        let imageWidth:CGFloat = 10
        let xSpaceWidth:CGFloat = 20
        let labelWidth = getLabelWidth(labelStr: title, font: font, height: 20)
        let labelHeight:CGFloat = 30
        
        let button = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: labelWidth+imageWidth+xSpaceWidth, height: labelHeight)
        button.tag = tagIndex + labelBaseTag
        button.backgroundColor = UIColor.brown
        button.titleLabel?.font = font
        button.setTitle(title, for: UIControlState.normal)
        button.setImage(UIImage(named:imageName), for: UIControlState.normal)
        button.addTarget(self, action: #selector(clicked), for: UIControlEvents.touchUpInside)
        
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -2*imageWidth, 0, 0)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+imageWidth, 0, 0)
        
        return button
    }
    
    @objc fileprivate func clicked(button:UIButton) {
        print(button.tag)
        
        var shouldRemove = false
        
        if button.title(for: UIControlState.normal) != defaultItem {
            shouldRemove = true
            let tag = button.tag - labelBaseTag
            items.remove(at: tag)
            if items.last != defaultItem {
                items.append(defaultItem)
            }
            
            configureUI()
        }
        
        if delegate != nil {
            delegate?.didSelect(title: button.title(for: UIControlState.normal)!, shouldRemove: shouldRemove)
        }
    }
    
    fileprivate func getLabelWidth(labelStr:String, font:UIFont, height:CGFloat) -> CGFloat {
        
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width:100,height:height)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dic as? [String : Any], context: nil).size
        return strSize.width
        
    }
}
