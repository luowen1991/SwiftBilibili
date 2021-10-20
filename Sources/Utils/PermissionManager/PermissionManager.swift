//
//  PermissionManager.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/24.
//  Copyright © 2020 luowen. All rights reserved.
//

import Photos
import AVFoundation
import UserNotifications

public struct PermissionManager {
    /// 获取相册权限
    static public func authorizePhotoWith(comletion: @escaping (Bool) -> Void ) {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case PHAuthorizationStatus.authorized:
            comletion(true)
        case PHAuthorizationStatus.denied,PHAuthorizationStatus.restricted:
            comletion(false)
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    comletion(status == PHAuthorizationStatus.authorized ? true:false)
                }
            })
        default:
            comletion(false)
        }
    }
    /// 获取相机权限
    static public func authorizeCameraWith(comletion: @escaping (Bool) -> Void) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch granted {
        case .authorized:
            comletion(true)
        case .denied:
            comletion(false)
        case .restricted:
            comletion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    comletion(granted)
                }
            })
        default:
            comletion(false)
        }
    }
    /// 获取推送权限
    static public func authorizeNotificationWith(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (setting) in
            let granted = setting.authorizationStatus == .authorized
            completion(granted)
        }
    }
}
