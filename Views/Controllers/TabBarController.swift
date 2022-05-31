//
//  TabBarController.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 29/12/21.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = setupViewControllers()
    }
    
    private var moviesTabBar: MoviesViewController = {
        
        let moviesTabBar = MoviesViewController()
        let title = "Movies"
        let defaultImage = UIImage(named: "movie")
        let selectedImage = UIImage(named: "movie")
        
        let tabBarItems = (title: title,
                           image: defaultImage,
                           selectedImage: selectedImage)
        
        let tabBarItem = UITabBarItem(title: tabBarItems.title,
                                      image: tabBarItems.image,
                                      selectedImage: tabBarItems.selectedImage)
        
        moviesTabBar.tabBarItem = tabBarItem
        moviesTabBar.navigationItem.title = title
        return moviesTabBar
    }()
    
    
    private var seriesTabBar: SeriesViewController = {
        
        let seriesTabBar = SeriesViewController()
        let title = "Series"
        let defaultImage = UIImage(systemName: "tv")
        let selectedImage = UIImage(systemName: "tv")
        
        let tabBarItem = UITabBarItem(title: title,
                                      image: defaultImage,
                                      selectedImage: selectedImage)
        
        seriesTabBar.tabBarItem = tabBarItem
        seriesTabBar.navigationItem.title = title
        return seriesTabBar
    }()
    
    
    private var exploreTabBar: ExploreViewController = {
        
        let exploreTabBar = ExploreViewController()
        let title = "Explore"
        let defaultImage = UIImage(systemName: "globe")
        let selectedImage = UIImage(systemName: "globe")
        
        let tabBarItem = UITabBarItem(title: title,
                                      image: defaultImage,
                                      selectedImage: selectedImage)
        
        exploreTabBar.tabBarItem = tabBarItem
        exploreTabBar.navigationItem.title = title
        return exploreTabBar
    }()
    
    
    private var notificationTabBar: NotificationsViewController = {
        
        let notificationTabBar = NotificationsViewController()
        let title = "Notifications"
        let defaultImage = UIImage(systemName: "bell")
        let selectedImage = UIImage(systemName: "bell")
        
        let tabBarItem = UITabBarItem(title: title,
                                      image: defaultImage,
                                      selectedImage: selectedImage)
        
        notificationTabBar.tabBarItem = tabBarItem
        notificationTabBar.navigationItem.title = title
        return notificationTabBar
    }()
    
    
    private func setupViewControllers() -> [UINavigationController]{
        let moviesVC = UINavigationController(rootViewController: moviesTabBar)
        let seriesVC = UINavigationController(rootViewController: seriesTabBar)
        let exploreVC = UINavigationController(rootViewController: exploreTabBar)
        let notificationsVC = UINavigationController(rootViewController: notificationTabBar)
        return [moviesVC, seriesVC, exploreVC, notificationsVC]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }
}
