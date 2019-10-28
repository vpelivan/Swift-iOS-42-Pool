//
//  CollectionViewController.swift
//  day03
//
//  Created by Viktor PELIVAN on 9/30/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    
    var imgStringUrls: [URL] = [
        URL(string: "https://wallpapershome.ru/images/wallpapers/oboi-ayfon-8-3840x2160-oboi-ayfon-8-15475.jpg")!,
        URL(string: "https://wallpapershome.ru/images/wallpapers/makos-modjave-3840x2160-makos-modjave-20511.jpg")!,
        URL(string: "https://wallpapershome.ru/images/wallpapers/norvegiya-2560x1440-4k-hd-derevnya-sneg-203.jpg")!,
        URL(string: "https://wallpapershome.ru/images/wallpapers/chernaya-dira-3840x2160-kosmos-16360.jpg")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgStringUrls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CollectionViewCell
        let imageUrl = imgStringUrls[indexPath.row]
        DispatchQueue.global().async { // Start Multithreading Load
            if let data = try? Data(contentsOf: imageUrl) {
                DispatchQueue.main.async { //start flow
                    cell.imageView.image = UIImage(data: data)
                    cell.activityIndicator.stopAnimating() //stop spinning
                }
            } else {
                let alert = UIAlertController (title: "Error", message: "Cannot acess to \(self.imgStringUrls[indexPath.row])", preferredStyle: .alert) //creating alert object
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil)) // appearing the alert window
                self.present(alert, animated: true) //adding animation
                cell.activityIndicator.stopAnimating()
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let imageVC = segue.destination as! ImageViewController
        let cell = sender as! CollectionViewCell
        if cell.imageView.image != nil {
            imageVC.image = cell.imageView.image!
        } else {
            let alert = UIAlertController(title: "Error", message: "Cannot load image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
