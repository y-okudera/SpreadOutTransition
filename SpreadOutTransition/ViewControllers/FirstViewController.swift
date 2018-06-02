//
//  FirstViewController.swift
//  SpreadOutTransition
//
//  Created by YukiOkudera on 2018/05/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

import UIKit

final class FirstViewController: UIViewController {
    
    private let transition = SpreadOutTransition()
    
    @IBAction private func didTapToSecond(_ sender: UIButton) {
        
        transition.startPoint = sender.center
        transition.animationViewColor = sender.backgroundColor!
        
        let storyboard = UIStoryboard(name: "SecondViewController", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(
            withIdentifier: "SecondViewController") as! SecondViewController
        
        secondViewController.transitioningDelegate = self
        present(secondViewController, animated: true, completion: nil)
    }
    
    @IBAction private func didTapToThird(_ sender: UIButton) {
        
        transition.startPoint = sender.center
        transition.animationViewColor = sender.backgroundColor!
        
        let storyboard = UIStoryboard(name: "ThirdViewController", bundle: nil)
        let thirdViewController = storyboard.instantiateViewController(
            withIdentifier: "ThirdViewController") as! ThirdViewController
        
        thirdViewController.transitioningDelegate = self
        present(thirdViewController, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension FirstViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        return transition
    }
}
