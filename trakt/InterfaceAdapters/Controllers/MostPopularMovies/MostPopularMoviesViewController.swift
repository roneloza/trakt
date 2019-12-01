//
//  ReservesCollectionViewController.swift
//  ColturViajes
//
//  Created by Lab Positiva Dev on 11/11/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit
import SDWebImage

class MostPopularMoviesViewController: BaseViewController, ProgressLoaderController, AlertableController, DispatcherController {

    private (set) var atomicValue : Int32 = 0
    
    private lazy var data: [MostPopularMovieViewModel]? = [MostPopularMovieViewModel]()
    
    @IBOutlet weak var mostPopularMoviesTableView: UITableView?
    
    private lazy var mostPopularMoviesUseCase : MostPopularMoviesUseCaseInput = MostPopularMoviesUseCase(output: self.presenter)
    
    private lazy var presenter: MostPopularMoviesPresenterInput = MostPopularMoviesPresenter(output: self)
    
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
        self.loadData(query: "")
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
        self.mostPopularMoviesUseCase.getMostPopularMovies(request: self.mostPopularMovieRequest)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate -
extension MostPopularMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            
            self.mostPopularMoviesUseCase.paginateMostPopularMovies(request: self.mostPopularMovieRequest)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = self.data?[indexPath.row],
            let tmdb = item.tmdb {
         
            self.movieVideoUseCase.getMovieVideo(request: MovieVideoRequest(movieId: tmdb))
        }
    }
}

// MARK: - MostPopularMoviesPresenterOutput -
extension MostPopularMoviesViewController: MostPopularMoviesPresenterOutput {
    
    func willPaginateMostPopularMovies() {
        
       self.showProgress()
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
        
        self.showAlert(error: error, handler: nil)
    }
    
    func didPaginateMostPopularMovies() {
        
        self.dismissProgress()
    }
    
    func willGetMostPopularMovies() {
        
        self.showProgress()
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
        
        self.showAlert(error: error, handler: nil)
    }
    
    func didGetMostPopularMovies() {
        
        self.dismissProgress()
    }
    
}

// MARK: - MovieDetailUseCaseOutput -
extension MostPopularMoviesViewController: MovieDetailUseCaseOutput {
    
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

// MARK: - UMovieVideoUseCaseOutput -
extension MostPopularMoviesViewController: MovieVideoUseCaseOutput {
    
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
