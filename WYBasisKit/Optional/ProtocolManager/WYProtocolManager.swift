//
//  WYProtocolManager.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/11/6.
//

import Foundation

@objc protocol WYMultiDelegate: NSObjectProtocol {
    
    @objc optional func test()
}

struct WYProtocolManager {

    static let shared: WYProtocolManager = WYProtocolManager()
    
    private let multiProtocol: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    func test() {
        
        invoke { $0.test!() }
    }
    
    func add(_ delegate: WYMultiDelegate) {
        
        multiProtocol.add(delegate)
    }
    
    func remove(_ delegate: WYMultiDelegate) {
        
        invoke {
          
            if $0 === delegate as AnyObject {
                
                multiProtocol.remove($0)
            }
        }
    }
    
    func removeAll() {
        
        multiProtocol.removeAllObjects()
    }
    
    private func invoke(_ invocation: (WYMultiDelegate) -> Void) {
        
      for delegate in multiProtocol.allObjects.reversed() {
        
        invocation(delegate as! WYMultiDelegate)
      }
    }
}


