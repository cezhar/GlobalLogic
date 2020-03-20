//
//  DetailViewController.swift
//  Test
//
//  Created by Cezhar Arévalo on 17-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import UIKit
import AVFoundation

class DetailCell : UITableViewCell {
    
    @IBOutlet weak var song: UILabel!
    
}

class DetailViewController: UIViewController{
    
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var error: UILabel!
    
    var coverURL: String = ""
    var albumStr: String = ""
    var artistStr: String = ""
    var albumId: Int = -1
    var songs = [Song]()
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        error.isHidden = true
        API.fetchAlbum(id: albumId,completion: {result, error in
            if error == nil{
                self.songs = result!
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
            else{
                DispatchQueue.main.async{
                    self.table.isHidden = true
                    self.error.isHidden = false
                    self.error.text = error?.localizedDescription ?? "The Internet connection appears to be offline..."
                }
            }
        })
        Utils.loadImage(view: cover, urlStr: coverURL)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pos = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailCell
        cell.song.text = Utils.formatSongListName(pos: songs[pos].trackNumber!, name: songs[pos].trackName!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pos = indexPath.row
        let song = songs[pos].previewURL
        let playerItem = AVPlayerItem(url: URL(string: song!)!)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        player?.actionAtItemEnd = .none
    }
    
}
