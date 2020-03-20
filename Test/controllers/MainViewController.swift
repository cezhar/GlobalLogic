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
    
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var pageNumber: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var previous: UIButton!
    @IBOutlet weak var nextPage: UIButton!
    
    var selectedSongIndex: Int = -1
    var songs = [Song]()
    var page = 0;
    
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
                let escapedString = searchField.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                API.fetchSongs(with: escapedString, offset: with, completion: {result, error in
                    if result != nil{
                        if result!.count > 0{
                            self.songs = result!
                            
                            DispatchQueue.main.async {
                                self.formatNavigatorStuff()
                                self.table.reloadData()
                            }
                        }else{
                            
                            DispatchQueue.main.async {
                                self.error.text = "Song not found..."
                                self.table.isHidden = true
                                self.error.isHidden = false
                            }
                            
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.error.text = error?.localizedDescription ?? "The Internet connection appears to be offline..."
                            self.table.isHidden = true
                            self.error.isHidden = false
                        }
                    }
                })
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
