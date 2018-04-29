//
//  DataExtensions.swift
//  CommonCryptoExample
//
//  Created by Toomas Vahter on 29/04/2018.
//  Copyright © 2018 Augmented Code. All rights reserved.
//

import Foundation
import CommonCrypto

extension Data {
    enum Algorithm {
        case sha256
        
        var digestLength: Int {
            switch self {
            case .sha256: return Int(CC_SHA256_DIGEST_LENGTH)
            }
        }
    }
    
    func hash(for algorithm: Algorithm) -> Data {
        let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: algorithm.digestLength)
        defer { hashBytes.deallocate() }
        switch algorithm {
        case .sha256:
            withUnsafeBytes { (bytes) -> Void in
                CC_SHA256(bytes, CC_LONG(algorithm.digestLength), hashBytes)
            }
        }
        
        return Data(bytes: hashBytes, count: algorithm.digestLength)
    }
}
