//
//  ViewController.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 29/12/21.

import UIKit

class MoviesViewController: UIViewController {
    
    private var vm = MoviesViewModel()
    
    private let alamo = AlamofireManager()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    var models = [MovieResponse]()
    
    lazy var leftBarButton = UIBarButtonItem(image: UIImage(named: "menu"),
                                             style: .plain,
                                             target: self,
                                             action: nil)
    
    lazy var rightBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(menuTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requests()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupView(){
        vm.sendMovie = self
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.leftBarButtonItem?.tintColor = .gray
        
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.tintColor = .gray
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MoviesTableViewCell.self,
                           forCellReuseIdentifier: MoviesTableViewCell.identifier)
        tableView.register(TableHeader.self,
                           forHeaderFooterViewReuseIdentifier: TableHeader.identifier)
    }
    
    private func requests(){
        
        vm.getTopRatedMovies()
        
        alamo.getPopular(endPoint: .popular, completion: { (response, error) in
            guard let res = response else { return }
            self.models.append(res)
            self.tableView.reloadData()
        })
        
        alamo.getUpcoming(endPoint: .upcoming, completion: { (response, error) in
            guard let res = response else { return }
            self.models.append(res)
            self.tableView.reloadData()
        })
        
        alamo.getNowPlaying(endPoint: .nowPlaying, completion: { (response, error) in
            guard let res = response else { return }
            self.models.append(res)
            self.tableView.reloadData()
        })
    }
    
    private func setupHierarchy(){
        view.addSubview(tableView)
    }
    
    private func setupLayout(){
        tableView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }
    
    @objc private func menuTapped(){
        print("Does it? ")
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MoviesViewController: UITableViewDelegate {}
extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.identifier,
                                                 for: indexPath) as! MoviesTableViewCell
        
        cell.configure(with: models[indexPath.section].results)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeader.identifier) as! TableHeader
        view.label.text = "Trending now"
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 384 }
        return 225
    }
}

extension MoviesViewController: DataDelegateProtocol {
    func movieResponse(movie: MovieResponse) {
        self.models.append(movie)
        self.tableView.reloadData()
        // TODO: reloadData with the index in tableView
    }
}
