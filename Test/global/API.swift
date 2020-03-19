//
//  API.swift
//  Test
//
//  Created by Cezhar Arévalo on 17-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import Foundation

class API {
    
    class func fetchSongs(with: String, offset:Int, completion: @escaping ([Song]?, Error?) -> Void) {
        let url = URL(string: "https://itunes.apple.com/search?term="+with+"&entity=song&limit=20&offset=\(offset*20)")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in

            guard let data = data else {
                let offline = MyError.offlineError
                completion(nil, offline)
                return
            }
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

            guard let data = data else {
                let offline = MyError.offlineError
                completion(nil, offline)
                return
            }
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
