//
//  Cookie.swift
//  CookieFactory
//
//  Created by Quinton Quaye on 3/23/21.
//

import Foundation

enum cookieType: String{
    case gingerbread
    case chocolateChip
    case shortbread
}

class Cookie: NSObject{
    var type: cookieType
    
    init(type: cookieType) {
        self.type = type
        super.init()
    }
}
