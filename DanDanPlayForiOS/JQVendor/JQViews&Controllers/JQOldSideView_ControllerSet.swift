//
//  MainMenuViewController.swift
//  H-Downloader
//
//  Created by Jefferson Qin on 2019/4/17.
//  Copyright © 2019 Jefferson Qin. All rights reserved.
//

import UIKit

/// Not Recommanded (User interaction for segues may not work)
class JQOldSideView_ControllerSet {
    
    private var parentViewController: UIViewController
    private var MainViewController: UIViewController
    private var MenuViewController: UIViewController
    private var movementTarget: CGFloat
    
    public init(withParent parent: UIViewController, withMain main: UIViewController, withMenu menu: UIViewController, withTarget movementTarget: CGFloat) {
        self.parentViewController = parent
        self.MainViewController = main
        self.MenuViewController = menu
        self.movementTarget = movementTarget
    }
    
    private var currentState : MenuState = .Collapsed
    
    private enum MenuState {
        case Collapsed
        case Expanding
        case Expanded
    }
    
    public func setUp() {
        currentState = .Collapsed // Initialize the currentStatus into .Collapsed
        parentViewController.view.addSubview(MainViewController.view)// Add the basic view(MainView) to the view now
        parentViewController.view.insertSubview(MenuViewController.view, at: 0) // Place the view to the bottom
        // Set up children relationship
        parentViewController.addChild(MenuViewController)
        MenuViewController.didMove(toParent: parentViewController)
        // Gestures
        let panGestureRecognizer = UIPanGestureRecognizer.init(target: parentViewController, action: #selector(handlePanGesture(_:)))
        self.MainViewController.view.addGestureRecognizer(panGestureRecognizer) // Add pan Gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: parentViewController, action: #selector(handleTapGesture))
        self.MainViewController.view.addGestureRecognizer(tapGestureRecognizer) // Add tap Gesture in order to release the side view
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began: // When the movement has just begun
            if (recognizer.velocity(in: parentViewController.view).x > 0) // From Left to Right
            {
                currentState = .Expanding // Change the currentStatus into .Expanding, it will be changed again when the gesture is ended (into .Expanded)
            }
        case .changed: // Is panning
            let positionX = recognizer.view!.frame.origin.x + recognizer.translation(in: parentViewController.view).x
            // Set x value, but not setting any more when it's less than 0
            recognizer.view!.frame.origin.x = positionX < 0 ? 0 : positionX
            recognizer.setTranslation(.zero, in: parentViewController.view)
        case .ended:
            let isDraggingFromLeftToRight = (recognizer.velocity(in: parentViewController.view).x > 0)
            animateMainView(shouldExpand: isDraggingFromLeftToRight)
        default:
            break
        }
    }
    
    @objc func handleTapGesture() {
        if currentState == .Expanded {animateMainView(shouldExpand: false)} // If .expanded, then collapse the side view when the main view is touched
    }
    
    private func animateMainView(shouldExpand: Bool) {
        if (shouldExpand) {
            // Animations
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.MainViewController.view.frame.origin.x = self.movementTarget
            }) { finished in
                self.currentState = .Expanded
            }
        } else {
            // Animations
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.MainViewController.view.frame.origin.x = 0
            }) { finished in
                self.currentState = .Collapsed
            }
        }
    }
    
}
