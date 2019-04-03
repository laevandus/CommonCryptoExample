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
        case md5
        case sha1
        case sha224
        case sha256
        case sha384
        case sha512
        
        var digestLength: Int {
            switch self {
            case .md5: return Int(CC_MD5_DIGEST_LENGTH)
            case .sha1: return Int(CC_SHA1_DIGEST_LENGTH)
            case .sha224: return Int(CC_SHA224_DIGEST_LENGTH)
            case .sha256: return Int(CC_SHA256_DIGEST_LENGTH)
            case .sha384: return Int(CC_SHA384_DIGEST_LENGTH)
            case .sha512: return Int(CC_SHA512_DIGEST_LENGTH)
            }
        }
    }
}

extension Data.Algorithm: RawRepresentable {
    typealias RawValue = Int
    
    init?(rawValue: Int) {
        switch rawValue {
        case kCCHmacAlgMD5: self = .md5
        case kCCHmacAlgSHA1: self = .sha1
        case kCCHmacAlgSHA224: self = .sha224
        case kCCHmacAlgSHA256: self = .sha256
        case kCCHmacAlgSHA384: self = .sha384
        case kCCHmacAlgSHA512: self = .sha512
        default: return nil
        }
    }
    
    var rawValue: Int {
        switch self {
        case .md5: return kCCHmacAlgMD5
        case .sha1: return kCCHmacAlgSHA1
        case .sha224: return kCCHmacAlgSHA224
        case .sha256: return kCCHmacAlgSHA256
        case .sha384: return kCCHmacAlgSHA384
        case .sha512: return kCCHmacAlgSHA512
        }
    }
}

extension Data {
    func authenticationCode(for algorithm: Algorithm, secretKey: String = "") -> Data {
        guard let secretKeyData = secretKey.data(using: .utf8) else { fatalError() }
        return authenticationCode(for: algorithm, secretKey: secretKeyData)
    }
    
    func authenticationCode(for algorithm: Algorithm, secretKey: Data) -> Data {
        let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: algorithm.digestLength)
        defer { hashBytes.deallocate() }
        withUnsafeBytes { (buffer) in
            secretKey.withUnsafeBytes({ (secretKeyBuffer) in
                CCHmac(CCHmacAlgorithm(algorithm.rawValue), secretKeyBuffer.baseAddress!, secretKeyBuffer.count, buffer.baseAddress!, buffer.count, hashBytes)
            })
        }
        return Data(bytes: hashBytes, count: algorithm.digestLength)
    }
}

extension Data {
    func hash(for algorithm: Algorithm) -> Data {
        let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: algorithm.digestLength)
        defer { hashBytes.deallocate() }
        switch algorithm {
        case .md5:
            withUnsafeBytes { (buffer) -> Void in
                CC_MD5(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
            }
        case .sha1:
            withUnsafeBytes { (buffer) -> Void in
                CC_SHA1(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
            }
        case .sha224:
            withUnsafeBytes { (buffer) -> Void in
                CC_SHA224(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
            }
        case .sha256:
            withUnsafeBytes { (buffer) -> Void in
                CC_SHA256(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
            }
        case .sha384:
            withUnsafeBytes { (buffer) -> Void in
                CC_SHA384(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
            }
        case .sha512:
            withUnsafeBytes { (buffer) -> Void in
                CC_SHA512(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
            }
        }
        return Data(bytes: hashBytes, count: algorithm.digestLength)
    }
}
