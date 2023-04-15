//
//  PostTableViewCell.swift
//  onelabhwBlog
//
//  Created by Arnur Sakenov on 04.04.2023.
//

import UIKit
import SnapKit
class PostTableViewCell: UITableViewCell {
    // ...
   private let titleLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.font = UIFont.boldSystemFont(ofSize: 16)
           return label
       }()
       
    private   let bodyLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.numberOfLines = 0
           return label
       }()
    private let id: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.numberOfLines = 0
           return label
       }()
    var imageview:UIImageView = {
        let image = UIImageView()
        return image
    }()
    let stack:UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        return stack
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with note: Note) {
        titleLabel.text = note.title
        bodyLabel.text = note.description
        id.text = note.postId
    }
    private func setupUI() {
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(bodyLabel)
        stack.addArrangedSubview(id)
        stack.addArrangedSubview(imageview)
        addSubview(stack)
        imageview.snp.makeConstraints { make in
            make.height.equalTo(110)
            make.width.equalTo(450)
        }
        stack.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges)
        }
        
    }
}

