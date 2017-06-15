//
//  contactTools.swift
//  StaffMap
//
//  Created by zhangwenqiang on 2017/5/26.
//  Copyright © 2017年 张文强. All rights reserved.
//

import UIKit
import Contacts
var  g_strColumnName = "GroupId"
var  g_strOrganizationName = "staffMap"
class contactTools: NSObject {
    //mark: 增
    class func createOne(_ pDic:Dictionary<String, Any>) {
        let contact = CNMutableContact()
     //   contact.imageData = Data()
        
        contact.namePrefix = "\(pDic["X"] ?? 0)"
        contact.nameSuffix = "\(pDic["Y"] ?? 0)"
        contact.organizationName = g_strOrganizationName
        contact.departmentName = "\(pDic[g_strColumnName] ?? 0)"
        contact.note="\(pDic["info"] ?? "")"
        if(!contact.note.isEmpty && contact.note != "")
        {
            let pDicInfo = LogicTools.getInfoFromNameDic(pDic as NSDictionary)
            contact.givenName = "\(pDicInfo["name"] ?? "")"
        }
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier:nil)
        try!store.execute(saveRequest)
    }
    class func fetchByName(_ name:String)->[CNContact]
    {
        let store = CNContactStore()
        let contacts = try? store.unifiedContacts(matching: CNContact.predicateForContacts(matchingName: name), keysToFetch:[CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor])
        return contacts!
    }
    class func deleteStaffMapNames()
    {
        let store:CNContactStore = CNContactStore.init()

             //检索条件，检索所有名字中GivenName是W的联系人


        store.requestAccess(for: CNEntityType.contacts) { (granted, error) in
            if (granted == true) {
                let Keys:Array = [CNContactOrganizationNameKey]
                let pRequest:CNContactFetchRequest=CNContactFetchRequest.init(keysToFetch: Keys as [CNKeyDescriptor])
                _ = try? store.enumerateContacts(with: pRequest, usingBlock: { (contact, bStop) in
                    if (g_strOrganizationName == contact.organizationName)
                    {
                        let saveRequest = CNSaveRequest()
                        let contactM:CNMutableContact = contact.mutableCopy() as! CNMutableContact
                        saveRequest.delete(contactM)
                        try!store.execute(saveRequest)
                    }
                })
            }
        }
    }
    class func exportToContact()
    {
        self.deleteStaffMapNames()
        let aryNames=databaseTool.getAllNames();
        for  item in aryNames! {
            var strName:String=""
            if item is NSDictionary
            {
                let dicName:NSDictionary = item as! NSDictionary
                let dicNameInfo:NSDictionary = LogicTools.getInfoFromNameDic(dicName)
                if(dicNameInfo["name"] == nil)
                {
                    self.createOne(dicName as! Dictionary<String, Any> )
                }
                else
                {
                    strName = dicNameInfo["name"] as! String
                    let aryRet:[CNContact]=self.fetchByName(strName)
                    if (aryRet.count == 0)
                    {
                        self.createOne(dicName as! Dictionary<String, Any> )
                        
                }
              }
            }
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "exportComplete"), object: nil)
    }
    class func importFromContact()
    {
        let store:CNContactStore = CNContactStore.init()
        store.requestAccess(for: CNEntityType.contacts) { (granted, error) in
            if (granted == true) {
                let Keys:Array = [CNContactFamilyNameKey,
                                  CNContactMiddleNameKey,
                                  CNContactNoteKey,
                                  CNContactDepartmentNameKey,
                                  CNContactOrganizationNameKey]
                let pRequest:CNContactFetchRequest=CNContactFetchRequest.init(keysToFetch: Keys as [CNKeyDescriptor])
                _ = try? store.enumerateContacts(with: pRequest, usingBlock: { (contact, bStop) in
                    let pInfo = contact.note
                    if (pInfo != "" && g_strOrganizationName == contact.organizationName)
                    {
                        let strGroupID = (contact.departmentName == "" ? "0":contact.departmentName)
                        databaseTool.setCurGroupID(Int(strGroupID)!)
                        let x=UInt(contact.namePrefix)
                        let y=UInt(contact.nameSuffix)
                        databaseTool.insertNameX(x!, y: y!, info: pInfo)
                    }
                })
               NotificationCenter.default.post(name: Notification.Name(rawValue: "importComplete"), object: nil)
            }
        }

    }
}
