////
////  UpdateTracker.swift
////  Translate:Drawable
////
////  Created by Jacques Castonguay on 4/24/18.
////  Copyright © 2018 JaxLab. All rights reserved.
////
//
//import Foundation
//
//final class TimeTracker {
//    static let shared: TimeTracker = TimeTracker()
//
//
//    //private let filename = "TranslateDrawableTimestamp"
//    //private let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//
//
//    private init() { }
//
//    func WriteTime(newTime: String){
//        let filename = "TranslateDrawableTimestamp"
//        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//
//        let fileURL = DocumentDirURL.appendingPathComponent(filename).appendingPathExtension("txt")
//        print("FILE PATH: \(fileURL.path)")
//
//        do {
//            try newTime.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
//        }catch let error as NSError {
//            print("failed to write to URL: ")
//            print(error)
//        }
//    }
//
//    func ReadTime() -> Int {
//        let filename = "TranslateDrawableTimestamp"
//        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//
//        let fileURL = DocumentDirURL.appendingPathComponent(filename).appendingPathExtension("txt")
//        var readString = ""
//        do {
//            readString = try String(contentsOf: fileURL)
//        } catch let error as NSError {
//            do {
//                //file potentially hasn't been written to
//                try String(-1).write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
//            } catch let error2 as NSError {
//                print("Failed to read file(first try): ")
//                print(error)
//                print("failed to write to URL: ")
//                print(error2)
//            }
//            print("Failed to read file: ")
//            print(error)
//        }
//
//        let ans:Int!
//        let latestTime:Int? = Int(readString)
//        if let T = latestTime{
//            ans = T
//        } else{
//            ans = 0
//        }
//        return ans
//    }
//
//}
