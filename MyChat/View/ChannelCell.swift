//
//  ChannelCell.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 10/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit
import SDWebImage

class ChannelCell: UITableViewCell {

    var channel : Channel? {
          didSet {
              setChannel()
          }
      }
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var latestMsgLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImgView.layer.cornerRadius = profileImgView.frame.width/2
        profileImgView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setChannel() {
        guard let channel = channel else {return }
        let channelVM = ChannelViewModel(channel: channel)
        usernameLabel.text = channelVM.channel.user.username
        latestMsgLabel.text = channelVM.channel.message.text
        profileImgView.sd_setImage(with: channelVM.profileImgURL)
    }
}
