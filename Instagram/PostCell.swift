//
//  PostCell.swift
//  Instagram
//
//  Created by Cheng Xue on 10/7/22.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postAuthor: UILabel!
    
    @IBOutlet weak var postCaption: UILabel!
    
    @IBOutlet weak var authorImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
