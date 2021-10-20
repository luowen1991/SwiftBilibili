//
//  NetworkReachabilityManager.swift
//  LWNetwork
//
//  Created by luowen on 2021/10/8.
//

import Alamofire
import RxSwift
import RxRelay

public enum NetworkReachabilityManager {

    public enum NetworkReachabilityStatus {
        case unknow
        case notReachable
        case ethernetOrWiFi
        case cellular
    }

    public static var status: NetworkReachabilityStatus {
        guard let status = Alamofire.NetworkReachabilityManager.default?.status else {
            return .notReachable
        }
        return transformStatus(status)
    }

    public static var connectionObserver: Observable<NetworkReachabilityStatus> {
        return connectionSubject.asObservable()
    }

    /// 是否有网
    public static var isReachable: Bool {
        Alamofire.NetworkReachabilityManager.default?.isReachable ?? false
    }

    /// 只有移动网络
    public static var isReachableOnCellular: Bool {
        status == .cellular
    }

    /// 只有WiFI网络
    public static var isReachableOnEthernetOrWiFi: Bool {
        status == .ethernetOrWiFi
    }

    public static func startListening(onQueue queue: DispatchQueue = .main,
                                      onUpdatePerforming listener: ((NetworkReachabilityStatus) -> Void)? = nil ) {
        Alamofire.NetworkReachabilityManager.default?.startListening(onQueue: queue, onUpdatePerforming: { (status) in
            let netStatus = transformStatus(status)
            listener?(netStatus)
            connectionSubject.onNext(netStatus)
        })
    }

    private static let connectionSubject = PublishSubject<NetworkReachabilityStatus>()

    private static func transformStatus(_ status: Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus) -> NetworkReachabilityStatus {

        switch status {
        case .notReachable:
            return .notReachable
        case .unknown:
            return .unknow
        case .reachable(let type):
            switch type {
            case .cellular:
                return .cellular
            case .ethernetOrWiFi:
                return .ethernetOrWiFi
            }
        }
    }
}
