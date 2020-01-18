//
//  Chat.swift
//  MeetU
//
//  Created by Alexandre dos Santos Rodrigues on 18/01/2020.
//  Copyright © 2020 MeetU Inc. All rights reserved.
//

import Foundation

struct Chat {
    var users: [String]
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension Chat {
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
}
