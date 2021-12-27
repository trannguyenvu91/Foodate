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
            Entity<v1.FDBaseInvitation>("FDBaseInvitation"),
            Entity<v1.FDInvitation>("FPInvitation"),
            Entity<v1.FDSessionUser>("FDSessionUser"),
            Entity<v1.FDNotification>("FDNotification")
        ]
    }
    
    static var versionLock: VersionLock? {
        [
            "FDBaseInvitation": [0xb5ca5a599ca50fbe, 0x46b0cca31d0dd8cd, 0x5d7e9e3c1fbe03ec, 0x50878fb02c3677c6],
            "FDBasePhoto": [0x1a7c6935c75be80, 0x5ff715d4932c25e7, 0x8b07898b88815e67, 0xa93208001124b467],
            "FDBaseUser": [0xaca1362db1348c1d, 0x49fe8ad846345518, 0xa1cd37984344e454, 0xbe9ca7fc1ef069f],
            "FDNotification": [0x6d2c88b4389b4532, 0x93d548d7ad34d999, 0x67b16d0cbf9ea938, 0x5b5e7c5da3df3c7b],
            "FDPhoto": [0xee9c936c42bf9c2d, 0xd8f83c5af86ef024, 0x15101a40d606deba, 0xb58dc4658fbce356],
            "FDPlace": [0x81d3bb4d4935964a, 0xda9ce1409e6853ff, 0x4fc053cfb5f064e, 0xea8023832f0a3468],
            "FDPlacePhoto": [0xf46222e2028476d9, 0xf4086dd95d62b97, 0xa2f7f232797fa1aa, 0xc8f1db65dc1487a2],
            "FDRequester": [0x5d7ff76d13cf8eb0, 0x8cb44b87c1e0523d, 0xc19eea4ea048fdc0, 0x7b4e66e63065e8dd],
            "FDSessionUser": [0x98423e683da982dd, 0x9bc0d0c54a115eec, 0x4884ed50372de1ea, 0x4a958db2c6e63753],
            "FDUser": [0xdcdce6e858af8df5, 0x6a185737810d5d81, 0xea67f70c5a35e543, 0xc9b42d5d8bc3e265],
            "FDUserProfile": [0x148909fa52c61f87, 0xa2290e74e4b99712, 0x4097efc9dcdf4459, 0x9f9ed90e089a147a],
            "FPInvitation": [0x87ffd21ca10f78d1, 0xfd47cd265c2777c8, 0x83b1bf0b026a587a, 0x5f24f9d8f738e88d]
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

