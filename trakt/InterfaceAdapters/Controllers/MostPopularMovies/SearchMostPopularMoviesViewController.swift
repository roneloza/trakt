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
    
    private lazy var mostPopularMoviesUseCase : MostPopularMoviesUseCaseInput = MostPopularMoviesUseCase(output: self.mostPopularMoviesPresenter)
    
    private lazy var mostPopularMoviesPresenter: MostPopularMoviesPresenterInput = MostPopularMoviesPresenter(output: self)
    
    private lazy var mostPopularMovieRequest = MostPopularMovieRequest(page: 1)
    
    private lazy var movieDetailUseCase : MovieDetailUseCaseInput = MovieDetailUseCase(output: self)
    
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
        
        self.mostPopularMoviesTableView?.estimatedRowHeight = 400
        self.mostPopularMoviesTableView?.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Data -
    
    func loadData(query: String) {
        
        self.mostPopularMovieRequest.page = 1
        self.mostPopularMovieRequest.query = query
        self.mostPopularMoviesUseCase.getMostPopularMovies(request: self.mostPopularMovieRequest)
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
        
        if indexPath.row == ((self.data?.count ?? 0) - 1) && (self.data?.count ?? 0) >= 10 {
            
            self.mostPopularMoviesUseCase.paginateMostPopularMovies(request: self.mostPopularMovieRequest)
        }
    }
}

extension SearchMostPopularMoviesViewController: MostPopularMoviesPresenterOutput {
    
    func willPaginateMostPopularMovies() {
        
        self.dispatchOnMainQueue { [weak self] in
            
            self?.showProgress()
        }
    }
    
    func successPaginateMostPopularMovies(data: [MostPopularMovieViewModel]?) {
        
        self.dispatchOnMainQueue {  [weak self] in
            
            if let data = data {
                
                self?.data?.append(contentsOf: data)
                
                self?.mostPopularMoviesTableView?.reloadData()
                
                self?.mostPopularMovieRequest.page = ((self?.mostPopularMovieRequest.page ?? 0) + 1)
            }
        }
    }
    
    func failPaginateMostPopularMovies(error: CustomError) {
        
        self.dispatchOnMainQueue {  [weak self] in
            
            self?.showAlert(error: error, handler: nil)
        }
    }
    
    func didPaginateMostPopularMovies() {
        
        self.dispatchOnMainQueue {  [weak self] in
            
            self?.dismissProgress()
        }
    }
    
    func willGetMostPopularMovies() {
        
        self.dispatchOnMainQueue { [weak self] in
            
            self?.showProgress()
        }
    }
    
    func successGetMostPopularMovies(data: [MostPopularMovieViewModel]?) {
        
        self.dispatchOnMainQueue {  [weak self] in
            
            if let data = data {
                
                self?.data = data
                
                self?.mostPopularMoviesTableView?.reloadData()
                
                self?.mostPopularMovieRequest.page = ((self?.mostPopularMovieRequest.page ?? 0) + 1)
            }
        }
    }
    
    func failGetMostPopularMovies(error: CustomError) {
        
        self.dispatchOnMainQueue {  [weak self] in
            
            self?.showAlert(error: error, handler: nil)
        }
    }
    
    func didGetMostPopularMovies() {
        
        self.dispatchOnMainQueue {  [weak self] in
            
            self?.dismissProgress()
        }
    }
    
}

extension SearchMostPopularMoviesViewController: MovieDetailUseCaseOutput {
    
    func willGetMovieDetail() {
        
    }
    
    func successMovieDetail(modelView: MostPopularMovieViewModel?) {
        
        self.dispatchOnMainQueue {  [weak self] in
            
            guard let modelView = modelView,
                let index = self?.data?.firstIndex(of: modelView)
                else { return }
            
            self?.mostPopularMoviesTableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func failGetMovieDetail(error: CustomError) {
        
        self.dispatchOnMainQueue {  [weak self] in
            
            self?.showAlert(error: error, handler: nil)
        }
    }
    
    func didGetMovieDetail() {
        
    }
}

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
