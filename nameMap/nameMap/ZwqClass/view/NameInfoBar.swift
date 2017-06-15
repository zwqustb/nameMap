//
//  NameInfoBar.swift
//  StaffMap
//
//  Created by zhangwenqiang on 2017/3/21.
//  Copyright © 2017年 张文强. All rights reserved.
//

import UIKit

class NameInfoBar: UITableViewCell {
    
    @IBOutlet weak var contentTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    var oldKey:String=""
    var oldValue:String=""
    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
    @IBAction func KeyDidBegin(_ sender: Any) {
        oldKey=titleTxt.text!
    }
    
    @IBAction func KeyDidEnd(_ sender: Any) {
        if oldKey != titleTxt.text {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "KeyChanged"), object:self)
        }
        
    }
    
    @IBAction func valueEditBegin(_ sender: UITextField) {
        oldValue=sender.text!
    }
    @IBAction func valueEditEnd(_ sender: UITextField) {
        if oldValue != sender.text {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "ValueChanged"), object:self)
        }
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
