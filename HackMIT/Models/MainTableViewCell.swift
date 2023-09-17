//
//  MainTableViewCell.swift
//  HackMIT
//
//  Created by yahia salman on 9/16/23.
//

import Foundation
import UIKit


class MainTableViewCell: UITableViewCell {
    
    static let identifier = "MainTableViewCell"
    
    
    
    
    var label : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "yoyo"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let status: UIView = {
        let status = UIView()
        status.backgroundColor = .systemRed
        status.layer.cornerRadius  = 3
        return status
    }()
    
    private let emotion: UILabel = {
        let emotion = UILabel()
        emotion.font = .systemFont(ofSize: 15, weight: .medium)
        emotion.text = "happy"
        emotion.textColor = .black
        return emotion
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureMainCell(with name: String, and emotion: String, and status: String) {
        if(status == "present"){
            self.status.backgroundColor = .systemGreen
        } else{
            self.status.backgroundColor = .systemRed
        }
//        self.myImageView.maskCircle(anyImage: image)
        
        self.label.text = name
        
        if(emotion == "happy" || emotion == "sad" || emotion == "neutral"){
            self.emotion.text = "not confused"
        } else {
            self.emotion.text = "confused"
        }
        
    }
    
    private func setupUI(){
        self.addSubview(label)
        self.addSubview(status)
        self.addSubview(emotion)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        status.translatesAutoresizingMaskIntoConstraints = false
        emotion.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            label.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
//            label.widthAnchor.constraint(equalToConstant: 50),
//            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            emotion.topAnchor.constraint(equalTo: label.topAnchor),
            emotion.bottomAnchor.constraint(equalTo: label.bottomAnchor),
//            emotion.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20),
            emotion.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            emotion.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            emotion.widthAnchor.constraint(equalTo: label.widthAnchor)
            
            status.topAnchor.constraint(equalTo: emotion.topAnchor),
            status.bottomAnchor.constraint(equalTo: emotion.bottomAnchor),
            status.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor, constant: -10),
            status.widthAnchor.constraint(equalToConstant: 60),
//            status.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        
            
        ])
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       }
    
}
