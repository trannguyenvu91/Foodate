//
//  CoreStore+Schema.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import CoreStore

extension CoreStoreSchema {
    static var v1: CoreStoreSchema {
        CoreStoreSchema(modelVersion: "v1",
                        entities: entities,
                        versionLock: versionLock)
    }
    
    static var entities: [DynamicEntity] {
        [
            Entity<v1.FDBaseUser>("FDBaseUser", isAbstract: true),
            Entity<v1.FDUser>("FDUser"),
            Entity<v1.FDUserProfile>("FDUserProfile"),
            Entity<v1.FDBasePhoto>("FDBasePhoto", isAbstract: true),
            Entity<v1.FDPhoto>("FDPhoto"),
            Entity<v1.FDPlacePhoto>("FDPlacePhoto"),
            Entity<v1.FDPlace>("FDPlace"),
            Entity<v1.FDRequester>("FDRequester"),
            Entity<v1.FDInvitation>("FPInvitation"),
            Entity<v1.FDSessionUser>("FDSessionUser"),
            Entity<v1.FDNotification>("FDNotification")
        ]
    }
    
    static var versionLock: VersionLock? {
        [
            "FDBasePhoto": [0x1a7c6935c75be80, 0x5ff715d4932c25e7, 0x8b07898b88815e67, 0xa93208001124b467],
            "FDBaseUser": [0xaca1362db1348c1d, 0x49fe8ad846345518, 0xa1cd37984344e454, 0xbe9ca7fc1ef069f],
            "FDNotification": [0x4d140dc3ce35db67, 0xc61c17bb6f1b7290, 0xe9116f239e0beeea, 0x6a9618f966b22e8d],
            "FDPhoto": [0xee9c936c42bf9c2d, 0xd8f83c5af86ef024, 0x15101a40d606deba, 0xb58dc4658fbce356],
            "FDPlace": [0x81d3bb4d4935964a, 0xda9ce1409e6853ff, 0x4fc053cfb5f064e, 0xea8023832f0a3468],
            "FDPlacePhoto": [0xf46222e2028476d9, 0xf4086dd95d62b97, 0xa2f7f232797fa1aa, 0xc8f1db65dc1487a2],
            "FDRequester": [0x5d7ff76d13cf8eb0, 0x8cb44b87c1e0523d, 0xc19eea4ea048fdc0, 0x7b4e66e63065e8dd],
            "FDSessionUser": [0x8c0ed7847c2e70b2, 0x5fa7e6ccacc56d7d, 0x1908e881d9b3e0bf, 0x7a862e779b397b40],
            "FDUser": [0x9cf6e180bb784deb, 0xe5582c22956b47a3, 0x807070949d9e38be, 0x67cdf732d8f249b8],
            "FDUserProfile": [0x98643143227591d9, 0x5608799d2714354d, 0xfdfde8eb3822ab70, 0x98beafcd243bc7c5],
            "FPInvitation": [0xc9aa1ed00f636602, 0x25f412b0337dc66d, 0x98832f46023c7e64, 0x39763b1cff3cb95c]
        ]
    }
}


extension CustomSchemaMappingProvider.CustomMapping {
    static func defaultTransfromEntity(source: String, destination: String) -> Self {
        .transformEntity(sourceEntity: source, destinationEntity: destination) { (source, destination) in
            let new = destination()
            new.enumerateAttributes { (attribute, sourceAttribute) in
                if let sourceAttribute = sourceAttribute {
                    new[attribute] = source[sourceAttribute]
                }
            }
        }
    }
}

