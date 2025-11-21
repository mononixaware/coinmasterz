//
//  ObservableConvertibleType+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import RxSwift

public extension ObservableConvertibleType {
    
    func onNext(_ onNext: @escaping (Element) -> Void) -> Observable<Element> {
        asObservable().do(onNext: onNext)
    }
    
    func onError(_ onError: @escaping (Error) -> Void) -> Observable<Element> {
        asObservable().do(onError: onError)
    }
    
    func weak<Object: AnyObject, Result>(_ object: Object, _ selector: @escaping (Object, Element) throws -> Observable<Result>) -> Observable<Result> {
        asObservable().flatMap { [weak object] element -> Observable<Result> in
            guard let object else {
                return .error(RxError.noElements)
            }
            return try selector(object, element)
        }
    }
    
    func weak<Object: AnyObject, Result>(_ object: Object, _ selector: @escaping (Object, Element) throws -> Result) -> Observable<Result> {
        asObservable().flatMap { [weak object] element -> Observable<Result> in
            guard let object else {
                return .error(RxError.noElements)
            }
            return .just(try selector(object, element))
        }
    }
    
    func disposed(by disposeBag: DisposeBag) {
        asObservable().subscribe().disposed(by: disposeBag)
    }
}
