//
//  newGroupVC.swift
//  StaffMap
//
//  Created by zhangwenqiang on 2017/3/20.
//  Copyright © 2017年 张文强. All rights reserved.
//

import UIKit

class newGroupVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    var aryImages:Array<String>?
    var imgName:String="";
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var imgCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.idLabel.text=NSString.init(format: "%d", databaseTool.getNewGroupID()) as String
        aryImages=["Classroom","friends","group","icon","students"]
        imgCollection.delegate=self
        imgCollection.dataSource=self
        imgCollection! .register(UICollectionViewCell.self, forCellWithReuseIdentifier:"cell")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickSave(_ sender: Any) {
        if nameTxt.text==nil {
            nameTxt.text=String.init(format: "group%s", idLabel.text!)
            
        }
        
        databaseTool.insertGroup([NSNumber(value:NSString(string:idLabel.text!).intValue),nameTxt.text ?? "",imgName])
        let dic:Dictionary=["id":idLabel.text ?? "",GroupColumn1:nameTxt.text ?? "",GroupColumn2:imgName]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didAddGroupBtn"), object: self, userInfo: dic)
        _ = self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (aryImages?.count)!
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let pImg:UIImage=UIImage.init(named:( aryImages![indexPath.row] as String))!
        let pImgView:UIImageView=UIImageView.init(image: pImg)
        pImgView.frame=cell.bounds
        cell.addSubview(pImgView)
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        imgName=aryImages![indexPath.row] as String;
        let pImg:UIImage=UIImage.init(named:(imgName))!
        image.image=pImg
        
    }
}
