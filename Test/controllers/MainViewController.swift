//
//  ViewController.swift
//  Test
//
//  Created by Cezhar Arévalo on 17-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import UIKit
import RealmSwift
import Reachability

class SongCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    
}

class MainViewController: UIViewController{
    
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var pageNumber: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var previous: UIButton!
    @IBOutlet weak var nextPage: UIButton!
    
    var selectedSongIndex: Int = -1
    var songs = [Song]()
    var page = 0;
    
    let realm = try! Realm()
    let reachability = try! Reachability()
    
    func getStoredSong(ID: Int)->Song?{
        let songs = realm.objects(StoredSong.self).filter("trackID == \(ID)")
        if songs.count == 0 {
            return nil
        }
        else{
        let storedSong = songs.first!
        let song = Song(
            wrapperType: storedSong.wrapperType,
            kind: storedSong.kind,
            artistID: storedSong.artistID,
            collectionID: storedSong.collectionID,
            trackID: storedSong.trackID,
            artistName: storedSong.artistName,
            collectionName: storedSong.collectionName,
            trackName: storedSong.trackName,
            collectionCensoredName: storedSong.collectionCensoredName,
            trackCensoredName: storedSong.trackCensoredName,
            previewURL: storedSong.previewURL,
            artworkUrl30: storedSong.artworkUrl30,
            artworkUrl100: storedSong.artworkUrl100,
            trackNumber: storedSong.trackNumber)
            return song
        }
    }
    
    func storeData(songs: [Song])->Void{
        for song in songs{
            let stored = self.getStoredSong(ID: song.trackID!)
            if stored == nil {
                let songToStore = StoredSong()
                songToStore.artistID = song.artistID!
                songToStore.artistName = song.artistName!
                songToStore.artworkUrl100 = song.artworkUrl100!
                songToStore.artworkUrl30 = song.artworkUrl30!
                songToStore.collectionCensoredName = song.collectionCensoredName!
                songToStore.collectionID = song.collectionID!
                songToStore.collectionName = song.collectionName!
                songToStore.kind = song.kind!
                songToStore.previewURL = song.previewURL!
                songToStore.trackCensoredName = song.trackCensoredName!
                songToStore.trackID = song.trackID!
                songToStore.trackName = song.trackName!
                songToStore.trackNumber = song.trackNumber!
                songToStore.wrapperType = song.wrapperType!
                try! realm.write{
                    realm.add(songToStore)
                }
            }
        }
    }
    
    func getStoredSongs(predicate:String, with:Int)->[Song]{
        
        let limit = 20
        var from : Int
        var to: Int
        
        var songs = [Song]()
        let storedSongs = realm.objects(StoredSong.self).filter("artistName CONTAINS %@ OR collectionName CONTAINS %@ OR collectionCensoredName CONTAINS %@ OR trackName CONTAINS %@ OR trackCensoredName CONTAINS %@", predicate, predicate, predicate, predicate, predicate)
        
        let total = storedSongs.count
        if (with + 1) * limit < total {
            from = (with * 20) - 1
            to = ((with + 1) * limit) - 1
        }
        else{
            to = total - 1
            
            if with * limit < total - limit{
                from = (with * limit) - 1
            }
            else {
                if with > 0 &&  (with - 1) * limit < total - limit {
                    if with != 1 {
                        from = (with - 1) * limit - 1
                    }
                    else {
                        from = 0
                    }
                }
                else{
                    from = 0
                }
            }
            
        }
        
        if from < to{
            for i in from...to{
                let storedSong = storedSongs[i]
                let song = Song(
                    wrapperType: storedSong.wrapperType,
                    kind: storedSong.kind,
                    artistID: storedSong.artistID,
                    collectionID: storedSong.collectionID,
                    trackID: storedSong.trackID,
                    artistName: storedSong.artistName,
                    collectionName: storedSong.collectionName,
                    trackName: storedSong.trackName,
                    collectionCensoredName: storedSong.collectionCensoredName,
                    trackCensoredName: storedSong.trackCensoredName,
                    previewURL: storedSong.previewURL,
                    artworkUrl30: storedSong.artworkUrl30,
                    artworkUrl100: storedSong.artworkUrl100,
                    trackNumber: storedSong.trackNumber)
                songs.append(song)
            }
        }
        return songs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        cleanNavigatorStuff()
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
    @IBAction func goToPrevious(_ sender: Any) {
        navigateThroughResults(forward: false)
    }
    @IBAction func goToNext(_ sender: Any) {
        navigateThroughResults(forward: true)
    }
    
    func navigateThroughResults(forward:Bool){
        if forward {
            page += 1
        }
        else {
            page -= 1
        }
        performAPICall(with:page)
    }
    
    func formatNavigatorStuff(){
        if page == 0 {
            previous.isHidden = true
        }
        else {
            previous.isHidden = false
        }
        if songs.count < 20 {
            nextPage.isHidden = true
        }
        else {
            nextPage.isHidden = false
        }
        self.pageNumber.text = "\(self.page + 1)"
    }
    
    func cleanNavigatorStuff(){
        error.text = "Song not found..."
        table.isHidden = false
        error.isHidden = true
        nextPage.isHidden = true
        previous.isHidden = true
        pageNumber.text = ""
        page = 0
    }
    
    func performAPICall(with:Int){
        if searchField.text != nil {
            if searchField.text!.count > 2 {
                let escapedString = self.searchField.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                
                reachability.whenReachable = { reachability in
                    API.fetchSongs(with: escapedString, offset: with, completion: {result, error in
                        if result != nil{
                            if result!.count > 0{
                                self.songs = result!
                                DispatchQueue.main.async {
                                    self.formatNavigatorStuff()
                                    self.table.reloadData()
                                    self.storeData(songs: result!)
                                    self.reachability.stopNotifier()
                                }
                            }else{
                                
                                DispatchQueue.main.async {
                                    self.error.text = "Song not found..."
                                    self.table.isHidden = true
                                    self.error.isHidden = false
                                    self.reachability.stopNotifier()
                                }
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                self.error.text = error?.localizedDescription ?? "The Internet connection appears to be offline..."
                                self.table.isHidden = true
                                self.error.isHidden = false
                                self.reachability.stopNotifier()
                            }
                        }
                    })
                }
                reachability.whenUnreachable = { _ in
                    let songs = self.getStoredSongs(predicate: self.searchField.text!, with: with)
                    if songs.count > 0{
                        self.songs = songs
                        DispatchQueue.main.async {
                            self.formatNavigatorStuff()
                            self.table.reloadData()
                            self.reachability.stopNotifier()
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.error.text = "Song not found..."
                            self.table.isHidden = true
                            self.error.isHidden = false
                            self.reachability.stopNotifier()
                        }
                    }
                }

                do {
                    try reachability.startNotifier()
                } catch {
                    print("Unable to start notifier")
                }
            }
            else {
                self.cleanNavigatorStuff()
                self.songs.removeAll()
                self.table.reloadData()
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
extension MainViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        performAPICall(with:0)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
