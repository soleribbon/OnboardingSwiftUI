//
//  AnimatedActionButton.swift
//  TestingOnboarding
//
//  Created by Ravi Heyne on 22/04/24.
//
import SwiftUI


class ActionButtonHostingViewController: UIViewController {
    var buttonAction: (() -> Void)?
    var buttonTitle: String?
    private var originalButtonText: String?
    private var activityIndicator: UIActivityIndicatorView?
    private let actionButtonColor = Globals.actionButtonColor
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let button = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }

    //SETUP
    private func setupButton() {

        button.setTitle(buttonTitle, for: .normal)
        //        set font weight without explicit size definition
        if let currentFontSize = button.titleLabel?.font.pointSize {
            button.titleLabel?.font = UIFont.systemFont(ofSize: currentFontSize, weight: .semibold)
        }
        button.backgroundColor = actionButtonColor
        button.tintColor = .white
        button.layer.cornerRadius = 10

        //TARGETS
        button.addTarget(self, action: #selector(actionButtonDown), for: .touchDown)
        button.addTarget(self, action: #selector(actionButtonUpConfirm), for: .touchUpInside)
        button.addTarget(self, action: #selector(actionButtonUp), for: .touchUpOutside)


        view.addSubview(button)

        //CONSTRANTS
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])


    }

    @objc func actionButtonDown(sender: UIButton) {
        feedbackGenerator.prepare()
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.allowUserInteraction, .curveLinear],
                       animations: {
            sender.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        })
    }

    @objc open func actionButtonUp(sender: UIButton) {

        //User finger outside button bounds
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.allowUserInteraction, .curveEaseOut], animations:
                        {
            sender.transform = .identity
            sender.layoutIfNeeded()
        })
    }
    @objc func actionButtonUpConfirm(sender: UIButton) {
        self.feedbackGenerator.impactOccurred()
        self.buttonAction?()
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.allowUserInteraction, .curveEaseOut],
                       animations: {
            sender.transform = .identity
            sender.layoutIfNeeded()
        })
    }
}
struct ActionButtonHostingController: UIViewControllerRepresentable {
    var buttonAction: () -> Void
    var buttonTitle: String

    func makeUIViewController(context: Context) -> ActionButtonHostingViewController {
        let viewController = ActionButtonHostingViewController()
        viewController.buttonAction = buttonAction
        viewController.buttonTitle = buttonTitle

        return viewController
    }

    func updateUIViewController(_ uiViewController: ActionButtonHostingViewController, context: Context) {
        // Update the view controller if needed
        // uiViewController.buttonTitle = buttonTitle
    }
}
