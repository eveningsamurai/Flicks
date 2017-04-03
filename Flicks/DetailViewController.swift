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
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        //get the movie attributes
        let movieTitle = movie["title"] as! String
        let movieOverview = movie["overview"] as! String
        
        //set the detail view with the movie attributes
        titleLabel.text = movieTitle
        overviewLabel.text = movieOverview
        overviewLabel.sizeToFit()
        
        //get the post path and set the image view if poster path not nil
        if let posterPath = movie["poster_path"] as? String {
            //get the tmdb base url
//            let baseUrl = "https://image.tmdb.org/t/p/w500"
//            
//            //build the movie poster url
//            let imageUrl = URL(string: baseUrl + posterPath)
//            
//            //set the movie poster on the image view
//            posterImageView.setImageWith(imageUrl!)
            
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            let imageUrl = URL(string: baseUrl + posterPath)
            let imageRequest = URLRequest(url: imageUrl!)
            
            posterImageView.setImageWith(imageRequest,
                                         placeholderImage: nil,
                                         success: { (imageRequest, imageResponse, image) in
                                            if imageResponse != nil {
                                                self.posterImageView.alpha = 0.0
                                                self.posterImageView.image = image
                                                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                                    self.posterImageView.alpha = 1.0
                                                })
                                            } else {
                                                self.posterImageView.image = image
                                            }
            },
                                         failure: { (imageRequest, imageResponse, error) in
                                            
            })

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
