//
//  ViewController.swift
//  SearchApp
//
//  Created by Vishwa Fernando on 6/12/22.
//  Copyright © 2022 ncs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, UISearchBarDelegate {
    
    //UITableView
    @IBOutlet weak var tableView: UITableView!
    
    //UISearchBar
    @IBOutlet weak var searchBar: UISearchBar!
    
    //UILabel
    @IBOutlet weak var lb_error: UILabel!
    
    //Network
    var httpService:HTTPService!
    
    var allMovieList: [Movie] = []
    var currentMovieList: [Movie] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Network Request
        httpService = HTTPService(baseUrl: "https://www.omdbapi.com")
        httpService.searchAPIDelegate = self
        
        //Cell
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    }


    func setUpSearchBar(){
        
        searchBar.delegate = self
        // search Bar additional setup
        searchBar.barTintColor = UIColor.white
        searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        
    }
    
    
    //filter data
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentMovieList.removeAll()
            tableView.reloadData()
            tableView.isHidden = false
            return
        }

        httpService.getSearchList(sText: searchText as NSString)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("")
    }
    
}


extension ViewController : SearchListAPIDelegate {
    func getSearchResults(res: [Movie]) {
        allMovieList = res
        currentMovieList = allMovieList
        tableView.reloadData()
        print(res)
        tableView.isHidden = false
    }
    
    func getSearchResults(_ error: RestClientError) {
        print(error)
        tableView.isHidden = true
    }
}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMovieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell     = self.tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell
        cell?.lb_title.text      = "\(currentMovieList[indexPath.row].title)"
        cell?.lb_genre.text      = "\(currentMovieList[indexPath.row].year)"
        cell?.lb_adventure.text  = "\(currentMovieList[indexPath.row].type)"
        cell?.representedIdentifier = currentMovieList[indexPath.row].imdbID as String
        
        let representedIdentifier = currentMovieList[indexPath.row].imdbID as String
        
        if currentMovieList[indexPath.row].poster != "N/A"{
            httpService.image(url: currentMovieList[indexPath.row].poster) { [self] data, error in
                let img = image(data: data)
                DispatchQueue.main.async {
                    if (cell!.representedIdentifier == representedIdentifier) {
                        cell?.img = img
                    }
                }
            }
        }
        return cell!
    }
    
    func image(data: Data?) -> UIImage? {
        if let data = data {
          return UIImage(data: data)
        }
        return UIImage(systemName: "picture")
      }
}
