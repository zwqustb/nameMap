//
//  LogicTools.swift
//  StaffMap
//
//  Created by zhangwenqiang on 2017/6/5.
//  Copyright © 2017年 张文强. All rights reserved.
//

import UIKit

class LogicTools: NSObject {
    class func getInfoFromNameDic(_ pDicName:NSDictionary)->NSDictionary {
        
        var strInfo:String = pDicName["info"] as! String
        strInfo = strInfo.replacingOccurrences(of: "&", with: "\"")
        return ZwqTools.string(toDictionary: strInfo)!as  NSDictionary
    }
}
