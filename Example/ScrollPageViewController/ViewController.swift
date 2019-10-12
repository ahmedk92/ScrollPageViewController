//
//  ViewController.swift
//  ScrollPageViewController
//
//  Created by ahmedk92 on 10/12/2019.
//  Copyright (c) 2019 ahmedk92. All rights reserved.
//

import UIKit
import ScrollPageViewController

class ViewController: UIViewController, ScrollPageViewControllerDataSource {
    
    private lazy var scrollPageViewController: ScrollPageViewController = {
        let cpvc = ScrollPageViewController()
        cpvc.dataSource = self
        return cpvc
    }()
    
    @IBOutlet private weak var scrollPageViewControllerContainerView: UIView!
    
    private func addScrollPageViewController() {
        addChild(scrollPageViewController)
        defer {
            scrollPageViewController.didMove(toParent: self)
        }
        scrollPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        scrollPageViewControllerContainerView.addSubview(scrollPageViewController.view)
        NSLayoutConstraint.activate([
            scrollPageViewControllerContainerView.leadingAnchor.constraint(equalTo: scrollPageViewController.view.leadingAnchor),
            scrollPageViewControllerContainerView.trailingAnchor.constraint(equalTo: scrollPageViewController.view.trailingAnchor),
            scrollPageViewControllerContainerView.topAnchor.constraint(equalTo: scrollPageViewController.view.topAnchor),
            scrollPageViewControllerContainerView.bottomAnchor.constraint(equalTo: scrollPageViewController.view.bottomAnchor),
            ])
    }

    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addScrollPageViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ScrollPageViewControllerDataSource
    func numberOfViewControllers(in scrollPageViewController: ScrollPageViewController) -> Int {
        return 8
    }
    
    func scrollPageViewController(_ scrollPageViewController: ScrollPageViewController, viewControllerAt index: Int) -> UIViewController {
        let viewController = storyboard!.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        viewController.index = index
        return viewController
    }

}

