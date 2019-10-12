//
//  ScrollPageViewController.swift
//  Pods-ScrollPageViewController_Example
//
//  Created by Ahmed Khalaf on 10/12/19.
//

import UIKit

public protocol ScrollPageViewControllerDataSource: AnyObject {
    func numberOfViewControllers(in scrollPageViewController: ScrollPageViewController) -> Int
    func scrollPageViewController(_ scrollPageViewController: ScrollPageViewController, viewControllerAt index: Int) -> UIViewController
}

open class ScrollPageViewController: UIViewController {
    // MARK: API
    open weak var dataSource: ScrollPageViewControllerDataSource?
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internals
    private var count: Int {
        return dataSource?.numberOfViewControllers(in: self) ?? 0
    }
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: .zero)
        sv.isPagingEnabled = true
        return sv
    }()
    private func addScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    // MARK: Overrides
    open override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: CGFloat(count) * scrollView.bounds.width, height: scrollView.bounds.height)
    }
}
