//
//  NewsViewCell.swift
//  ReignMobileTest
//
//  Created by Sebastian Villahermosa on 23/11/2022.
//

import UIKit

class NewsViewCell: UITableViewCell {
    
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(news: Hits) {
        authorLabel.text = news.author
        createdAtLabel.text = news.createdAt
        storyTitleLabel.text = news.story_title
    }
    
}
