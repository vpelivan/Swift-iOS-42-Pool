//
//  ViewController.swift
//  Day06
//
//  Created by Viktor PELIVAN on 10/8/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    var shapes: [Shape] = []
    var select: Shape?
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var motionManager = CMMotionManager();
    let behaviour = UIDynamicItemBehavior()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action:  #selector(panGesture(gesture:)))
        view.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture:)))
        view.addGestureRecognizer(tapGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(gesture:)))
        view.addGestureRecognizer(pinchGesture)
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateGesture(gesture:)))
        view.addGestureRecognizer(rotateGesture)
        }
    
    func addOnView(point: CGPoint)
    {
        if (self.animator == nil)
        {
            self.animator = UIDynamicAnimator(referenceView: self.view)
            self.collision = UICollisionBehavior()
            self.collision.translatesReferenceBoundsIntoBoundary = true
            self.gravity = UIGravityBehavior()
            self.animator?.addBehavior(self.gravity!)
            self.animator?.addBehavior(self.collision!)
            self.behaviour.elasticity = 1
        }
        addShape(point: point)
    }
    
    func addShape(point: CGPoint)
    {
        DispatchQueue.main.async {
            let shape = Shape()
            shape.center = point
            self.shapes.append(shape)
            self.view.addSubview(shape)
            shape.bounds.size = CGSize(width: 100, height: 100)
            self.gravity.addItem(shape)
            self.collision.addItem(shape)
            self.behaviour.addItem(shape)
        }
    }
    
    @objc func rotateGesture(gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .began:
            let tapLocation = gesture.location(in: self.view)
            for i in shapes {
                if (i.layer.presentation()?.frame.contains(tapLocation))! {
                    select = i
                    break
                }
            }
            if select != nil {
                gravity.removeItem(select!)
                collision.removeItem(select!)
                behaviour.removeItem(select!)
                self.view.bringSubviewToFront(select!)
            }
        case .changed:
            if select != nil {
                collision.removeItem(select!)
                select!.transform = select!.transform.rotated(by: gesture.rotation)
                animator.updateItem(usingCurrentState: select!)
                gesture.rotation = 0
                collision.addItem(select!)
            }
        default:
            if select != nil {
                gravity.addItem(select!)
                collision.addItem(select!)
                behaviour.addItem(select!)
                select = nil
            }
        }
    }
    
    @objc func pinchGesture(gesture: UIPinchGestureRecognizer) {
        var lastdist: CGFloat = 1
        switch gesture.state {
        case .began:
            let tapLocation = gesture.location(in: self.view)
            for i in shapes {
                if (i.layer.presentation()?.frame.contains(tapLocation))! {
                    select = i
                    break
                }
            }
            if select != nil {
                collision.removeItem(select!)
                behaviour.removeItem(select!)
                gravity.removeItem(select!)
                self.view.bringSubviewToFront(select!)
                lastdist = gesture.scale
            }
        case .changed:
            if select != nil {
                collision.removeItem(select!)
                select!.bounds.size = CGSize(width: 100 * (gesture.scale/lastdist), height: 100 * (gesture.scale/lastdist))
                animator.updateItem(usingCurrentState: select!)
                collision.addItem(select!)
            }
        default:
            if select != nil {
                print("pan.default \(select!.center)")
                gravity.addItem(select!)
                behaviour.addItem(select!)
                select = nil
            }
        }
    }
    
    @objc func tapGesture(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            addOnView(point: gesture.location(in: view))
        default:
            break
        }
    }
    
    @objc func panGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            for i in shapes {
                if (i.layer.presentation()?.frame.contains(gesture.location(in: self.view)))! {
                    select = i
                    break
                }
            }
            if select != nil {
                self.view.bringSubviewToFront(select!)
                gravity.removeItem(select!)
            }
        case .changed:
            if select != nil {
                select!.center = gesture.location(in: self.view)
                animator.updateItem(usingCurrentState: select!)
            }
        default:
            if select != nil {
                gravity.addItem(select!)
                select = nil
            }
        }
    }
    
    func handleAccelerometerUpdate(data: CMAccelerometerData?, error: Error?) -> Void {
        if let d = data {
            self.gravity.gravityDirection = CGVector(dx: d.acceleration.x, dy: -d.acceleration.y);
        }
    }
    
}
