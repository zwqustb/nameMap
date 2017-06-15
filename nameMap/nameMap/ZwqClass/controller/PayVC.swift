//
//  PayVC.swift
//  StaffMap
//
//  Created by zhangwenqiang on 2017/3/27.
//  Copyright © 2017年 张文强. All rights reserved.
//

import UIKit

class PayVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ClickZFB(_ sender: UIButton) {
      //  let strApp="alipay://"
        let strPay:String="HTTPS://QR.ALIPAY.COM/FKX040148GXSZPBU8HEWB8"
        let url:URL=URL.init(string:strPay)!
        UIApplication.shared.open(url, options: ["for contact":"for contact"]) { (Bool) in
            
        }
    }
    @IBAction func ClickWX(_ sender: UIButton) {
        //  let strApp="weixin://"+
//        let strPay:String="http://w.url.cn/s/AGXLnTy"
//        let url:URL=URL.init(string:strPay)!
//        UIApplication.shared.open(url, options: ["for contact":"for contact"]) { (Bool) in
//            
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
