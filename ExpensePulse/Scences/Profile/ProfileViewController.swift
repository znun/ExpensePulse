import UIKit

class ProfileViewController: GMMainViewController {
    // MARK: - Content

    private enum Constant {
        static let padding: CGFloat = 16
    }

    private enum Content {
        static let title = "Profile"
       // static let notification = "Notifications"
        //static let settings = "Settings"
       // static let aboutUs = "About Us"
        //static let help = "Help & Support"
        static let logout = "Logout"
        static let tool = "Tools"
    }

    // MARK: - Private properties

    private let viewModel = ProfileViewModel()

    private lazy var profileView: ProfileView = .init()

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(K.Image.edit, for: .normal)
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()

//    private lazy var notificationActionView: GMLabelActionView = .init(
//        text: Content.notification,
//        icLeft: UIImage(systemName: "bell")
//    )

//    private lazy var settingsActionView: GMLabelActionView = .init(
//        text: Content.settings,
//        icLeft: UIImage(systemName: "gearshape"),
//        action: { [weak self] in
//            let toolVC = SettingsViewController()
//            self?.navigationController?.pushViewController(toolVC, animated: true)
//        }
//    )

    private lazy var toolsActionView: GMLabelActionView = .init(
        text: Content.tool,
        icLeft: UIImage(systemName: "wrench.and.screwdriver"),
        action: { [weak self] in
            let toolVC = ToolsViewController()
            self?.navigationController?.pushViewController(toolVC, animated: true)
        }
    )

//    private lazy var aboutActionView: GMLabelActionView = .init(
//        text: Content.aboutUs,
//        icLeft: UIImage(systemName: "info.circle"),
//        action: { [weak self] in
//            self?.openURL(K.URL.github)
//        }
//    )

//    private lazy var helpActionView: GMLabelActionView = .init(
//        text: Content.help,
//        icLeft: UIImage(systemName: "questionmark.circle"),
//        icRight: nil,
//        action: { [weak self] in
//            self?.openURL(K.URL.github)
//        }
//    )

    private lazy var stackActions: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubviews(
           // notificationActionView,
           // settingsActionView,
            toolsActionView
           // aboutActionView,
           // helpActionView
        )
        return stackView
    }()

    private lazy var logoutLabel: GMLabel = .init(text: Content.logout, style: .regularBold)

    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(K.Image.power, for: .normal)
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()

    // MARK: - Setup nav bar

    override func configureBackButton() {
        configureRootTitle(
            leftImage: K.Image.profile,
            leftTitle: Content.title
        )
    }

    // MARK: - LifeCircle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        profileView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        stackActions.transform = CGAffineTransform(translationX: 10, y: 0)
        logoutLabel.transform = CGAffineTransform(translationX: 10, y: 0)
        logoutButton.transform = CGAffineTransform(translationX: 0, y: 10)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.profileView.transform = .identity
            self.stackActions.transform = .identity
            self.logoutLabel.transform = .identity
            self.logoutButton.transform = .identity
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserInfo()
    }

    // MARK: - Setup layout

    override func setupLayout() {
        super.setupLayout()

        view.addSubviews(
            profileView,
            editButton,
            stackActions,
            logoutLabel,
            logoutButton
        )

        profileView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            paddingTop: 32,
            paddingLeft: Constant.padding
        )

        editButton.anchor(
            right: view.rightAnchor,
            paddingRight: Constant.padding,
            width: 30,
            height: 30
        )
        editButton.centerYToView(profileView)

        stackActions.anchor(
            top: profileView.bottomAnchor,
            left: profileView.leftAnchor,
            right: editButton.rightAnchor,
            paddingTop: 32
        )

        logoutLabel.anchor(
            top: stackActions.bottomAnchor,
            left: stackActions.leftAnchor,
            paddingTop: 32
        )

        logoutButton.anchor(
            top: logoutLabel.topAnchor,
            right: stackActions.rightAnchor,
            width: 30,
            height: 30
        )
        logoutButton.centerYToView(logoutLabel)
    }

    @objc private func didTapEdit() {
        print("go to edit profile")
    }

    @objc private func didTapLogout() {
        viewModel.logOut { [weak self] err in
            if let err = err {
                self?.errorAlert(message: err.localizedDescription)
            } else {
                self?.navigateToAuthVC()
            }
        }
    }

    private func navigateToAuthVC() {
        let signInVC = SignInViewController()
        let navVC = UINavigationController(rootViewController: signInVC)

        if let delegate = view.window?.windowScene?.delegate as? SceneDelegate {
            if let window = delegate.window {
                window.rootViewController = navVC

                let options: UIView.AnimationOptions = .transitionCrossDissolve
                let duration: TimeInterval = 0.5
                UIView.transition(
                    with: window,
                    duration: duration,
                    options: options,
                    animations: {},
                    completion: { _ in }
                )
            }
        }
    }

    private func loadUserInfo() {
        viewModel.getUserInfo { user in
            if let user = user {
                self.profileView.bindUserData(user: user)
            }
        }
    }
}
