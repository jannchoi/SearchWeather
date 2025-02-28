//
//  Observable.swift
//  MovieLike
//
//  Created by 최정안 on 2/5/25.
//

//import Foundation
//class Observable<T> {
//    private var closure: ((T) -> Void)?
//    
//    var value: T {
//        didSet {
//            closure?(value)
//        }
//    }
//    
//    init(_ value: T) {
//        self.value = value
//    }
//    func bind(closure: @escaping (T) -> Void) {
//        closure(value)
//        self.closure = closure
//    }
//    
//    func lazyBind(closure: @escaping (T) -> Void) {
//        self.closure = closure
//    }
//}
