//
//  AllGroupVC.swift
//  StaffMap
//
//  Created by zhangwenqiang on 2017/3/24.
//  Copyright © 2017年 张文强. All rights reserved.
//

import UIKit

class AllGroupVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var curGroupImg: UIImageView!
    @IBOutlet weak var targetImg: UIImageView!
    var aryData:Array<NSDictionary>=[]
    var dicTargetGroup:NSDictionary=NSDictionary.init()
    var nTargetID:NSInteger=0
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        aryData=databaseTool.getAllGroups() as! Array<NSDictionary>
        let pDic:NSDictionary=aryData[databaseTool.getCurGroupID()]
        curGroupImg.image=UIImage.init(named:( pDic[GroupColumn2] as! String))!
        collectionView.delegate=self;
        collectionView.dataSource=self;
        collectionView! .register(UICollectionViewCell.self, forCellWithReuseIdentifier:"cell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickOK(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "GroupChangeTo"), object: NSNumber.init(value:nTargetID)) //
        _ = self.navigationController?.popViewController(animated: true)
    }
    //colectionView delegate
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (aryData.count)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let pDic:NSDictionary = aryData[indexPath.row]
        
        let pImg:UIImage=UIImage.init(named:( pDic[GroupColumn2] as! String))!
        let pImgView:UIImageView=UIImageView.init(image: pImg)
        pImgView.frame=cell.bounds
        cell.addSubview(pImgView)
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        nTargetID=indexPath.row
        let pDic:NSDictionary = aryData[nTargetID]
        let imgName:String=pDic[GroupColumn2] as! String
        let pImg:UIImage=UIImage.init(named:(imgName))!
        targetImg.image=pImg
        
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
