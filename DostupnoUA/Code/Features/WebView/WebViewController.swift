//
//  WebViewController.swift
//  DostupnoUA
//
//  Created by admin on 02.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import WebKit

enum WebType {
    case url, HTMLFile, HTMLString
}

class WebViewController: UIViewController {
    
    let urlString: String
    let requestType: WebType
    let pageTitle: String?
    
    private let webView = WKWebView()
    private let progressView = UIProgressView(progressViewStyle: .default)
    var observer: NSKeyValueObservation?
    
    init(urlString: String, title: String? = nil, webType: WebType = .url) {
        self.urlString = urlString
        pageTitle = title
        requestType = webType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
        prepareViews()
        trackInitialPageLoadProgress()
        loadWebView()
    }
    
    func prepareViews() {
        view.addSubview(webView, edgeInsets: .zero)
        
        progressView.progressTintColor = R.color.ickyGreen()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.heightAnchor.constraint(equalToConstant: progressView.bounds.height),
            progressView.leftAnchor.constraint(equalTo: view.leftAnchor),
            progressView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func configureNavigationBar() {
        navigationItem.title = pageTitle
        
        let backButtonItem = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButtonItem
        
        let browserItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(openBrowser))
        navigationItem.rightBarButtonItem = browserItem
    }
    
    @objc func openBrowser() {
        if let url = webView.url {
            UIApplication.shared.open(url)
        } else if requestType == .url, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func trackInitialPageLoadProgress() {
        observer = webView.observe(\.estimatedProgress, options: .new) { [weak self] _, _ in
            self?.changeProgressViewByValue(value: Float(self?.webView.estimatedProgress ?? 0))
        }
    }
    
    func changeProgressViewByValue(value: Float) {
        progressView.alpha = 1.0
        progressView.setProgress(value, animated: true)
        if webView.estimatedProgress >= 1.0 {
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                self.progressView.alpha = 0.0
            })
        }
    }
    
    func loadWebView() {
        switch requestType {
        case .url:
            if let url = URL(string: urlString) {
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        case .HTMLString:
            webView.loadHTMLString(urlString, baseURL: nil)
        case .HTMLFile:
            showHTMLByFileName(urlString)
        }
    }
    
    func showHTMLByFileName(_ fileName: String) {
        let htmlFile = Bundle.main.path(forResource: fileName, ofType: "html") ?? ""
        let htmlString = try? String(contentsOfFile: htmlFile, encoding: .utf8)
        if let htmlString = htmlString {
            webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
        }
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
