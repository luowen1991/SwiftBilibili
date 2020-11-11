//
//  Error.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/5.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

public enum LWRealmError: Error {
  case realmQueueCantBeCreate
  case objectCantBeResolved
  case objectHaveNotPrimaryKey
  case objectWithPrimaryKeyNotFound
  case managedVersionOfObjectDoesntExist
}
