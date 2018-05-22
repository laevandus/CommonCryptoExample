//
//  ViewController.swift
//  CommonCryptoExample
//
//  Created by Toomas Vahter on 21/05/2018.
//  Copyright © 2018 Augmented Code. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: Managing the View
    
    @IBOutlet weak var stringLabel: UITextField!
    @IBOutlet weak var secretLabel: UITextField!
    @IBOutlet weak var algorithmSegmentedControl: UISegmentedControl!
    @IBOutlet weak var hmacLabel: UILabel!
    private let segments: [(algorithm: Data.Algorithm, title: String)] = [(algorithm: .md5, "MD5"), (algorithm: .sha1, "SHA1"), (algorithm: .sha224, "SHA224"), (algorithm: .sha256, "SHA256"), (algorithm: .sha512, "SHA512")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        algorithmSegmentedControl.removeAllSegments()
        segments.forEach({ algorithmSegmentedControl.insertSegment(withTitle: $0.title, at: algorithmSegmentedControl.numberOfSegments, animated: false) })
        algorithmSegmentedControl.selectedSegmentIndex = 3
    }
    
    @IBAction func stringChanged(_ sender: Any) {
        updateHash()
    }
    
    @IBAction func secretChanged(_ sender: Any) {
        updateHash()
    }
    
    @IBAction func algorithmChanged(_ sender: Any) {
        updateHash()
    }
    
    
    // MARK: Updating Hash
    
    private func updateHash() {
        guard let data = stringLabel.text?.data(using: .utf8) else {
            hmacLabel.text = ""
            return
        }
        guard let secret = secretLabel.text else {
            hmacLabel.text = ""
            return
        }
        let algorithm = segments[algorithmSegmentedControl.selectedSegmentIndex].algorithm
        let hmac = data.authenticationCode(for: algorithm, secretKey: secret).base64EncodedString()
        let hash = data.hash(for: algorithm).base64EncodedString()
        print("hmac=\(hmac).")
        print("hash=\(hash).")
        hmacLabel.text = "Message Authentication Code:\n\(hmac)\n\nHash:\n\(hash)"
    }
}
