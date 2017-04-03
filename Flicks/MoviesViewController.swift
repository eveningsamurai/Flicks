//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Padmanabhan, Avinash on 4/1/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var filtered: [NSDictionary]?
    var endpoint: String = "now_playing"
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        errorLabel.isHidden = true
        searchBar.delegate = self
        
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.magenta
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        // Do any additional setup after loading the view.
        let apiKey = "045f7da1aeda8a5b76ec2a9cbdb153d8"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        // Check for reachability
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            errorLabel.isHidden = false
        }
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        //sleep(10) // to demonstrate Heads Up Display(HUD) when network connectivity is slow
                        
                        // Hide HUD once the network request comes back (must be done on main UI thread)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        // Reload table view to show the data received from the API
                        self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        let apiKey = "045f7da1aeda8a5b76ec2a9cbdb153d8"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        // Check for reachability
        if Reachability.isConnectedToNetwork() == false {
            errorLabel.isHidden = false
        }
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        //sleep(10) // to demonstrate Heads Up Display(HUD) when network connectivity is fast
                        
                        // Hide HUD once the network request comes back (must be done on main UI thread)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        // Reload table view to show the data received from the API
                        self.tableView.reloadData()
                        refreshControl.endRefreshing()
                    }
                }
        });
        task.resume()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = self.movies {
            if(searchActive) {
                return filtered!.count
            }
            return movies.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set cell of type MovieCell so that we can reference the outlets
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        var movie: NSDictionary!
        if(searchActive) {
            movie = filtered![indexPath.row]
        } else {
            movie = self.movies![indexPath.row]
        }
        
        //get the movie attributes
        let movieTitle = movie["title"] as! String
        let movieOverview = movie["overview"] as! String
        
        //set the movie cell with the movie attributes
        cell.titleLabel.text = movieTitle
        cell.overviewLabel.text = movieOverview

        //get the post path and set the image view if poster path not nil
        if let posterPath = movie["poster_path"] as? String {
            //get the tmdb base url
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            
            //build the movie poster url
            let imageUrl = URL(string: baseUrl + posterPath)
            cell.posterView.setImageWith(imageUrl!)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated:true)
    }
    
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
        filtered = movies?.filter({ (movie) -> Bool in
            let movieTitle = movie["title"] as! String
            let range = movieTitle.lowercased().range(of: searchText.lowercased(), options: .regularExpression)
            
            return range != nil
        })
        
        if(filtered!.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //the sender in this case is the table cell that you click on to get details
        let cell = sender as! UITableViewCell
        
        //get the indexPath of the cell that is clicked on and then based on that indexPath get the movie
        let indexPath = tableView.indexPath(for: cell)
        let movie = self.movies?[(indexPath?.row)!]
        
        //set the movie in the DetailViewController to the movie clicked on
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
    }

}
