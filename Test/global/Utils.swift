//
//  Utils.swift
//  Test
//
//  Created by Cezhar Arévalo on 18-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import UIKit

class Utils{
    
    class func loadImage(view: UIImageView, urlStr: String){
        if let url = URL( string:urlStr)
        {
            DispatchQueue.global().async {
              if let data = try? Data( contentsOf:url)
              {
                DispatchQueue.main.async {
                  view.image = UIImage( data:data)
                }
              }
           }
        }
    }
    
    class func formatSongListName(pos: Int, name: String) -> String{
        return "\(pos).- " + (name)
    }
    
}
