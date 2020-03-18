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
    var selectedSongIndex: Int = -1
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.fetchSongs(completion: {result, error in
            self.songs = result!
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "detail") {
            if let vc: DetailViewController = segue.destination as? DetailViewController {
                let song = songs[selectedSongIndex]
                vc.albumId = song.collectionID ?? -1
                vc.albumStr = song.collectionName ?? ""
                vc.artistStr = song.artistName ?? ""
                vc.coverURL = song.artworkUrl100 ?? ""
            }
        }
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
        Utils.loadImage(view: cell.icon, urlStr: songs[pos].artworkUrl30 ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSongIndex = indexPath.row
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
}
