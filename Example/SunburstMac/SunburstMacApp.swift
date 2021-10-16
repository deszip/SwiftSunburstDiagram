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
//            ContentView(configuration: SunburstConfiguration(nodes: [
//                Node(name: "Walking",
//                     showName: true,
//                     image: UIImage(named: "walking"),
//                     value: 10.0,
//                     backgroundColor: .systemBlue, children: [
//                        Node(name: "Day",
//                             showName: true,
//                             image: UIImage(named: "walking"),
//                             value: 10.0,
//                             backgroundColor: .systemBlue),
//                        Node(name: "Night",
//                             showName: true,
//                             image: UIImage(named: "walking"),
//                             value: 15.0,
//                             backgroundColor: .systemBlue),
//                     ]),
//                Node(name: "Restaurant",
//                     showName: true,
//                     image: UIImage(named: "eating"),
//                     value: 10.0,
//                     backgroundColor: .systemRed),
//                Node(name: "Home",
//                     showName: true,
//                     image: UIImage(named: "house"),
//                     value: 10.0,
//                     backgroundColor: .systemTeal)
//            ], calculationMode: .parentIndependent()))
            
            ContentView(configuration: SunburstConfiguration(nodes: nodeTree(at: URL(fileURLWithPath: "/tmp")), calculationMode: .parentIndependent()))
        }
    }
    
    func nodeTree(at url: URL) -> [Node] {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) {
            if isDir.boolValue {
                print("Going into \(url)")
                do {
                    return try FileManager.default.contentsOfDirectory(atPath: url.path).map {
                        nodeTree(at: URL(fileURLWithPath: $0))
                    }.flatMap { $0 }
                } catch {
                    //...
                }
            } else {
                print("Mapping \(url)")
                return [Node(name: url.lastPathComponent, showName: true, image: nil, value: metric(for: FileManager.default.contents(atPath: url.absoluteString)!), backgroundColor: nil, children: [])]
            }
        }
        
        return []
    }
    
    func metric(for data: Data) -> Double {
        return Double(data.count)
    }

}
