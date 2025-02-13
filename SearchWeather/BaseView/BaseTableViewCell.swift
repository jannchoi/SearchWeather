//
//  BaseTableViewCell.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        configureHierachy()
        configureLayout()
        configureView()
    }
    
    func configureHierachy() { }
    func configureLayout() { }
    func configureView() { }

}
