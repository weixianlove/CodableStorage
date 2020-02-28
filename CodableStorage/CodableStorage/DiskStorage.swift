//
//  DiskStorage.swift
//  CodableStorage
//
//  Created by weixian on 2020/2/28.
//  Copyright © 2020 weixian. All rights reserved.
//

import Foundation

class DiskStorage {
    private let path: URL
    private let queue: DispatchQueue
    private let fileManager: FileManager
    
    init(
        path: URL,
        queue: DispatchQueue = .init(label: "DiskCache.Queue"),
        fileManager: FileManager = FileManager.default
    ) {
        self.path = path
        self.queue = queue
        self.fileManager = fileManager
    }
    
    private func createFolders(in url: URL) throws {
        let folderUrl = url.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: folderUrl.path) {
            try fileManager.createDirectory(
                at: folderUrl,
                withIntermediateDirectories: true,
                attributes: nil)
        }
    }
}


extension DiskStorage: WritableStorage {
    func save(value: Data, for key: String) throws {
        let url = path.appendingPathComponent(key)
        do {
            try self.createFolders(in: url)
            try value.write(to: url, options: .atomic)
        } catch {
            throw StorageError.cantWrite(error)
        }
    }
    
    func save(value: Data, for key: String, handler: @escaping Handler<Data>) {
        queue.async {
            do {
                try self.save(value: value, for: key)
                handler(.success(value))
            } catch {
                handler(.failure(error))
            }
        }
    }
}

extension DiskStorage: ReadableStorage {
    func fetchValue(for key: String) throws -> Data {
        let url = path.appendingPathComponent(key)
        guard let data = fileManager.contents(atPath: url.path) else {
            throw StorageError.notFound
        }
        return data
    }
    
    func fetchValue(for key: String, handler: @escaping Handler<Data>) {
        queue.async {
            handler(Result { try self.fetchValue(for: key) })
        }
    }
}

