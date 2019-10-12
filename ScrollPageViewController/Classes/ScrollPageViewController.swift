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
        let sv = ScrollView(frame: .zero)
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
    
    private func loadViewControllers() {
        (0..<count).compactMap { dataSource?.scrollPageViewController(self, viewControllerAt: $0) }.enumerated().forEach { (index, viewController) in
            addChild(viewController)
            scrollView.addSubview(ScrollViewCell(index: index, contentView: viewController.view))
            viewController.didMove(toParent: self)
        }
    }
    
    // MARK: Overrides
    open override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
        loadViewControllers()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: CGFloat(count) * scrollView.bounds.width, height: scrollView.bounds.height)
    }
}

class ScrollView: UIScrollView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for cell in subviews.compactMap({ $0 as? ScrollViewCell }) {
            cell.frame = CGRect(x: CGFloat(cell.index) * bounds.width, y: 0, width: bounds.width, height: bounds.height)
        }
    }
}

class ScrollViewCell: UIView {
    var index: Int
    weak var contentView: UIView?
    
    init(index: Int, contentView: UIView) {
        self.index = index
        super.init(frame: .zero)
        self.contentView = contentView
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView?.frame = bounds
    }
}
