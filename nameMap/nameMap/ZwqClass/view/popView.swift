//
//  popView.swift
//  StaffMap
//
//  Created by zhangwenqiang on 2017/3/13.
//  Copyright © 2017年 张文强. All rights reserved.
//

import UIKit
class popView: UIImageView {
    var subItems: [UIImageView]=Array.init();
    var ButView:UIView?=nil;
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setItems(items:Array<String>)->Bool
    {
        for item in items {
            let SubView:UIImageView=UIImageView.init(frame:CGRect.init(x: 0, y: 0, width: 100, height: 100))
            SubView.image=UIImage.init(contentsOfFile: item)
            subItems.append(SubView)
            
        }
        return true;
    }
    func popViews() -> Bool {
        let ScreenView=UIApplication.shared.keyWindow?.rootViewController?.view
        ButView=UIView.init(frame:(ScreenView?.bounds)!)
        ButView?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:Selector(("onTap:"))))
        ScreenView?.addSubview(ButView!)
        let rtPop:CGRect=(self.superview?.convert(self.frame, to:ScreenView))!
        let ptDir:CGPoint=self.getPopOrientation(rect:rtPop,Bound:(ScreenView?.bounds)!)
        for item in self.subItems {
            ButView?.addSubview(item)
//            if abs(ptDir.x)==2 {
//                ptDir.y = 0
//            }
//            else
//            {
//                ptDir.x=0
//            }
            let i:CGFloat=CGFloat(subItems.index(of: item)!)
            let t:CGAffineTransform=CGAffineTransform.init(translationX: ptDir.x*self.frame.size.width*i, y: ptDir.y*self.frame.size.height*i)
            item.center.applying(t)
        }
        return true;
    }
    func shrinkViews() -> Void {
        ButView?.removeFromSuperview()
    }
    func getPopOrientation(rect:CGRect,Bound:CGRect) -> CGPoint {
        var x:Int=1
        var y:Int=1
        let ScreenView=UIApplication.shared.keyWindow?.rootViewController?.view
        
        let a=self.frame.origin.x;
        let b=self.frame.origin.y;
        let c=(ScreenView?.frame.size.width)!-rect.maxX
        let d=(ScreenView?.frame.size.height)!-rect.maxY
        if a>c {
            x = -1
        }
        if b>d {
            y = -1
        }
        if max(a, c)>max(b,d) {
           // x*=2
            y=0
        }else{
            //y*=2
            x=0
        }
        return CGPoint.init(x: x, y: y)
    }
    func onTap(pTap:UIGestureRecognizer) -> Void {
        self.shrinkViews();
        self.handleTap();
    }
    func handleTap() -> Void {
        
    }
}
