//
//  WebPlayerViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 15/10/25.
//

import RIBs
import RxSwift
import SnapKit
import UIKit
import WebKit

protocol WebPlayerPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func goBack()
    func loadURL()
}

final class WebPlayerViewController: UIViewController, WebPlayerPresentable, WebPlayerViewControllable {
    
    weak var listener: WebPlayerPresentableListener?
    private let disposeBag = DisposeBag()
    
    private var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.backgroundColor = .black
        webView.backgroundColor = .clear
        return webView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        return button
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.listener?.loadURL()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(44)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(36)
        }
        
        activityIndicator.color = .white
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        activityIndicator.startAnimating()
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.dismiss(animated: true)
                self.listener?.goBack()
            })
            .disposed(by: disposeBag)
    }
    
    func bindURL(_ url: Observable<URL?>) {
        url
            .compactMap { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] url in
                guard let self = self else { return }
                guard self.isViewLoaded else { return }
                let request = URLRequest(url: url)
                self.webView.load(request)
            })
            .disposed(by: disposeBag)
    }
}

extension WebPlayerViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        print("❌ Failed to load video:", error)
    }
}
