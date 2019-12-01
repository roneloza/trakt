//
//  ReservesCollectionViewController.swift
//  ColturViajes
//
//  Created by Lab Positiva Dev on 11/11/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit
import SDWebImage

class SearchMostPopularMoviesViewController: BaseViewController, ProgressLoaderController, AlertableController, DispatcherController {
    
    private lazy var data: [MostPopularMovieViewModel]? = [MostPopularMovieViewModel]()
    
    @IBOutlet weak var mostPopularMoviesTableView: UITableView?
    @IBOutlet weak var searchBar: UISearchBar?
    private var searchActive : Bool = false
    private var searchQuery : String = ""
    
    private lazy var useCase : SearchMostPopularMoviesUseCaseInput = SearchMostPopularMoviesUseCase(output: self.presenter)
    
    private lazy var presenter: SearchMostPopularMoviesPresenterInput = SearchMostPopularMoviesPresenter(output: self)
    
    private lazy var mostPopularMovieRequest = MostPopularMovieRequest(page: 1)
    
    private lazy var movieDetailUseCase : MovieDetailUseCaseInput = MovieDetailUseCase(output: self)
    
    private lazy var movieVideoUseCase : MovieVideoUseCaseInput = MovieVideoUseCase(output: self)
    
    override var navigationBarHidden: Bool {
        
        get {
            
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupTableView()
    }
    
    // MARK: - UI -
    
    func setupTableView() {
        
        self.mostPopularMoviesTableView?.estimatedRowHeight = 750
        self.mostPopularMoviesTableView?.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Data -
    
    func loadData(query: String) {
        
        self.mostPopularMovieRequest.page = 1
        self.mostPopularMovieRequest.query = query
        self.useCase.searchMostPopularMovies(request: self.mostPopularMovieRequest)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate -
extension SearchMostPopularMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.data?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.data?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MostPopularMovieTableViewCell", for: indexPath) as! MostPopularMovieTableViewCell
        
        cell.titleLabel?.text = item?.title
        cell.yearOfReleaseLabel?.text = item?.year?.description
        cell.overviewLabel?.text = item?.overview
        
        if let posterUrl = item?.posterUrl,
            let posterImageUrl = URL(string: posterUrl) {
            
            cell.posterImageView?.sd_setImage(with: posterImageUrl, completed: { (image, error, type, url) in
                
                cell.posterImageView?.image = image
                cell.posterImageView?.setNeedsLayout()
            })
        }
        else {
            
            self.movieDetailUseCase.getMovieDetail(modelView: item, request: MovieDetailRequest(movieId: (item?.tmdb ?? 0)))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let item = self.data?[indexPath.row]
        
        if indexPath.row == ((self.data?.count ?? 0) - 1) &&
            (self.data?.count ?? 0) >= 10 &&
            !(item?.hasAdditionalData ?? false) {
            
            self.useCase.paginateSearchMostPopularMovies(request: self.mostPopularMovieRequest)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = self.data?[indexPath.row],
            let tmdb = item.tmdb {
            
            self.movieVideoUseCase.getMovieVideo(request: MovieVideoRequest(movieId: tmdb))
        }
    }
}

// MARK: - SearchMostPopularMoviesPresenterOutput -
extension SearchMostPopularMoviesViewController: SearchMostPopularMoviesPresenterOutput {
    
    func willPaginateSearchMostPopularMovies() {
        
        self.showProgress()
    }
    
    func successPaginateSearchMostPopularMovies(data: [MostPopularMovieViewModel]?) {
        
        self.dispatchOnMainQueue {  [weak self] in
            
            if let data = data {
                
                self?.data?.append(contentsOf: data)
                
                self?.mostPopularMoviesTableView?.reloadData()
                
                self?.mostPopularMovieRequest.page = ((self?.mostPopularMovieRequest.page ?? 0) + 1)
            }
        }
    }
    
    func failPaginateSearchMostPopularMovies(error: CustomError) {
        
        self.showAlert(error: error, handler: nil)
    }
    
    func didPaginateSearchMostPopularMovies() {
        
        self.dismissProgress()
    }
    
    func willSearchMostPopularMovies() { }
    
    func successSearchMostPopularMovies(data: [MostPopularMovieViewModel]?) {
        
        self.dispatchOnMainQueue {  [weak self] in
            
            if let data = data {
                
                self?.data = data
                
                self?.mostPopularMoviesTableView?.reloadData()
                
                self?.mostPopularMovieRequest.page = ((self?.mostPopularMovieRequest.page ?? 0) + 1)
            }
        }
    }
    
    func failSearchMostPopularMovies(error: CustomError) {
        
        if let code = error.code {
            
            if code != NSURLErrorCancelled {
                
                self.showAlert(error: error, handler: nil)
            }
        }
        else {
            
            self.showAlert(error: error, handler: nil)
        }
    }
    
    func didSearchMostPopularMovies() { }
    
}

// MARK: - MovieDetailUseCaseOutput -
extension SearchMostPopularMoviesViewController: MovieDetailUseCaseOutput {
    
    func willGetMovieDetail() { }
    
    func successMovieDetail(modelView: MostPopularMovieViewModel?) {
        
        self.dispatchOnMainQueue {  [weak self] in
            
            guard let modelView = modelView,
                let index = self?.data?.firstIndex(of: modelView)
                else { return }
            
            modelView.hasAdditionalData = true
            
            self?.mostPopularMoviesTableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func failGetMovieDetail(error: CustomError) {
        
        self.showAlert(error: error, handler: nil)
    }
    
    func didGetMovieDetail() { }
}

// MARK: - UISearchBarDelegate -
extension SearchMostPopularMoviesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText.count >= 3) {
            
            self.searchQuery = searchText
            
            self.loadData(query: searchText)
        }
    }
}

// MARK: - UMovieVideoUseCaseOutput -
extension SearchMostPopularMoviesViewController: MovieVideoUseCaseOutput {
    
    func willGetMovieVideo() {
        
        self.showProgress()
    }
    
    func successGetMovieVideo(movieUrl: String?, key: String?) {
        
        if let key = key {
            
            self.dispatchOnMainQueue { [weak self] in
                
                self?.playVideo(key: key)
            }
        }
    }
    
    func failGetMovieVideo(error: CustomError) {
        
        self.showAlert(error: error, handler: nil)
    }
    
    func didGetMovieVideo() {
        
        self.dismissProgress()
    }
    
}
