//
//  API.swift
//  Test
//
//  Created by Cezhar Arévalo on 17-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import Foundation

class API {
    
    class func fetchSongs(completion: @escaping ([Song]?, Error?) -> Void) {
      let url = URL(string: "https://itunes.apple.com/search?term=in+utero&entity=song&limit=20")!
      let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in

        guard let data = data else { return }
        do {
            let decoder = JSONDecoder()
            let jsonDict = try decoder.decode(Result.self, from: data)
            let userData = jsonDict.results
            completion(userData, nil)
          
        } catch let parseErr {
          print("JSON Parsing Error", parseErr)
          completion(nil, parseErr)
        }
      })
      
      task.resume()
    }
    
    class func fetchAlbum(id: Int, completion: @escaping ([Song]?,Error?) -> Void){
        let url = URL(string: "https://itunes.apple.com/lookup?id=\(id)&entity=song")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in

          guard let data = data else { return }
          do {
              let decoder = JSONDecoder()
              let jsonDict = try decoder.decode(Result.self, from: data)
            let userData = jsonDict.results.filter{$0.wrapperType == "track"}
            
              completion(userData, nil)
            
          } catch let parseErr {
            print("JSON Parsing Error", parseErr)
            completion(nil, parseErr)
          }
        })
        
        task.resume()
    }

    
}
