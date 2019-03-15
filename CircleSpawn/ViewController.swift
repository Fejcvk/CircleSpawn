//
//  ViewController.swift
//  CircleSpawn
//
//  Created by Tomek on 12/03/2019.
//  Copyright © 2019 Tomek. All rights reserved.
//

//TODO:
// 3. Jesli zlappie na rogu to wtedy ma tam zostac

import UIKit
import Foundation

extension CGFloat {
    static func random() -> CGFloat {
        return random(min: 0.0, max: 1.0)
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(max > min)
        return min + ((max - min) * CGFloat(arc4random()) / CGFloat(UInt32.max))
    }
}

extension UIColor {
    static func randomBrightColor() -> UIColor {
        return UIColor(hue: .random(),
                       saturation: .random(min: 0.5, max: 1.0),
                       brightness: .random(min: 0.7, max: 1.0),
                       alpha: 1.0)
    }
}

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UILongPressGestureRecognizer && otherGestureRecognizer is UILongPressGestureRecognizer {
            return true
        }
        return false
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(spawnCircle(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)

    }

    @objc func spawnCircle(_ tap: UITapGestureRecognizer) {
        let size: CGFloat = 100
        let spawnedView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        
        spawnedView.center = tap.location(in: view)
        spawnedView.backgroundColor = UIColor.randomBrightColor()
        spawnedView.layer.cornerRadius = size * 0.5
        view.addSubview(spawnedView)
        
        let moveCircle = UILongPressGestureRecognizer(target: self, action: #selector(moveCircle(_:)))
        spawnedView.addGestureRecognizer(moveCircle)
        
        let tripleTap = UITapGestureRecognizer(target: self, action: #selector(destroyCircle(_:)))
        tripleTap.numberOfTapsRequired = 3
        spawnedView.addGestureRecognizer(tripleTap)
        
        spawnedView.alpha = 0
        spawnedView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        UIView.animate(withDuration: 0.2) {
            spawnedView.alpha = 1
            spawnedView.transform = .identity
        }
    }
    @objc func destroyCircle(_ tap: UITapGestureRecognizer) {
        let spawnedView = tap.view!

        UIView.animate(withDuration: 0.2, animations: {
            spawnedView.alpha = 0
            spawnedView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: { completed in
            spawnedView.removeFromSuperview()
        })
    }
    
    @objc func moveCircle(_ longTap: UILongPressGestureRecognizer) {
        guard let ball = longTap.view else {return}
        let point = longTap.location(in: view)
        
        if longTap.state == UIGestureRecognizer.State.began{
            UIView.animate(withDuration: 0.2) {
                ball.alpha = 0.7
                ball.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
        }
        
        if longTap.state == UIGestureRecognizer.State.changed{
            ball.center.x = point.x
            ball.center.y = point.y
        }
        
        if longTap.state == UIGestureRecognizer.State.ended{
            UIView.animate(withDuration: 0.2) {
                ball.alpha = 1
                ball.transform = .identity
            }
        }
    }
}
