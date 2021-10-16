//
//  SunburstMacApp.swift
//  SunburstMac
//
//  Created by Deszip on 17.09.2021.
//  Copyright © 2021 Ludovic Landry. All rights reserved.
//

import SwiftUI
import SunburstDiagram

@main
struct SunburstMacApp: App {
    var body: some Scene {
        WindowGroup {
            let tree = nodeTree(at: URL(fileURLWithPath: "/tmp"))
            ContentView(configuration: SunburstConfiguration(nodes: tree, calculationMode: .parentIndependent()))
        }
    }
    
    func nodeTree(at url: URL) -> [Node] {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) {
            if isDir.boolValue {
                do {
                    return try FileManager.default.contentsOfDirectory(atPath: url.path).map {
                        let children = nodeTree(at: url.appendingPathComponent($0))
                        return Node(name: url.lastPathComponent, showName: true, image: nil, value: 0, backgroundColor: nil, children:children)
                    }.compactMap { $0 }
                } catch {
                    print(error)
                }
            } else {
                let content = FileManager.default.contents(atPath: url.path) ?? Data()
                return [Node(name: url.lastPathComponent, showName: true, image: nil, value: metric(for: content), backgroundColor: nil, children: [])]
            }
        } else {
            print("\(url) does not exist")
        }
        
        return []
    }
    
    func metric(for data: Data) -> Double {
        return Double(data.count)
    }

}
