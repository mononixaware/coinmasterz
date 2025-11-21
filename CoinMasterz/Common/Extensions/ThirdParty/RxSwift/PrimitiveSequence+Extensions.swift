//
//  PrimitiveSequence+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Foundation
import RxSwift

public extension PrimitiveSequence where Trait == SingleTrait {
    
    func onNext(_ onNext: @escaping (Element) -> Void) -> Single<Element> {
        asObservable().do(onNext: onNext).asSingle()
    }
    
    func onError(_ onError: @escaping (Error) -> Void) -> Single<Element> {
        asObservable().do(onError: onError).asSingle()
    }
    
    func onError<Object: AnyObject>(with object: Object,
                                    _ onError: @escaping (Object, Error) -> Void) -> Single<Element> {
        self.onError { [weak object] in
            if let object {
                onError(object, $0)
            }
        }
    }
    
    func weak<Object: AnyObject, Result>(
        _ object: Object,
        _ selector: @escaping (Object, Element) throws -> Single<Result>
    ) -> Single<Result> {
        flatMap { [weak object] in
            if let object {
                try selector(object, $0)
            } else {
                Single<Result>.error(RxError.noElements)
            }
        }
    }
    
    func weak<Object: AnyObject, Result>(
        _ object: Object,
        _ selector: @escaping (Object, Element) throws -> Result
    ) -> Single<Result> {
        weak(object) {
            Single<Result>.just(try selector($0, $1))
        }
    }
    
    func traceError(file: String = #file, function: String = #function) -> Single<Element> {
        onError {
            trace($0, caller: file.nsString.lastPathComponent, function: function)
        }
    }
}
