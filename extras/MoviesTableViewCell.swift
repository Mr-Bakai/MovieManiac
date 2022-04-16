//
//  MoviesTableViewCell.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 6/1/22.
//

import Foundation
import Kingfisher

//final class MoviesTableViewCell: UITableViewCell {
//
//    static let identifier = "MoviesTableViewCell"
//    var models = [TopRatedMovies]()
//
//    lazy var collectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero,
//                                              collectionViewLayout: collectionViewLayout())
//
//        collectionView.register(MoviesCollectionViewCell.self,
//                                forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
//        collectionView.backgroundColor = .black
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        setupViews()
//        setupHierarchy()
//        setupLayout()
//    }
//
//    func configure(with models: [TopRatedMovies]){
//        self.models = models
//        collectionView.reloadData()
//    }
//
//    private func setupViews(){
//        collectionView.register(HeaderCollectionReusableView.self,
//                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//                                withReuseIdentifier: HeaderCollectionReusableView.identifier)
//    }
//
//    private func setupHierarchy(){
//        contentView.addSubview(collectionView)
//    }
//
//    private func  setupLayout(){
//        collectionView.snp.makeConstraints { maker in
//            maker.top.equalToSuperview()
//            maker.bottom.equalToSuperview()
//            maker.leading.equalToSuperview()
//            maker.trailing.equalToSuperview()
//        }
//    }
//}
//
//extension MoviesTableViewCell: UICollectionViewDelegate,
//                         UICollectionViewDataSource,
//                         UICollectionViewDelegateFlowLayout{
//
//    // MARK: -Collection
//    func collectionView(_ collectionView: UICollectionView,
//                        numberOfItemsInSection section: Int) -> Int {
//        guard models.count > 0 else { return 0 }
//        return models.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: MoviesCollectionViewCell.identifier,
//            for: indexPath) as! MoviesCollectionViewCell
//        cell.configure(with: models[indexPath.row])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.section == 0 { return CGSize(width: 256, height: 384) }
//        return CGSize(width: 150, height: 225)
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//}
//
//extension MoviesTableViewCell {
//
//    private func collectionViewLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewFlowLayout()
//
//        let cellWidthHeightConstant: CGFloat = UIScreen.main.bounds.width * 0.2
//        layout.sectionInset = UIEdgeInsets(top: 0,
//                                           left: 10,
//                                           bottom: 0,
//                                           right: 10)
//        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 10
//        layout.itemSize = CGSize(width: cellWidthHeightConstant,
//                                 height: 225)
//        return layout
//    }
//}
