//
//  MoviesViewController.swift
//  TMDBDemo
//
//  Created by Captain on 4/15/19.
//  Copyright © 2019 Captain. All rights reserved.
//

import Foundation
import UIKit

class MoviesViewController: UIViewController, MoviesViewModelDelegate {
    
    private enum CellIdentifiers {
        static let id = "MovieCell"
    }
    
    private var navColorOne: UIColor
    private var navColorTwo: UIColor
    private var model: MoviesViewModel!
    private var query_type: QueryType
    private var tableView: UITableView!
    private var indicatorView: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    
    init(title:String, query_type: QueryType, navColorOne: UIColor, navColorTwo: UIColor)
    {
        self.navColorOne = navColorOne
        self.navColorTwo = navColorTwo
        self.query_type = query_type
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        refreshControl.addTarget(self, action: #selector(refreshMovieData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarController!.tabBar.frame.height+20, right: 0)
        tableView.contentInset = adjustForTabbarInsets
        tableView.scrollIndicatorInsets = adjustForTabbarInsets
        view.addSubview(tableView)
        
        indicatorView = UIActivityIndicatorView(style: .gray)
        view.addSubview(indicatorView)
        view.bringSubviewToFront(indicatorView)
        indicatorView.startAnimating()
        //tableView.isHidden = true
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(MovieTableCell.self, forCellReuseIdentifier: CellIdentifiers.id)
        
        // initialize the model and perform the first retrieval of movie data
        model = MoviesViewModel(query_type: query_type, delegate: self)
        model.getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let flareGradientImage = CAGradientLayer.primaryGradient(on: navigationController!.navigationBar, colorOne: navColorOne, colorTwo: navColorTwo)
        navigationController!.navigationBar.barTintColor = UIColor(patternImage: flareGradientImage!)
    }
    
    func onFetchCompleted(newIndexPathsToReload: [IndexPath]?)
    {
        refreshControl.endRefreshing()
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            indicatorView.stopAnimating()
            //tableView.isHidden = false
            tableView.reloadData()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(reason: String)
    {
        refreshControl.endRefreshing()
        indicatorView.stopAnimating()
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(title: title , message: reason, actions: [action])
    }
    
    @objc private func refreshMovieData(_ sender: Any)
    {
        indicatorView.startAnimating()
        model.refresh(tableView)
    }
    
}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.id, for: indexPath) as! MovieTableCell
        if let movie = model.movie(at: indexPath.row)
        {
            cell.configure(movie)
        }
        return cell
    }
}

extension MoviesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath])
    {
        if indexPaths.contains(where: isLoadingCell)
        {
            // get the next batch of movies
            model.getMovies()
        }
    }
}

private extension MoviesViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool
    {
        return indexPath.row >= model.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath]
    {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

extension UIViewController {
    func displayAlert(title: String, message: String, actions: [UIAlertAction]? = nil)
    {
        guard presentedViewController == nil else {
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions?.forEach { action in
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
}

extension CAGradientLayer {
    
    class func primaryGradient(on view: UIView, colorOne: UIColor, colorTwo: UIColor) -> UIImage? {
        let gradient = CAGradientLayer()
        var bounds = view.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        return gradient.createGradientImage(on: view)
    }
    
    private func createGradientImage(on view: UIView) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}

