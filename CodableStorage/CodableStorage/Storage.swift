//
//  Storage.swift
//  CodableStorage
//
//  Created by weixian on 2020/2/28.
//  Copyright © 2020 weixian. All rights reserved.
//

import Foundation

typealias Handler<T> = (Result<T, Error>) -> Void

protocol ReadableStorage {
    func fetchValue(for key: String) throws -> Data
    func fetchValue(for key: String, handler: @escaping Handler<Data>)
}

protocol WritableStorage {
    func save(value: Data, for key: String) throws
    func save(value: Data, for key: String, handler: @escaping Handler<String>)
}

protocol DeletableStorage {
    func delete(for key: String) throws
    func delete(for key: String, handler: @escaping Handler<Any>)
    func deleteAll() throws
    func deleteAll(handler: @escaping Handler<Any>)
}

typealias Storage = ReadableStorage & WritableStorage & DeletableStorage

enum StorageError: Error {
    case notFound
    case cantWrite(Error)
}

