//
//  CommentCell.swift
//  Instagram
//
//  Created by Cheng Xue on 10/12/22.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var commentAuthor: UILabel!
    
    @IBOutlet weak var commentContent: UILabel!
    
    @IBOutlet weak var commentProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
