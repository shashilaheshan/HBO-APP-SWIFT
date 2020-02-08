//
//  MovieViewController.swift
//  HBO
//
//  Created by Shashila Heshan on 18/1/20.
//  Copyright © 2020 Shashila Heshan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class MovieViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableMovies: UITableView!
    var movies = [MovieModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableMovies.delegate = self
        self.tableMovies.dataSource = self
        self.getMovies()
    }
    func getMovies()  {
        
        self.movies.removeAll()
        AF.request(MOVIE_API_URL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
               
                let resultArray = json["results"]
                for i in resultArray.arrayValue {
                    self.movies.append(MovieModel(popularity: i["popularity"].doubleValue, poster_path: i["poster_path"].stringValue, adult: i["adult"].boolValue, original_title: i["original_title"].stringValue, vote_average: i["vote_average"].intValue, release_date: i["release_date"].stringValue))
                    
                }
                self.tableMovies.reloadData()
            case .failure(let error):
                print(error)
            }
            
        }

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableMovies.dequeueReusableCell(withIdentifier: "movieCell")
        cell?.textLabel?.text = self.movies[indexPath.row].original_title
        let imageURL = IMAGE_PATH_BASE_URL+(self.movies[indexPath.row].poster_path)
        let url = URL(string: imageURL)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                 cell?.imageView!.image = UIImage(data: data!)
              
            }
        }
       
        
        return cell!;
    }
    
}
