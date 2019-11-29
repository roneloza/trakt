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

    private lazy var data: [MostPopularMovieViewModel]? = [MostPopularMovieViewModel]()
    
    @IBOutlet weak var mostPopularMoviesTableView: UITableView?
    
    private lazy var mostPopularMoviesUseCase : MostPopularMoviesUseCaseInput = MostPopularMoviesUseCase(output: self.presenter)
    
    private lazy var presenter: MostPopularMoviesPresenterInput = MostPopularMoviesPresenter(output: self)
    
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
        self.loadData()
    }
    
    // MARK: - UI -
    
    func setupTableView() {
        
        self.mostPopularMoviesTableView?.estimatedRowHeight = 400
        self.mostPopularMoviesTableView?.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Data -
    
    func loadData() {
        
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
        
        if indexPath.row == ((self.data?.count ?? 0) - 1) {
            
            self.mostPopularMoviesUseCase.getMostPopularMovies(request: self.mostPopularMovieRequest)
        }
    }
}

extension MostPopularMoviesViewController: MostPopularMoviesPresenterOutput {
    
    func willGetMostPopularMovies() {
        
        self.dispatchOnMainQueue { [weak self] in
            
            self?.showProgress()
        }
    }
    
    func successGetMostPopularMovies(data: [MostPopularMovieViewModel]?) {
        
        self.dispatchOnMainQueue {  [weak self] in
            
            if let data = data {
             
                self?.mostPopularMovieRequest.page = ((self?.mostPopularMovieRequest.page ?? 0) + 1)
                self?.data?.append(contentsOf: data)
                
                self?.mostPopularMoviesTableView?.reloadData()
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

extension MostPopularMoviesViewController: MovieDetailUseCaseOutput {
    
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
