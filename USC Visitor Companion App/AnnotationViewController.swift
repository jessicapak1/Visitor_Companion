//
//  AnnotationViewController.swift
//  USC Visitor Companion App
//
//  Created by yukiasai on 2016/01/19.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//  Edited by Edgar Lugo on 11/13/16.
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
            spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width / 4, y: 86), size: CGSize(width: screenSize.width/2, height: 48), cornerRadius: 6), moveType: .disappear)
        case 2:
            //search bar
            spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: (screenSize.width/2)+(screenSize.width/4), y: 86), size: CGSize(width: screenSize.width/2, height: 48), cornerRadius: 6), moveType: .disappear)
        case 3:
            //current location button
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width - 47, y: screenSize.height - 47), diameter: 76), moveType: .disappear)
        case 4:
            //show usc button
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width - 47, y: screenSize.height - 117), diameter: 76), moveType: .disappear)
        case 5:
            //toggle 3d map button
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: 47, y: screenSize.height - 47), diameter: 76), moveType: .disappear)
        case 6:
            //all locations label
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width / 2, y: screenSize.height / 2), diameter: 220), moveType: .disappear)
        case 7:
            //welcome label
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width / 2, y: screenSize.height / 2), diameter: 220), moveType: .disappear)
        case 8:
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

