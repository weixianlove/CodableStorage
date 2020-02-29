//
//  ViewController.swift
//  CodableStorage
//
//  Created by weixian on 2020/2/28.
//  Copyright © 2020 weixian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        struct Timeline: Codable {
            let tweets: [String]
        }
        

        let storage = CodableStorage()
        
        let timeline = Timeline(tweets: ["Hello", "World", "!!!"])
      
//        try! storage.save(timeline, for: "timeline")
//
//        do {
//            try storage.save(timeline, for: "timeline")
//        } catch  {
//            print(error)
//        }
        
        
        storage.asyncSave(timeline, for: "timeline") { result in
            switch result {
            case .success(let key):
                print("async save \(key) success")
            case .failure(let error):
                print(error)
            }
        }
        
        if let cached: Timeline = try? storage.fetch(for: "timeline")  {
            print(cached)
        }
   
        
        
        storage.asyncFetch(for: "timeline") { (result: Result<Timeline, Error>) in
            switch result {
            case .success(let timeline):
                print(timeline)
            case .failure(let err):
                print(err)
            }
        }
        
        
        try! storage.delete(for: "timeline")
        
//        do {
//            try storage.delete(for: "timeline")
//        } catch  {
//            print(error)
//        }
//
//        do {
//            let cached: Timeline = try storage.fetch(for: "timeline")
//            print(cached)
//        } catch {
//            print(error)
//        }
    }

}

