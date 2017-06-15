//
//  EditInfoVC.swift
//  StaffMap
//
//  Created by zhangwenqiang on 2017/3/9.
//  Copyright © 2017年 张文强. All rights reserved.
//

import UIKit

class EditInfoVC: UIViewController,popViewDelegate,UITableViewDelegate,UITableViewDataSource {
    var CurNameButton:NameButton?=nil
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var HeadImg: headImg!
    
    @IBOutlet weak var infoList: UITableView!
    
    var aryData:Array<String> = []
    var aryKeys:Array<Any> = []
    var aryValues:Array<Any>=[]
    var ImgName:String?
//    func EditInfoVC() -> EditInfoVC {
//    return self;
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let action1:Selector = #selector(EditInfoVC.keyChanged(Note:))
        let action2:Selector = #selector(EditInfoVC.valueChanged(Note:))
        NotificationCenter.default.addObserver(self,
                                               selector:action1,//Selector(("keyChanged:")),
                                               name: NSNotification.Name("KeyChanged"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:action2,
                                               name: NSNotification.Name("ValueChanged"),
                                               object: nil)
        let action:Selector = #selector(EditInfoVC.onTap(pTap:))
        HeadImg .addGestureRecognizer(UITapGestureRecognizer(target: self, action:action))
        HeadImg.delegate=self;
        
        if((CurNameButton) != nil)
        {
            nameTxt.text=CurNameButton?.nameLabel.text;
            ImgName=CurNameButton?.dicNameInfo["ImgName"] as! String?
            if (ImgName != nil)
            {
                HeadImg.image=UIImage.init(named: ImgName!)
                var pStrInfo=CurNameButton?.strInfo
                pStrInfo=pStrInfo?.trimmingCharacters(in: CharacterSet.init(charactersIn: "{"))
                aryData=(pStrInfo?.components(separatedBy: ","))!
                var aryTemp:Array<String>=[]
                for item:String in aryData {
                    let strTemp=item.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    if strTemp.hasPrefix("\"name\""){}
                    else if strTemp.hasPrefix("\"ImgName\""){}//ImgName\":"){}
                    else{
                        aryTemp.append(strTemp)
                    }
                }
                aryData=aryTemp;
            }
        }
        
        nameTxt.resignFirstResponder()
        infoList.dataSource=self;
        infoList.delegate=self;
       // infoList.register(NameInfoBar.self, forCellReuseIdentifier: "infoCell")
        infoList.register(UINib(nibName:"NameInfoBar",bundle:nil), forCellReuseIdentifier: "infoCell")
     //   infoList.isEditing=true;
        let rightBar1 = UIBarButtonItem.init(barButtonSystemItem:UIBarButtonSystemItem.save, target: self, action: #selector(EditInfoVC.clickSave(_:)))
        let rightBar2 = UIBarButtonItem.init(barButtonSystemItem:UIBarButtonSystemItem.add, target: self,  action: #selector(EditInfoVC.clickAdd(_:)))
        self.navigationItem.rightBarButtonItems=[rightBar1,rightBar2]
        // Do any additional setup after loading the view.
    }
    func onTap(pTap:UITapGestureRecognizer) -> Void {
        HeadImg.popViews()
    }
    public func handleSubitemDidTap( _ nIndex:Int)->Void
    {
        let aryImgNames:Array=headImg.defaultHeadImgAry()
        if (nIndex<aryImgNames.count)
        {
            ImgName=aryImgNames[nIndex] as? String
        }
        else
        {
            NSLog("名字数组越界了");
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickSave(_ sender: UIButton) {
        if (CurNameButton != nil) {
            CurNameButton?.nameLabel?.text=nameTxt.text
            CurNameButton?.selImage=UIImage.init(named:ImgName!)
            CurNameButton?.normalImage=UIImage.init(named:ImgName!)
            CurNameButton?.dicNameInfo.removeAll()
            CurNameButton?.dicNameInfo["name"]=nameTxt.text;
            CurNameButton?.dicNameInfo["ImgName"]=ImgName
            if aryData.count>0 {
                for i in 0...aryData.count-1
                {
                    let strData:String=aryData[i]
                    let strKey=self.getKey(from: strData)
                    let strValue=self.getValue(from: strData)
                    CurNameButton?.dicNameInfo[strKey]=strValue
                }
            }

            CurNameButton?.strInfo=ZwqTools.dictionary(toString: CurNameButton?.dicNameInfo)
            let pInfo=CurNameButton?.strInfo.replacingOccurrences(of: "\"", with: "&")
            databaseTool.updateName(byID: (CurNameButton?.id)!, info:pInfo)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickAdd(_ sender: UIButton) {
        let pInfoBar = (Bundle.main.loadNibNamed("NameInfoBar", owner: nil, options: nil)!.first as? NameInfoBar)!
        pInfoBar.frame=CGRect.init(x: 0, y: HeadImg!.frame.maxY, width: self.view.frame.size.width, height: pInfoBar.frame.size.height)
        let nDicCount:Int=(CurNameButton?.dicNameInfo.count)!
        let newKey:String=String(describing: nDicCount)
        CurNameButton?.dicNameInfo[newKey]=""
        aryData.append(newKey+":")
        infoList.reloadData()
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nCount=aryData.count;
        return nCount;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier : String = "infoCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NameInfoBar
//        let dicInfo=CurNameButton?.dicNameInfo
//        _=Array(dicInfo!.keys)
        if aryData.count>indexPath.row
        {
            let strCur:String=aryData[indexPath.row]
            cell.titleTxt.text=self.getKey(from: strCur)
            cell.oldKey=cell.titleTxt.text!;
            cell.contentTxt.text=self.getValue(from: strCur)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle==UITableViewCellEditingStyle.delete {
            aryData.remove(at: indexPath.row)
            tableView .deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }

    
    func keyChanged(Note:Notification)  {
        let pCurInfoBar=Note.object as! NameInfoBar
        let pNewKey:String=pCurInfoBar.titleTxt.text!
        let pOldKey:String=self.formatString(pCurInfoBar.oldKey)
        let pNewValue:String=pCurInfoBar.contentTxt.text!
        var aryTemp:Array<String>=[]
        for item:String in aryData {
            let pKey:String=self.getKey(from: item)
            var strTemp:String=item
            if pKey.hasPrefix(pOldKey) {
                strTemp=pNewKey+":"+pNewValue
                CurNameButton?.dicNameInfo[pCurInfoBar.titleTxt]=pCurInfoBar.contentTxt.text
            }
            aryTemp.append(strTemp)
        }
        aryData=aryTemp
    }
    func valueChanged(Note:Notification)  {
            keyChanged(Note: Note)
    }
    func getKey(from str:String)->String
    {
        let strKey=str.substring(to:(str.range(of: ":")?.lowerBound)!)
        return self.formatString(strKey)
    }
    func getValue(from str:String)->String
    {
        let strValue=str.substring(from: (str.range(of: ":")?.upperBound)!)
        return self.formatString(strValue)
    }
    func formatString(_ str:String)->String
    {
        return str.trimmingCharacters(in: CharacterSet.init(charactersIn: "\"\\{ \n}"))
    }
}
