//
//  ViewController.swift
//  CoreTextDemo
//
//  Created by 徐林琳 on 17/4/27.
//  Copyright © 2017年 徐林琳. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addPicTxtView()
    }

    fileprivate func addPicTxtView() {
        let picTxtView = LLPicTxtView(frame: self.view.frame)
        self.view.addSubview(picTxtView)
    }
    
    fileprivate func addDrawTextView() {
        let drawTextView = LLDrawTextView(frame: CGRect(x: 20, y: 150, width: 300, height: 300), pathType: .bezier)
        self.view.addSubview(drawTextView)
    }
    
    fileprivate func addNewLabel() {
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: 400, height: 30))
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.blue
        
        let mutableAttrStr = NSMutableAttributedString(string: "这是一串用来测试的字符串")
        let strAttr = [NSFontAttributeName : UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.red, NSUnderlineStyleAttributeName: 1] as [String : Any]
        
        mutableAttrStr.addAttributes(strAttr, range: NSMakeRange(6, 2))
        label.attributedText = mutableAttrStr
        self.view.addSubview(label)
    }
}

