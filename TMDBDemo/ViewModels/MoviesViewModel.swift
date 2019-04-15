//
//  MoviesViewModel.swift
//  TMDBDemo
//
//  Created by Captain on 4/14/19.
//  Copyright © 2019 Captain. All rights reserved.
//

import Foundation
import UIKit

protocol MoviesViewModelDelegate: class {
    func onFetchCompleted(newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(reason: String)
}

final class MoviesViewModel {
    private weak var delegate: MoviesViewModelDelegate?
    
    private var movies: [Movie] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    let client: TMDBClient
    
    init(query_type: QueryType, delegate: MoviesViewModelDelegate) {
        self.client = TMDBClient(query_type: query_type)
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return movies.count
    }
    
     func movie(at index: Int) -> Movie?
     {
        if index <= movies.count - 1
        {
            return movies[index]
        }
        return nil
     }
    
    func refresh(_ tableView: UITableView)
    {
        movies = []
        total = 0   
        tableView.reloadData()
        isFetchInProgress = false
        currentPage = 1
        getMovies()
    }
    
    func getMovies()
    {
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        client.getMovieData(page: currentPage) { result in
            switch result
            {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.isFetchInProgress = false
                        self.delegate?.onFetchFailed(reason: error.reason)
                    }
 
                case .success(let response):
                    DispatchQueue.main.async {
                        self.currentPage += 1
                        self.isFetchInProgress = false
                        self.total = response.total_results
                        self.movies.append(contentsOf: response.movies)
                        
                        if response.page > 1
                        {
                            let indexPathsToReload = self.calculateIndexPathsToReload(newRecords: response.movies)
                            self.delegate?.onFetchCompleted(newIndexPathsToReload: indexPathsToReload)
                        }
                        else
                        {
                            self.delegate?.onFetchCompleted(newIndexPathsToReload: .none)
                        }
                    }
            }
        }
    }
    
    private func calculateIndexPathsToReload(newRecords: [Movie]) -> [IndexPath]
    {
        let startIndex = movies.count - newRecords.count
        let endIndex = startIndex + newRecords.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
