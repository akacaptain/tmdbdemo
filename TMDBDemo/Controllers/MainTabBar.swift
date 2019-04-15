//
//  MainTabBar.swift
//  TMDBDemo
//
//  Created by Captain on 4/15/19.
//  Copyright © 2019 Captain. All rights reserved.
//

import Foundation
import CBFlashyTabBarController

class MainTabBar: CBFlashyTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let now_playingVC = MoviesViewController(title: "Now Playing", query_type: .now_playing, navColorOne: UIColor(displayP3Red: 241.0/255.0, green: 39.0/255.0, blue: 17.0/255.0, alpha: 1.0), navColorTwo: UIColor(displayP3Red: 245.0/255.0, green: 175.0/255.0, blue: 25.0/255.0, alpha: 1.0))
        now_playingVC.tabBarItem = UITabBarItem(title: "Now Playing", image: UIImage(named: "now"), tag: 0)
        
        let popularVC = MoviesViewController(title: "Popular", query_type: .popular, navColorOne: UIColor(hexString: "#8E2DE2")!, navColorTwo: UIColor(hexString: "#4A00E0")!)
        popularVC.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(named: "heart"), tag: 0)
        
        let topVC = MoviesViewController(title: "Top Rated", query_type: .top_rated, navColorOne: UIColor(hexString: "#DCE35B")!, navColorTwo: UIColor(hexString: "#45B649")!)
        topVC.tabBarItem = UITabBarItem(title: "Top Rated", image: UIImage(named: "star"), tag: 0)
        
        let upcomingVC = MoviesViewController(title: "Upcoming", query_type: .upcoming, navColorOne: UIColor(hexString: "#FF0099")!, navColorTwo: UIColor(hexString: "#493240")!)
        upcomingVC.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(named: "calendar"), tag: 0)
        
        viewControllers = [setupWithNav(now_playingVC), setupWithNav(popularVC), setupWithNav(topVC), setupWithNav(upcomingVC)]
    }
    
    private func setupWithNav(_ viewController: UIViewController) -> UINavigationController
    {
        return UINavigationController(rootViewController: viewController)
    }
}

extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}
