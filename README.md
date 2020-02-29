# CodableStorage
 为Swift Codable结构实现简单的磁盘存储。

#### 导入方法：
将仓库中CodableStorage文件夹内的 `Storage.swift` , `DiskStorage.swift` , `CodableStorage.swift` 拖进项目即可

#### 使用示例：
```swift
struct Timeline: Codable {
    let tweets: [String]
}

let storage = CodableStorage()

let timeline = Timeline(tweets: ["Hello", "World", "!!!"])

// -----同步：-----

//写
do {
    try storage.save(timeline, for: "timeline")
} catch  {
    print(error)
}

//读
if let cached: Timeline = try? storage.fetch(for: "timeline")  {
    print(cached)
}

//读
do {
    let cached: Timeline = try storage.fetch(for: "timeline")
    print(cached)
} catch {
    print(error)
}

//删单个
do {
    try storage.delete(for: "timeline")
} catch  {
    print(error)
}

//删所有
do {
    try storage.deleteAll()
} catch  {
    print(error)
}

```

// -----异步：-----

```swift
//存
storage.asyncSave(timeline, for: "timeline") { result in
    switch result {
    case .success(let key):
        print("async save \(key) success")
    case .failure(let error):
        print(error)
    }
}

//取
storage.asyncFetch(for: "timeline") { (result: Result<Timeline, Error>) in
    switch result {
    case .success(let timeline):
        print(timeline)
    case .failure(let err):
        print(err)
    }
}

//删单个
storage.asyncDelete(for: "timeline") { (result) in
    switch result {
    case .success(_):
        print("删除成功")
    case .failure(let error):
        print(error)
    }
}

//删除全部
storage.asyncDeleteAll() { (result) in
    switch result {
    case .success(_):
        print("删除成功")
    case .failure(let error):
        print(error)
    }
}
```
