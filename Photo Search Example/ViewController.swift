//
//  ViewController.swift
//  Photo Search Example
//
//  Created by stephanie Chamblee on 7/19/17.
//  Copyright © 2017 Stephanie Chamblee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFlickrBy(_searchString: "dogs")
    }
    
    func searchFlickrBy(_searchString:String) {
        let manager = AFHTTPSessionManager()
        let searchParameters:[String:Any] = ["method": "flickr.photos.search",
                                             "api_key": "a287b6748c2ebe5f3c3ed44455d6ab4c",
                                             "format": "json",
                                             "nojsoncallback": 1,
                                             "text": "dogs",
                                             "extras": "url_m",
                                             "per_page": 5]
        
        manager.get("https://api.flickr.com/services/rest/",
                    parameters: searchParameters,
                    progress: nil,
                    success: { (operation: URLSessionDataTask, responseObject:Any?) in
                        if let responseObject = responseObject {
                            print("Response: " + (responseObject as AnyObject).description)
                            if let photos = (responseObject as AnyObject)["photos"] as? [String: AnyObject] {
                            if let photoArray = photos["photo"] as? [[String: AnyObject]] {
                                let imageWidth = self.view.frame.width
                                self.scrollView.contentSize = CGSize(width: imageWidth, height: imageWidth * CGFloat(photoArray.count))

                        for (i,photoDictionary) in photoArray.enumerated() {
                            if let imageURLString = photoDictionary["url_m"] as? String {
                                let imageView = UIImageView(frame: CGRect(x:0, y:320*CGFloat(i), width: imageWidth, height: imageWidth))
                                if let url = URL(string:imageURLString) {
                                    imageView.setImageWith(url)
                                    self.scrollView.addSubview(imageView)
                                }
                            }
                        }
                    }
                }
                            
            }
        }) {(operation:URLSessionDataTask?, error:Error) in
                print("Error: " + error.localizedDescription)
            }
    }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            for subview in self.scrollView.subviews {
                subview.removeFromSuperview()
            }
            searchBar.resignFirstResponder()
        }
}
