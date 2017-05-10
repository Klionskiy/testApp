//
//  ViewDrawerViewController.swift
//  TestApp
//
//  Created by Gosha K on 08.05.17.
//  Copyright © 2017 Gosha K. All rights reserved.
//

import UIKit

class ViewDrawerViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    var numberOfViews = 0
    var multiplyer: CGFloat = 0

    struct offSets
    {
        var xOffset: CGFloat
        var yOffset: CGFloat
        var width: CGFloat
        var hight: CGFloat
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        numberOfViews = SharingManager.number
        if numberOfViews > 0
        {
            if UIDevice.current.orientation.isPortrait
            {
            multiplyer = self.view.frame.width/CGFloat(numberOfViews)
            drawViewsWithoutTabBar(number: numberOfViews, offSet: offSets(xOffset: self.view.frame.origin.x + multiplyer/2, yOffset: self.view.frame.origin.y + multiplyer/2 + UIApplication.shared.statusBarFrame.height, width: self.view.frame.width - multiplyer, hight: self.view.frame.height - (multiplyer + (self.tabBarController?.tabBar.frame.height)! + UIApplication.shared.statusBarFrame.height)), multiplyer: multiplyer)
            }
            else
            {
            multiplyer = (self.view.frame.height - (tabBarController?.tabBar.frame.height)!)/CGFloat(numberOfViews)
            drawViewsWithoutTabBar(number: numberOfViews, offSet: offSets(xOffset: self.view.frame.origin.x + multiplyer/2, yOffset: self.view.frame.origin.y + self.multiplyer/2, width: self.view.frame.width - multiplyer, hight: self.view.frame.height - (multiplyer + (tabBarController?.tabBar.frame.height)!)), multiplyer: multiplyer)
            }
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.view.subviews.forEach{$0.removeFromSuperview()}
    }
    
    //MARK: - Perform changing orientations
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil){extensionContext in
            self.view.subviews.forEach{$0.removeFromSuperview()}
            
            if extensionContext.containerView.frame.height > extensionContext.containerView.frame.width
            {
                self.multiplyer = self.view.frame.width/CGFloat(self.numberOfViews)
                let offSet = offSets(xOffset: self.view.frame.origin.x + self.multiplyer/2, yOffset: self.view.frame.origin.y + self.multiplyer/2 + UIApplication.shared.statusBarFrame.height, width: self.view.frame.width - self.multiplyer, hight: self.view.frame.height - (self.multiplyer + (self.tabBarController?.tabBar.frame.height)! + UIApplication.shared.statusBarFrame.height))
                
                UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.75, options: .curveEaseInOut, animations: {
                    self.drawViewsWithoutTabBar(number: self.numberOfViews, offSet: offSet, multiplyer: self.multiplyer)}, completion: nil)
            }
            else
            {
                self.multiplyer = (self.view.frame.height - (self.tabBarController?.tabBar.frame.height)!)/CGFloat(self.numberOfViews)
                let offSet = offSets(xOffset: self.view.frame.origin.x + self.multiplyer/2, yOffset: self.view.frame.origin.y + self.multiplyer/2, width: self.view.frame.width - self.multiplyer, hight: self.view.frame.height - (self.multiplyer + (self.tabBarController?.tabBar.frame.height)!))
                
                UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.75, options: .curveEaseInOut, animations: {
                    self.drawViewsWithoutTabBar(number: self.numberOfViews, offSet: offSet, multiplyer: self.multiplyer)}, completion: nil)
            }
        }
    }
    
    //MARK: - drawViews functions
    
    func drawViewsWithoutTabBar(number: Int, offSet: offSets, multiplyer: CGFloat)
    {
        if number == 0{
            makeRoundedCorners()
            return
        }
        let index = number - 1
        let newView = PyramideView(frame: CGRect(x: offSet.xOffset, y: offSet.yOffset, width: offSet.width, height: offSet.hight))
        newView.layer.borderWidth = 1
        newView.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(newView)
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                newView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        PyramideView.animate(withDuration: 0.15, animations: {
            newView.backgroundColor = self.getRandomColor()
        }, completion: {_ in
            let offSet = offSets(xOffset: newView.frame.origin.x + multiplyer/2, yOffset: newView.frame.origin.y + multiplyer/2, width: newView.frame.width - multiplyer, hight: newView.frame.height - multiplyer)
            self.drawViewsWithoutTabBar(number: index, offSet: offSet, multiplyer: multiplyer)
        })
    }
    
    func makeRoundedCorners()
    {
        for (index, subview) in self.view.subviews.enumerated().reversed()
            {
            if let view = subview as? PyramideView
            {
                let animation = CABasicAnimation(keyPath: "cornerRadius")
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                animation.fromValue = 0
                animation.toValue = 12
                animation.duration = 0.25
                animation.beginTime = CACurrentMediaTime() + Double(self.view.subviews.count - index)
                view.layer.add(animation, forKey: "cornerRadius")
            }
        }
    }
    
    //MARK: -  Generate random color
    
    func getRandomColor() -> UIColor
    {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
}

