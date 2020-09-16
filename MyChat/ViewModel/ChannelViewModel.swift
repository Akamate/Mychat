//
//  ChannelViewModel.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 10/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import Foundation

class ChannelViewModel {
    
    let channel : Channel
    
    var profileImgURL : URL? {
        return URL(string: channel.user.profileImgUrl)
    }
    
    init(channel : Channel) {
        self.channel = channel
    }
    
}
