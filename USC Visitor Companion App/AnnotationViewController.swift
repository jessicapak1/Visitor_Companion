//
//  AnnotationViewController.swift
//  USC Visitor Companion App
//
//  Created by Edgar Lugo on 11/13/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import Gecco

class AnnotationViewController: SpotlightViewController {
    
    @IBOutlet var tutorialAnnotationViews: [UIView]!
    
    var stepIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    func next(_ labelAnimated: Bool) {
        updateAnnotationView(labelAnimated)
        
        let screenSize = UIScreen.main.bounds.size
        switch stepIndex {
        case 0:
            //settings
            spotlightView.appear(Spotlight.Oval(center: CGPoint(x: screenSize.width - 27, y: 42), diameter: 50))
        case 1:
            //filter
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: 30, y: 42), diameter: 50), moveType: .disappear)
        case 2:
            //search bar
            spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width / 2, y: 86), size: CGSize(width: screenSize.width, height: 48), cornerRadius: 6), moveType: .disappear)
        case 3:
            //current location button
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width - 47, y: screenSize.height - 47), diameter: 76), moveType: .disappear)
        case 4:
            //welcome label
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width / 2, y: screenSize.height / 2), diameter: 220), moveType: .disappear)
        case 5:
            //welcome label
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width / 2, y: screenSize.height / 2), diameter: 220), moveType: .disappear)
        case 6:
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        
        stepIndex += 1
    }
    
    func updateAnnotationView(_ animated: Bool) {
        tutorialAnnotationViews.enumerated().forEach { index, view in
            UIView.animate(withDuration: animated ? 0.25 : 0) {
                view.alpha = index == self.stepIndex ? 1 : 0
            }
        }
    }
}

extension AnnotationViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        next(false)
    }
    
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next(true)
    }
    
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}

