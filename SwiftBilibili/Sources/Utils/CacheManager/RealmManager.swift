//
//  RealmManager.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/14.
//  Copyright © 2020 luowen. All rights reserved.
//

import RealmSwift

final class RealmManager {

    static let `default` = RealmManager()

    let realm: Realm

    init() {
        var config = Realm.Configuration()
        // 使用默认的目录，但是可以使用用户名来替换默认的文件名
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("Bilibili.realm")
        // 获取我们的Realm文件的父级目录
        let folderPath = config.fileURL!.deletingLastPathComponent().path
        // 解除这个目录的保护
        do {
            try FileManager.default.setAttributes([FileAttributeKey.protectionKey: FileProtectionType.none], ofItemAtPath: folderPath)
        } catch {}
        // 创建Realm
        do {
            self.realm = try Realm(configuration: config)
        } catch let error {
            log.error(error)
            fatalError(error.localizedDescription)
        }
    }

    /// 做写入操作
    func write(_ clouse: @escaping () -> Void) {
        do {
            try realm.write {
                clouse()
            }
        } catch {}

    }
    /// 后台做写入操作
    func writeInBackground(_ clouse: @escaping () -> Void) {
        do {
            try Realm().write {
                clouse()
            }
        } catch {}

    }

    /// 添加一条数据 更新
    func addCanUpdate<T: Object>(_ clouse: () -> (T)) {
        do {
            try realm.write {
                let object = clouse()
                realm.add(object, update: .all)
            }
        } catch {}
    }
    func add<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {}
    }

    /// 写入一组数据
    /// - Parameters:
    ///   - objects: 数组
    ///   - isAsync: 是否在后台线程
    func addListData<T: Object>(_ objects: [T], isAsync: Bool = false) {
        if isAsync {
            let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
            queue.async {
                self._addListData(objects)
            }
        } else {
            self._addListData(objects)
        }
    }

    func addListData<T: Object>(_ clouse: () -> (Results<T>), isAsync: Bool = false) {

        let objects = clouse()
        var tempObjects = [T]()
        for object in objects {
            tempObjects.append(object)
        }
        if isAsync {
            let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
            queue.async {
                self._addListData(tempObjects)
            }
        } else {
            self._addListData(tempObjects)
        }
    }

    /// 删除某个数据
    func delete<T: Object>(_ object: T) throws {
        try realm.write {
            realm.delete(object)
        }
    }

    /// 批量删除数据
    func delete<T: Object>(_ objects: [T]) throws {
        try realm.write {
            realm.delete(objects)
        }
    }
    /// 批量删除数据
    func delete<T: Object>(_ objects: List<T>) throws {
        try realm.write {
            realm.delete(objects)
        }
    }
    /// 批量删除数据
    func delete<T: Object>(_ objects: Results<T>) throws {
        try realm.write {
            realm.delete(objects)
        }
    }
    /// 批量删除数据
    func delete<T: Object>(_ objects: LinkingObjects<T>) throws {
        try realm.write {
            realm.delete(objects)
        }
    }
    /// 删除所有数据。注意，Realm 文件的大小不会被改变，因为它会保留空间以供日后快速存储数据
    func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {}
        
    }
    /// 根据条件查询数据
    func selectByNSPredicate<T: Object>(_: T.Type , predicate: NSPredicate) -> Results<T> {
        return realm.objects(T.self).filter(predicate)
    }
    /// 后台根据条件查询数据
    func BGselectByNSPredicate<T: Object>(_: T.Type , predicate: NSPredicate) throws -> Results<T> {
        return try Realm().objects(T.self).filter(predicate)
    }
    /// 查询所有数据
    func selectByAll<T: Object>(_: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }

    /// 查询排序后所有数据,关键词及是否升序
    func selectScoretByAll<T: Object>(_: T.Type ,key: String, isAscending: Bool) -> Results<T> {
        return realm.objects(T.self).sorted(byKeyPath: key, ascending: isAscending)
    }

    //--- MARK: 删除 Realm
    /*
     参考官方文档，所有 fileURL 指向想要删除的 Realm 文件的 Realm 实例，都必须要在删除操作执行前被释放掉。
     故在操作 Realm实例的时候需要加上 autoleasepool 。如下:
     autoreleasepool {
     //所有 Realm 的使用操作
     }
     */
    /// Realm 文件删除操作
    static func deleteRealmFile() {
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("log_a"),
            realmURL.appendingPathExtension("log_b"),
            realmURL.appendingPathExtension("note")
        ]
        let manager = FileManager.default
        for URL in realmURLs {
            do {
                try manager.removeItem(at: URL)
            } catch {
                // 处理错误
            }
        }

    }

    private func _addListData<T: Object>(_ objects: [T]) {
         autoreleasepool { [weak self] in
            guard let self = self else { return }
            // 批量写入操作
            self.realm.beginWrite()
            // add 方法支持 update ，item 的对象必须有主键
            for item in objects {
                self.realm.add(item)
            }
            // 提交写入事务以确保数据在其他线程可用
            do {
                try self.realm.commitWrite()
            } catch {}
        }
    }

}
