//
//  WebViewController.swift
//  Runner
//
//  Created by webwerks1 on 3/18/21.
//

import UIKit
import WebKit
import Smartech
class WebViewController: UIViewController,WKNavigationDelegate,WKUIDelegate,SMTAppWebViewDelegate,WKScriptMessageHandler {
    
    @IBOutlet weak var viewInner: UIView!
    
    
    override func viewDidLoad() {
        let webView = WKWebView()
        viewInner.addSubview(webView)
        super.viewDidLoad()
        let dict = [
            "key1" : "value1",
            "key2" : "value2"
        ]
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.centerXAnchor.constraint(equalTo: viewInner.centerXAnchor).isActive = true
        webView.centerYAnchor.constraint(equalTo: viewInner.centerYAnchor).isActive = true
        webView.widthAnchor.constraint(equalToConstant: viewInner.frame.width).isActive = true
        webView.heightAnchor.constraint(equalToConstant: viewInner.frame.height).isActive = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let url = URL(string: "https://demo1.netcoresmartech.com/devops1_prapp15/")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        Smartech.sharedInstance().smtAppWebViewDelegate = self
        var controller = WKUserContentController()
        let userController = webView.configuration.userContentController
        controller = userController
        controller.addUserScript(Smartech.sharedInstance().getAppWebScript(dict))
        controller.add(self, name: Smartech.sharedInstance().getAppWebMessageHandler())
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        Smartech.sharedInstance().appWebDidReceive(message)
    }
    
    func handleAppWebViewEvent(_ message: WKScriptMessage) {
        
    }
    
    @IBAction func onCancelButtonTap(_ button:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
