//
//  ViewController.swift
//  XYXProjectSelectorView
//
//  Created by Teresa on 17/5/8.
//  Copyright © 2017年 Teresa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //初始化方法一：
    //        let selectorView = XYXProjectSelectorView.init(titles:["第一个项目","测试项目B","第三个项目","4444444","第五个","测试6"])
    //初始化方法二：
    let selectorView = XYXProjectSelectorView.init(frame: CGRect(x: 20, y: 100, width: 360, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: 初始化方法一
//        selectorView.frame = CGRect(x: 20, y: 100, width: 360, height: 30)

        //MARK: 初始化方法二
        selectorView.add(titles:  ["第一个项目","测试项目B","第三个项目","4444444","第五个","测试6"], shouldChangeMaxCount: true)
        
        //可选方法
//        selectorView.viewInsets.top = 10.0
//        selectorView.viewInsets.bottom = 10.0
        selectorView.defaultItem = "添加吧"
        selectorView.backgroundColor = UIColor.init(red: 241/255.0, green: 201/255.0, blue: 202/255.0, alpha: 1)
        
        //代理
        selectorView.delegate = self
        view.addSubview(selectorView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:XYXProjectSelectorViewDelegate{
    func frameDidChanged(newFrame: CGRect) {
        print("最新frame是\(newFrame)")
    }
    func didSelect(title: String, shouldRemove: Bool) {
        print("被点击的是\(title), shouldRemove = \(shouldRemove)")
        if shouldRemove == false {
            selectorView.add(titles: ["新增一个"], shouldChangeMaxCount: false)
        }
    }
}

