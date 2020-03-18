//
//  DetailViewController.swift
//  Test
//
//  Created by Cezhar Arévalo on 17-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import UIKit

class DetailCell : UITableViewCell {
    
    @IBOutlet weak var song: UILabel!
    
}

class DetailViewController: UIViewController{
    
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var close: UIButton!
    
    var coverURL: String = ""
    var albumStr: String = ""
    var artistStr: String = ""
    var albumId: Int = -1
    
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.fetchAlbum(id: albumId,completion: {result, error in
            self.songs = result!
            DispatchQueue.main.async {
                self.table.reloadData()
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
        cell.song.text = Utils.formatSongListName(pos: pos, name: songs[pos].trackName ?? "")
        return cell
    }
    
}
