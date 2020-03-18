//
//  API.swift
//  Test
//
//  Created by Cezhar Arévalo on 17-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import Foundation

class API {
    
    class func fetchSongs(CompletionHandler: @escaping ([Song]?, Error?) -> Void) {
      let url = URL(string: "https://itunes.apple.com/search?term=in+utero&mediaType=music&limit=20")!
      let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in

        guard let data = data else { return }
        do {
            let decoder = JSONDecoder()
            let jsonDict = try decoder.decode(Result.self, from: data)
            let userData = jsonDict.results
            CompletionHandler(userData, nil)
          
        } catch let parseErr {
          print("JSON Parsing Error", parseErr)
          CompletionHandler(nil, parseErr)
        }
      })
      
      task.resume()
      // function will end here and return
      // then after receiving HTTP response, the completionHandler will be called
    }

    
}
