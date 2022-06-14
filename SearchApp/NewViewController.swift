//
//  NewViewController.swift
//  SearchApp
//
//  Created by Kasper - Vishwa on 2022-06-14.
//  Copyright © 2022 ncs. All rights reserved.
//

import UIKit

class NewViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var img_view: UIImageView!
    
    var representedIdentifier: NSString!
    var img_url: NSString!
    
    //Network
    var httpService:HTTPService!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Network Request
        httpService = HTTPService(baseUrl: "https://www.omdbapi.com")
        httpService.searchAPIDelegate = self
        
        // Do any additional setup after loading the view.
        //Load Image from catcg\h
        if img_url != "N/A"{
            httpService.image(url: img_url) { [self] data, error in
                let img = image(data: data)
                DispatchQueue.main.async {
                    self.img_view.image = img
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewViewController: SearchListAPIDelegate{
    
    func getSearchResults(res: [Movie]) {
    }
    
    func getSearchResults(_ error: RestClientError) {
    }
}
