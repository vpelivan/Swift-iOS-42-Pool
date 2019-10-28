//
//  ImageViewController.swift
//  day03
//
//  Created by Viktor PELIVAN on 9/30/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setupScrollView()
    }
    
    func setupScrollView() {
        imageView = UIImageView(image: image)
        scrollView.addSubview(imageView!)
        scrollView.contentSize = imageView.frame.size
        scrollView.maximumZoomScale = 3.0
    }
    
    func setZoomScale(for ScrollViewSize: CGSize) {
        let widthScale = ScrollViewSize.width / imageView.bounds.size.width
        let heightScale = ScrollViewSize.height / imageView.bounds.size.height
        let minimumScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minimumScale
        scrollView.zoomScale = minimumScale
    }

    override func viewWillLayoutSubviews() {
        setZoomScale(for: self.view.bounds.size)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
