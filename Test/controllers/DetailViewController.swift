//
//  DetailViewController.swift
//  Test
//
//  Created by Cezhar Arévalo on 17-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import UIKit
import AVFoundation
import Reachability

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
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.accessibilityIdentifier = "detailTable"
        error.isHidden = true
        reachability.whenReachable = { reachability in
            Utils.loadImage(view: self.cover, urlStr: self.coverURL)
            API.fetchAlbum(id: self.albumId,completion: {result, error in
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
        }
        reachability.whenUnreachable = { _ in
            self.table.isHidden = true
            self.error.isHidden = false
            self.error.text = "The Internet connection appears to be offline..."
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    @IBAction func close(_ sender: Any) {
        reachability.stopNotifier()
        player?.pause()
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
        cell.accessibilityIdentifier = "detailCell_\(pos)"
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
