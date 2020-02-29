//
//  CodableStorage.swift
//  CodableStorage
//
//  Created by weixian on 2020/2/28.
//  Copyright © 2020 weixian. All rights reserved.
//

import Foundation

class CodableStorage {
    private let path: URL
    private var storage: DiskStorage
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(
        path: URL = URL(fileURLWithPath:  NSTemporaryDirectory() + "/storage"),
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.path = path
        self.storage = DiskStorage(path: path)
        self.decoder = decoder
        self.encoder = encoder
    }
    
    func fetch<T: Decodable>(for key: String) throws -> T {
        let data = try storage.fetchValue(for: key)
        return try decoder.decode(T.self, from: data)
    }
    
    func asyncFetch<T: Decodable>(for key: String, handler:@escaping Handler<T>) {
        storage.fetchValue(for: key) { result in
            handler(Result {try self.decoder.decode(T.self, from: result.get())} )
        }
    }
    
    func save<T: Encodable>(_ value: T, for key: String) throws {
        let data = try encoder.encode(value)
        try storage.save(value: data, for: key)
    }
    
    func asyncSave<T: Encodable>(_ value: T, for key: String, handler:@escaping Handler<String>) {
        do {
            let data = try encoder.encode(value)
            storage.save(value: data, for: key, handler: handler)
        } catch {
            handler(.failure(error))
        }
    }
    
    func delete(for key: String) throws {
        try storage.delete(for: key)
    }
    
    func asyncDelete(for key: String, handler: @escaping Handler<Any>) {
        storage.delete(for: key, handler: handler)
    }
    
    func deleteAll() throws {
        try storage.deleteAll()
    }
    
    func asyncDeleteAll(handler: @escaping Handler<Any>) {
        storage.deleteAll(handler: handler)
    }
}
