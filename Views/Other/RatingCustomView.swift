//
//  RatingCustomView.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 7/5/22.
//
import Foundation
import UIKit
import SnapKit

class RatingCustomView: UIView {
    
    private let cView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        return view
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(14)
        return label
    }()
    
    private let imageStar: UIImageView = {
        let image = UIImageView()
        image.tintColor = .white
        image.image = UIImage(systemName: "star.fill")
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(cView)
        self.addSubview(label)
        self.addSubview(imageStar)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        setupView()
    }
    
    private func setupView(){
        cView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(5)
            maker.left.equalToSuperview().inset(5)
            maker.width.equalTo(40)
            maker.height.equalTo(40)
        }
        
        label.snp.makeConstraints { maker in
            maker.centerY.equalTo(cView.snp.centerY)
            maker.top.equalTo(cView.snp.top).offset(5)
            maker.right.equalTo(cView.snp.right).inset(5)
        }
        
        imageStar.snp.makeConstraints { maker in
            maker.height.width.equalTo(15)
            maker.centerY.equalTo(cView.snp.centerY)
            maker.top.equalTo(cView.snp.top).offset(5)
            maker.left.equalTo(cView.snp.left).inset(5)
        }
    }
}
