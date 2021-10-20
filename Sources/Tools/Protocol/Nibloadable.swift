//
//  Nibloadable.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/24.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

public protocol Nibloadable {
    static var nibIdentifier: String { get }
}

extension Nibloadable {
    static var nib: UINib {
        return UINib(nibName: nibIdentifier, bundle: nil)
    }
}

extension Nibloadable where Self: UIView {
    public static func loadFromNib(_ bundle: Bundle? = nil) -> Self {
        guard let view = UINib(nibName: nibIdentifier, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Couldn't find nib file for \(String(describing: Self.self))")
        }
        return view
    }
}

extension Nibloadable where Self: UIViewController {
    public static func loadFromNib(_ bundle: Bundle? = nil) -> Self {
        return Self(nibName: nibIdentifier, bundle: bundle)
    }
}

extension Nibloadable where Self: UITableView {
    public static func loadFromNib(_ bundle: Bundle? = nil) -> Self {
        guard let tableView = UINib(nibName: nibIdentifier, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Couldn't find nib file for \(String(describing: Self.self))")
        }
        return tableView
    }
}

extension Nibloadable where Self: UITableViewController {
    public static func loadFromNib(_ bundle: Bundle? = nil) -> Self {
        return Self(nibName: nibIdentifier, bundle: bundle)
    }
}

// MARK: 遵守协议
extension UIView: Nibloadable {
    public static var nibIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: Nibloadable {
    public static var nibIdentifier: String {
        return String(describing: self)
    }
}
