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
            Entity<v1.FDSessionUser>("FDSessionUser")
        ]
    }
    
    static var versionLock: VersionLock? {
        [
            "FDBasePhoto": [0x1a7c6935c75be80, 0x5ff715d4932c25e7, 0x8b07898b88815e67, 0xa93208001124b467],
            "FDBaseUser": [0xaca1362db1348c1d, 0x49fe8ad846345518, 0xa1cd37984344e454, 0xbe9ca7fc1ef069f],
            "FDPhoto": [0xee9c936c42bf9c2d, 0xd8f83c5af86ef024, 0x15101a40d606deba, 0xb58dc4658fbce356],
            "FDPlace": [0x81d3bb4d4935964a, 0xda9ce1409e6853ff, 0x4fc053cfb5f064e, 0xea8023832f0a3468],
            "FDPlacePhoto": [0xf46222e2028476d9, 0xf4086dd95d62b97, 0xa2f7f232797fa1aa, 0xc8f1db65dc1487a2],
            "FDRequester": [0x5d7ff76d13cf8eb0, 0x8cb44b87c1e0523d, 0xc19eea4ea048fdc0, 0x7b4e66e63065e8dd],
            "FDSessionUser": [0x99a9daa7720c764b, 0xf898a2e0f417b39c, 0x7d4f476462beeef2, 0x6deb9058d9e5bb5d],
            "FDUser": [0x804699ef75b99dd9, 0x7f003847ff83efc5, 0x88bce1022a13865f, 0x343d490d6da4c248],
            "FDUserProfile": [0x4296c3ceeca07ec8, 0x31533e9001e5fb9, 0x7bde68e8ae400b35, 0x3ec05ef68a4e683],
            "FPInvitation": [0xbb4458b283dd282c, 0x3195fc4d33c06e57, 0x43f87771a9fd01ee, 0xf4227e9ce45ef79f]
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

