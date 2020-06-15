//
//  ViewController.swift
//  FFZ Test
//
//  Created by Rushad Antia on 6/15/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func toChannel(_ sender: Any) {
        performSegue(withIdentifier: "toChat", sender: tf.text)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is ChatViewController){
            let vc = segue.destination as? ChatViewController
            let s = sender as? String
            vc?.channelName = s!
        }
    }
}

