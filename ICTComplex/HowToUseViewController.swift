import UIKit

var images = ["cat1", "cat2", "dog1", "dog2", "dog3", "dog3"]

class HowToUseViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    let numOfTouchs = 2

    @IBOutlet weak var imgView: UIImageView!
    
    private let pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
    private let pageControl: UIPageControl = {
       let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .white
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private func instantiateViewController(index: Int, color: UIColor) -> UIViewController{
        let vc = UIViewController()
        vc.view.tag = index
        vc.view.backgroundColor = color
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPageViewController()
        setPageControl()
    }
    
    private func setPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let firstVC = instantiateViewController(index: 0, color: .gray)
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func setPageControl() {
        pageControl.numberOfPages = images.count
        
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
       
}

extension HowToUseViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {return}
        
        if let vc = pageViewController.viewControllers?.first {
            pageControl.currentPage = vc.view.tag
        }
    }
}
extension HowToUseViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        
        let nextIndex = index > 0 ? index - 1 : images.count - 1
        let nextVC = instantiateViewController(index: nextIndex, color: .darkGray)
        return nextVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        
        let nextIndex = (index + 1) % images.count
        let nextVC = instantiateViewController(index: nextIndex, color: .darkGray)
        return nextVC
    }
}
