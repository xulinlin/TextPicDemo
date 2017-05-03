//
//  LLPicTxtView.swift
//  CoreTextDemo
//
//  Created by 徐林琳 on 17/4/27.
//  Copyright © 2017年 徐林琳. All rights reserved.
//

import UIKit

class LLPicTxtView: UIView {
    fileprivate var image: UIImage? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawPicTxt()
    }
    
    fileprivate func drawPicTxt() {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // 翻转
        ctx.textMatrix = CGAffineTransform.identity
        ctx.translateBy(x: 0, y: bounds.size.height)
        ctx.scaleBy(x: 1, y: -1)
        
        // 3 绘制区域
        let path = UIBezierPath(rect: bounds)
        
        // 4 创建需要绘制的文字
        let attrString = "CoreText从绘制纯文本到绘制图片，依然是使用NSAttributedString，只不过图片的实现方式是用一个空白字符作为在NSAttributedString中的占位符，然后设置代理，告诉CoreText给该占位字符留出一定的宽高。最后把图片绘制到预留的位置上。CoreText从绘制纯文本到绘制图片，依然是使用NSAttributedString，只不过图片的实现方式是用一个空白字符作为在NSAttributedString中的占位符，然后设置代理，告诉CoreText给该占位字符留出一定的宽高。最后把图片绘制到预留的位置上。CoreText从绘制纯文本到绘制图片，依然是使用NSAttributedString，只不过图片的实现方式是用一个空白字符作为在NSAttributedString中的占位符，然后设置代理，告诉CoreText给该占位字符留出一定的宽高。最后把图片绘制到预留的位置上"
        
        let mutableAttrStr = NSMutableAttributedString(string: attrString)
        mutableAttrStr.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 18),
                                      NSForegroundColorAttributeName: UIColor.red], range: NSMakeRange(0, 10))
        mutableAttrStr.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 20), NSUnderlineStyleAttributeName: 1], range: NSMakeRange(10, 5))
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        mutableAttrStr.addAttributes([NSParagraphStyleAttributeName: style], range: NSMakeRange(0, mutableAttrStr.length))
        
        var imageName = "icon_05"
        var imageCallBack = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: {
            refCon in
            
        }, getAscent: {
            refCon in
            return 100  //高度
        }, getDescent: {
            refCon in
            return 50  // 底部距离
        }, getWidth: {
            refCon in
            return 100  // 宽度
        })
        let runDelegate  = CTRunDelegateCreate(&imageCallBack, &imageName)
        let imgString = NSMutableAttributedString(string: " ")  // 空格用于给图片留位置
        imgString.addAttributes([kCTRunDelegateAttributeName as String: runDelegate!], range: NSMakeRange(0, 1)) //rundelegate  占一个位置
        imgString.addAttribute("imageName", value: imageName, range: NSMakeRange(0, 1))//添加属性，在CTRun中可以识别出这个字符是图片
        mutableAttrStr.insert(imgString, at: 15)
        
        //网络图片相关
        var  imageCallback1 =  CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { (refCon) -> Void in
            
        }, getAscent: { ( refCon) -> CGFloat in
            return 70  //返回高度
            
        }, getDescent: { (refCon) -> CGFloat in
            
            return 50  //返回底部距离
            
        }) { (refCon) -> CGFloat in
            return 100  //返回宽度
            
        }
        var imageUrl = "http://img3.3lian.com/2013/c2/64/d/65.jpg" //网络图片链接
        let urlRunDelegate  = CTRunDelegateCreate(&imageCallback1, &imageUrl)
        let imgUrlString = NSMutableAttributedString(string: " ")  // 空格用于给图片留位置
        imgUrlString.addAttribute(kCTRunDelegateAttributeName as String, value: urlRunDelegate!, range: NSMakeRange(0, 1))  //rundelegate  占一个位置
        imgUrlString.addAttribute("urlImageName", value: imageUrl, range: NSMakeRange(0, 1))//添加属性，在CTRun中可以识别出这个字符是图片
        mutableAttrStr.insert(imgUrlString, at: 50)
        
        // 6 生成framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttrStr.length), path.cgPath, nil)
        
        // 7 绘制除图片以外的部分
        CTFrameDraw(frame,ctx)
    
        // 8 处理绘制图片逻辑
        let lines = CTFrameGetLines(frame) as NSArray //存取frame中的ctlines
        
        
        let ctLinesArray = lines as Array
        var originsArray = [CGPoint](repeating: CGPoint.zero, count:ctLinesArray.count)
        let range: CFRange = CFRangeMake(0, 0)
        CTFrameGetLineOrigins(frame,range,&originsArray)
        
        //遍历CTRun找出图片所在的CTRun并进行绘制,每一行可能有多个
        for i in 0..<lines.count{
            //遍历每一行CTLine
            let line = lines[i]
            var lineAscent = CGFloat()
            var lineDescent = CGFloat()
            var lineLeading = CGFloat()
            //该函数除了会设置好ascent,descent,leading之外，还会返回这行的宽度
            CTLineGetTypographicBounds(line as! CTLine, &lineAscent, &lineDescent, &lineLeading)
            
            let runs = CTLineGetGlyphRuns(line as! CTLine) as NSArray
            for j in 0..<runs.count{
                // 遍历每一个CTRun
                var  runAscent = CGFloat()
                var  runDescent = CGFloat()
                let  lineOrigin = originsArray[i]// 获取该行的初始坐标
                let run = runs[j] // 获取当前的CTRun
                let attributes = CTRunGetAttributes(run as! CTRun) as NSDictionary
                
                let width =  CGFloat( CTRunGetTypographicBounds(run as! CTRun, CFRangeMake(0,0), &runAscent, &runDescent, nil))
                
                let  runRect = CGRect(x: lineOrigin.x + CTLineGetOffsetForStringIndex(line as! CTLine, CTRunGetStringRange(run as! CTRun).location, nil), y: lineOrigin.y - runDescent, width: width, height: runAscent + runDescent)
                let imageNames = attributes.object(forKey: "imageName")
                let urlImageName = attributes.object(forKey: "urlImageName")
                
                if imageNames is NSString {
                    //本地图片
                    if let cgImage = UIImage(named: imageName)?.cgImage {
                        let imageDrawRect = CGRect(x: runRect.origin.x, y: lineOrigin.y-runDescent, width: 100, height: 100)
                        ctx.draw(cgImage, in: imageDrawRect)
                    }
                }
                
                if let urlImageName = urlImageName as? String{
                    var image:UIImage?
                    let imageDrawRect = CGRect(x: runRect.origin.x, y: lineOrigin.y-runDescent, width: 100, height: 100)
                    if self.image == nil{
                        image = UIImage(named:"icon_05") //灰色图片占位
                        //去下载
                        if let url = URL(string: urlImageName){
                            let request = URLRequest(url: url)
                            let task = URLSession.shared.dataTask(with: request) {
                                (data, resp, err) in
                                if let data = data{
                                    DispatchQueue.main.async {
                                        self.image = UIImage(data: data)
                                        self.setNeedsDisplay()  //下载完成会重绘
                                    }
                                }
                            }
                            task.resume()
                        }
                    }else{
                        image = self.image
                    }

                    ctx.draw((image?.cgImage)!, in: imageDrawRect)
                }
            }
        }
 
    }
    
}
