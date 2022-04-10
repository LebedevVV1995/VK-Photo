//
//  NewCinversationCell.swift
//  VK-Photo
//
//  Created by Владимир on 10.04.2022.
//  Copyright © 2022 Владимир. All rights reserved.
//

//
//  NewConversationViewCell.swift
//  ChatApp
//
//  Created by Владимир on 19.01.2022.
//  Copyright © 2022 Владимир. All rights reserved.
//

import Foundation
import SDWebImage

class NewPhotoUserCell: UITableViewCell {
    static let identifire = "NewPhotoUserCell"
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.frame = CGRect(x: 10,
                                     y: 5,
                                     width: 70,
                                     height: 70)

        userNameLabel.frame = CGRect(x: userImageView.reight + 10, //jkjlkjkljkjkklj!!!!!
                                     y: 10,
                                     width: contentView.width - 20 - userImageView.width,
                                     height: 50)
    }
    
    public func configure(with model: SearchResult) {
        self.userNameLabel.text = model.name
        
        let path = "images/\(model.email)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: url, completed: nil)
                }
            case .failure(let error):
                print("failed to get image url:\(error)")
            }
        })
    }
}

