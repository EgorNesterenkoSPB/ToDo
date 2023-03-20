import UIKit

final class OnBoardingViewController:BaseViewController {
    
    let imageView = UIImageView()
    let mainTextLabel = UILabel()
    let secondTextLabel = UILabel()
    let nextButton = UIButton()
    let skipButton = UIButton()
    let backButton = UIButton()
    let pageControl = UIPageControl()
    var currentPage:Int = 0
    
    var presenter: (ViewToPresenterOnBoardingProtocol & InteractorToPresenterOnBoardingProtocol)?
    
    private enum UIConstants {
        static let nextButtonWidth = 150.0
        static let nextButtonHeight = 50.0
        static let skipButtonWidth = 70.0
        static let skipButtonHeight = 35.0
    }
}

extension OnBoardingViewController {
    override func addViews() {
        self.view.addView(nextButton)
        self.view.addView(imageView)
        self.view.addView(secondTextLabel)
        self.view.addView(pageControl)
        self.view.addView(mainTextLabel)
        self.view.addView(skipButton)
        self.view.addView(backButton)
    }
    
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = true
        
        settingWelcomeButtons(button: nextButton, text: Resources.Titles.next)
        settingWelcomeButtons(button: skipButton, text: Resources.Titles.skip)
        settingWelcomeButtons(button: backButton, text: Resources.Titles.back)
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)
            ), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        backButton.isHidden = true
        
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTextLabel.font = .boldSystemFont(ofSize: 22)
        mainTextLabel.textColor = .darkGray
        mainTextLabel.text = Resources.firstMainOnBoardingText
        mainTextLabel.textAlignment = .center
        mainTextLabel.numberOfLines = 0
        
        secondTextLabel.translatesAutoresizingMaskIntoConstraints = false
        secondTextLabel.textColor = .secondaryLabel
        secondTextLabel.font = .systemFont(ofSize: 18)
        secondTextLabel.text = Resources.firstSecondOnBoardingText
        secondTextLabel.numberOfLines = 0
        secondTextLabel.textAlignment = .center
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = 2
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.tintColor = .lightGray
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .darkGray
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Resources.Images.blog)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -40),
            nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: UIConstants.nextButtonWidth),
            nextButton.heightAnchor.constraint(equalToConstant: UIConstants.nextButtonHeight),
            pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor,constant: -10),
//            secondTextLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            secondTextLabel.bottomAnchor.constraint(equalTo: pageControl.topAnchor,constant: -10),
            secondTextLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor,constant: -5),
            secondTextLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 5),
//            mainTextLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mainTextLabel.bottomAnchor.constraint(equalTo: secondTextLabel.topAnchor,constant: -5),
            mainTextLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor,constant: -5),
            mainTextLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor,constant: 5),
            imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            imageView.bottomAnchor.constraint(equalTo: mainTextLabel.topAnchor,constant: -3),
            skipButton.widthAnchor.constraint(equalToConstant: UIConstants.skipButtonWidth),
            skipButton.heightAnchor.constraint(equalToConstant: UIConstants.skipButtonHeight),
            skipButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            skipButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: skipButton.bottomAnchor,constant:0),
            backButton.widthAnchor.constraint(equalToConstant: UIConstants.skipButtonWidth),
            backButton.heightAnchor.constraint(equalToConstant: UIConstants.skipButtonHeight),
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10),
            backButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 10)
        ])
    }
}

extension OnBoardingViewController {
    private func settingWelcomeButtons(button:UIButton,text:String) {
        button.setTitle(text, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemOrange
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 8
    }
    
    private func configureLastPage() {
        skipButton.isHidden = true
        backButton.isHidden = false
        nextButton.setTitle(Resources.Titles.getStarted, for: .normal)
    }
    
    private func configureFirstPage() {
        backButton.isHidden = true
        skipButton.isHidden = false
        nextButton.setTitle(Resources.Titles.next, for: .normal)
    }
}

extension OnBoardingViewController {
    
    @objc private func nextButtonTapped(_ sender:UIButton) {
        if currentPage == 1 {
//            presenter?.showLoginScreen(navigationController: navigationController)
            presenter?.showMainScreen(navigationController: navigationController)
            // CODE BELOW IS TEMPORARY !!!
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: Resources.isOnBoardingKey)
            return
        }
        self.configureLastPage()
        presenter?.showNewViewData(currentPage: currentPage + 1)
    }
    
    @objc private func backButtonTapped(_ sender:UIButton) {
        self.configureFirstPage()
        presenter?.showNewViewData(currentPage: currentPage - 1)
    }
    
    @objc private func skipButtonTapped(_ sender:UIButton) {
//        presenter?.showLoginScreen(navigationController: navigationController)
        presenter?.showMainScreen(navigationController: navigationController)
        // CODE BELOW IS TEMPORARY !!!
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Resources.isOnBoardingKey)
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer)
    {
        if sender.direction == .left && currentPage == 1
        {
            self.configureFirstPage()
            presenter?.showNewViewData(currentPage: currentPage - 1)
        }

        if sender.direction == .right && currentPage == 0
        {
            self.configureLastPage()
            presenter?.showNewViewData(currentPage: currentPage + 1)
        }
    }
}

extension OnBoardingViewController:PresenterToViewOnBoardingProtocol {
    func setNewViewData(mainText: String, secondText: String, imageName: String,currentPage:Int) {
        self.mainTextLabel.text = mainText
        self.secondTextLabel.text = secondText
        self.imageView.image = UIImage(named: imageName)
        self.pageControl.currentPage = currentPage
        self.currentPage = currentPage
    }
    
    
}
