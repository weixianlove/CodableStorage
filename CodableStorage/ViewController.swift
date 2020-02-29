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
        do {
            try storage.save(timeline, for: "timeline")
        } catch  {
            print(error)
        }
        
        if let cached: Timeline = try? storage.fetch(for: "timeline")  {
            print(cached)
        }
   
        do {
            try storage.delete(for: "timeline")
        } catch  {
            print(error)
        }
        
        do {
            let cached: Timeline = try storage.fetch(for: "timeline")
            print(cached)
        } catch {
            print(error)
        }
    }
    

    


}

