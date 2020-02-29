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
```
