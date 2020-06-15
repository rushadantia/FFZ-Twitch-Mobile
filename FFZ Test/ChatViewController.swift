//
//  ChatViewController.swift
//  FFZ Test
//
//  Created by Rushad Antia on 6/15/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ChatViewController : UIViewController, UITextFieldDelegate {
    
    var channelName: String?
    var emotes: [String: UIImage] = [:]
    var label: UILabel = UILabel()
    
    @IBOutlet weak var tf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tf.delegate = self
         self.view.addSubview(label)
        let r = AF.request("https://api.frankerfacez.com/v1/room/\(self.channelName!)")
        r.responseJSON { (data) in
            do {
                let json =  try JSON(data: data.data!)
                for set in json["sets"] {
                    let emoticons = set.1["emoticons"]
                    for emote in emoticons {
                        let name = emote.1["name"].description
                        let imageurl = URL(string :"https:\(emote.1["urls"]["1"].description)")!
                        
                        DispatchQueue.main.async {
                            let imgData = try! Data(contentsOf: imageurl)
                            self.emotes[name] = UIImage(data: imgData)
                        }
                    }
                }
            } catch {}
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        generateLabel()
        
        return true
    }
    
    func generateLabel(){
        label.attributedText = NSAttributedString(string: "")
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
       
        label.font = UIFont.systemFont(ofSize: 22)
        
        let views = ["label": label]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-44-[label]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        let iconSize = CGRect(x: 0, y: -5, width: 30, height: 30)
        let attributedString = NSMutableAttributedString(string: "")
        
        for text in tf.text!.split(separator: " "){
            if self.emotes.keys.contains(String(text)) {
                let emote = NSTextAttachment()
                emote.image = self.emotes[String(text)]
                emote.bounds = iconSize
                attributedString.append(NSAttributedString(attachment: emote))
            }
            else {
                attributedString.append(NSAttributedString(string: " \(text) "))
            }
        }
        
        label.attributedText = attributedString
    }

}
