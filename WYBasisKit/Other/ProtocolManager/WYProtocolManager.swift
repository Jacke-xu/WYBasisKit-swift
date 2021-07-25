//
//  WYProtocolManager.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/11/6.
//

import Foundation

@objc protocol WYProtocoDelegate: NSObjectProtocol {
    @objc optional func test()
}

public struct WYProtocolManager {

    public static let shared: WYProtocolManager = WYProtocolManager()
    
    private let multiProtocol: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    func test() {
        invoke { $0.test!() }
    }
    
    func add(delegate: WYProtocoDelegate) {
        multiProtocol.add(delegate)
    }
    
    func remove(delegate: WYProtocoDelegate) {
        invoke {
            if $0 === delegate as AnyObject {
                multiProtocol.remove($0)
            }
        }
    }
    
    func removeAll() {
        multiProtocol.removeAllObjects()
    }
    
    private func invoke(_ invocation: (WYProtocoDelegate) -> Void) {
      for delegate in multiProtocol.allObjects.reversed() {
        invocation(delegate as! WYProtocoDelegate)
      }
    }
}


