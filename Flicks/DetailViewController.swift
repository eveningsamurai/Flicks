//
//  DetailViewController.swift
//  Flicks
//
//  Created by Padmanabhan, Avinash on 4/1/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //get the movie attributes
        let movieTitle = movie["title"] as! String
        let movieOverview = movie["overview"] as! String
        
        //set the detail view with the movie attributes
        titleLabel.text = movieTitle
        overviewLabel.text = movieOverview
        
        //get the post path and set the image view if poster path not nil
        if let posterPath = movie["poster_path"] as? String {
            //get the tmdb base url
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            
            //build the movie poster url
            let imageUrl = URL(string: baseUrl + posterPath)
            
            //set the movie poster on the image view
            posterImageView.setImageWith(imageUrl!)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
