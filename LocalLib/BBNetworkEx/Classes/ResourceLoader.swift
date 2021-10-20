//
//  ResourceLoader.swift
//  BBNetworkEx
//
//  Created by luowen on 2021/10/14.
//

final class ResourceLoader {

    private static let bundle = Bundle(path: Bundle(for: ResourceLoader.self).path(forResource: "BBNetworkEx", ofType: "bundle") ?? "")

    static func imageNamed(_ name: String) -> UIImage? {
        guard !name.isEmpty,
              let image = UIImage(named: name, in: bundle, compatibleWith: nil)
        else { return nil }
        return image
    }
}
