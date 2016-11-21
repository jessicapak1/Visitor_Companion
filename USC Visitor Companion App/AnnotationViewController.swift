//
//  AnnotationViewController.swift
//  USC Visitor Companion App
//
//  Created by yukiasai on 2016/01/19.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//  Edited by Edgar Lugo on 11/13/16.
//

import UIKit
//import Gecco

class AnnotationViewController: SpotlightViewController {
    
    @IBOutlet var tutorialAnnotationViews: [UIView]!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var stepIndex: Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    func next(_ labelAnimated: Bool) {
        updateAnnotationView(labelAnimated)
        pageControl.currentPage = stepIndex
        let screenSize = UIScreen.main.bounds.size
        
        var settingsWidthDifference : CGFloat
        var mapButtonsWidthDifference : CGFloat
        var skipButtonWidthDifference : CGFloat
        
        if screenSize.width > 375 { //5" screen
            settingsWidthDifference = 31
            mapButtonsWidthDifference = 51
            skipButtonWidthDifference = 51
        } else if screenSize.width == 375 { //4.7" screen
            settingsWidthDifference = 27
            mapButtonsWidthDifference = 47
            skipButtonWidthDifference = 51
        } else { // 4" screen
            //random numbers for noq
            settingsWidthDifference = 24
            mapButtonsWidthDifference = 44
            skipButtonWidthDifference = 40
        }
        
        switch stepIndex {
        case 0:
            //just the dark background for our text and a highlight for the skip button
            spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width/2 , y: screenSize.height-skipButtonWidthDifference), size: CGSize(width: 46, height: 30), cornerRadius: 6))
        case 1:
            //settings
            spotlightView.appear(Spotlight.Oval(center: CGPoint(x: screenSize.width - settingsWidthDifference, y: 42), diameter: 50))
        case 2:
            //filter
            spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width / 4, y: 86), size: CGSize(width: screenSize.width/2, height: 48), cornerRadius: 6), moveType: .disappear)
        case 3:
            //search bar
            spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: (screenSize.width/2)+(screenSize.width/4), y: 86), size: CGSize(width: screenSize.width/2, height: 48), cornerRadius: 6), moveType: .disappear)
        case 4:
            //current location button
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width - mapButtonsWidthDifference, y: screenSize.height - 47), diameter: 76), moveType: .disappear)
        case 5:
            //show usc button
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width - mapButtonsWidthDifference, y: screenSize.height - 117), diameter: 76), moveType: .disappear)
        case 6:
            //toggle 3d map button
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: mapButtonsWidthDifference, y: screenSize.height - 47), diameter: 76), moveType: .disappear)
        case 7:
            //all locations label
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width / 2, y: screenSize.height / 2), diameter: 220), moveType: .disappear)
        case 8:
            //welcome label
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width / 2, y: screenSize.height / 2), diameter: 220), moveType: .disappear)
        case 9:
            dismiss(animated: true, completion: nil)
        default:
            break
        }
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
    
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, isInsideSpotlight: Bool, touchPoint: CGPoint) {
        
        if (touchPoint.x < 210 && touchPoint.x > 164) && (touchPoint.y < 625 && touchPoint.y > 595) {
            stepIndex = 9
            next(true)
            return
        }
        if touchPoint.x >= UIScreen.main.bounds.midX {
            stepIndex += 1
            next(true)
        } else {
            stepIndex -= 1
            if stepIndex < 0 {
                stepIndex = 0
            }
            next(true)
        }
    }
    
    func spotLightViewControllerSwipedRight(_ viewController: SpotlightViewController) {
        stepIndex -= 1
        if stepIndex < 0 {
            stepIndex = 0
        }
        next(true)
    }
    
    func spotLightViewControllerSwipedLeft(_ viewController: SpotlightViewController) {
        stepIndex += 1
        next(true)
    }

    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}

