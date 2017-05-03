//
//  XLLDisplayView.swift
//  CoreTextDemo
//
//  Created by 徐林琳 on 17/4/27.
//  Copyright © 2017年 徐林琳. All rights reserved.
//

import UIKit
enum PathType {
    case cgPath
    case bezier
}

class LLDrawTextView: UIView {
    fileprivate var pathType = PathType.cgPath
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blue
    }
    
    convenience init(frame: CGRect, pathType: PathType) {
        self.init(frame: frame)
        self.pathType = pathType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawText()
    }

    fileprivate func drawText() {
        let attrString = NSMutableAttributedString(string: "Hello CoreText!")
        
        let ctx = UIGraphicsGetCurrentContext()
        
        // 翻转
        ctx?.textMatrix = CGAffineTransform.identity
        ctx?.translateBy(x: 0, y: bounds.size.height)
        ctx?.scaleBy(x: 1, y: -1)

        switch pathType {
        case .cgPath:
            // 创建绘制区域
            let path = CGMutablePath()
            path.addRect(self.bounds)
            
            let framesetter = CTFramesetterCreateWithAttributedString(attrString)
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path as CGPath, nil)
            
            CTFrameDraw(frame, ctx!)
        case .bezier:
            let path1 = UIBezierPath(roundedRect: self.bounds, cornerRadius:150 )
            
            let attrString = "CoreText从绘制纯文本到绘制图片，依然是使用NSAttributedString，只不过图片的实现方式是用一个空白字符作为在NSAttributedString中的占位符，然后设置代理，告诉CoreText给该占位字符留出一定的宽高。最后把图片绘制到预留的位置上。CoreText从绘制纯文本到绘制图片，依然是使用NSAttributedString，只不过图片的实现方式是用一个空白字符作为在NSAttributedString中的占位符，然后设置代理，告诉CoreText给该占位字符留出一定的宽高。最后把图片绘制到预留的位置上。CoreText从绘制纯文本到绘制图片，依然是使用NSAttributedString，只不过图片的实现方式是用一个空白字符作为在NSAttributedString中的占位符，然后设置代理，告诉CoreText给该占位字符留出一定的宽高。最后把图片绘制到预留的位置上。"

            
            let mutableAttrStr = NSMutableAttributedString(string: attrString)
            mutableAttrStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 14),
                                          NSForegroundColorAttributeName:UIColor.red ], range: NSMakeRange(0, 20))
            mutableAttrStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 13),NSUnderlineStyleAttributeName: 1 ], range: NSMakeRange(20,18))
            
            let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttrStr.length), path1.cgPath, nil)
            CTFrameDraw(frame, ctx!)
        }
        
    }

}
