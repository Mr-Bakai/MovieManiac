//
//  Helpers.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 6/1/22.
//

import Foundation
import UIKit
import SnapKit

final class HeaderCollectionReusableView: UICollectionReusableView{
    
    static let identifier = "HeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Trending now"
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    public func configure(){
        backgroundColor = .systemPink
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}





// MARK: - Table Headers
class TableHeader: UITableViewHeaderFooterView {
    
    static let identifier = "HeaderTableView"
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Trending now"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 34.0)
        label.textColor = .gray
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        contentView.addSubview(label)
        
        label.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(15)
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
}
