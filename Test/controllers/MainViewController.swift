//
//  ViewController.swift
//  Test
//
//  Created by Cezhar Arévalo on 17-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    
}

class MainViewController: UIViewController{
    

    @IBOutlet weak var table: UITableView!
    
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.fetchSongs(CompletionHandler: {result, error in
            self.songs = result!
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
        })
    }


}
extension MainViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pos = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell") as! SongCell
        cell.artist.text = songs[pos].artistName
        cell.title.text = songs[pos].trackName
        if let url = URL( string:songs[pos].artworkUrl30)
        {
            DispatchQueue.global().async {
              if let data = try? Data( contentsOf:url)
              {
                DispatchQueue.main.async {
                  cell.icon.image = UIImage( data:data)
                }
              }
           }
        }
        return cell
    }
    
    
}

