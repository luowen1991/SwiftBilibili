//
//  Image.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

struct Image {

    struct TabBar {
        static let homeNormal = UIImage(named: "bottom_tabbar_mainhome_normal_22x22_")
        static let homeSelected = UIImage(named: "bottom_tabbar_mainhome_selected_22x22_")
        static let channelNormal = UIImage(named: "bottom_tabbar_pegasuschannel_normal_22x22_")
        static let channelSelected = UIImage(named: "bottom_tabbar_pegasuschannel_selected_22x22_")
        static let dynamicNormal = UIImage(named: "bottom_tabbar_followinghome_normal_22x22_")
        static let dynamicSelected = UIImage(named: "bottom_tabbar_followinghome_selected_22x22_")
        static let memberNormal = UIImage(named: "bottom_tabbar_mallhome_normal_22x22_")
        static let memberSelected = UIImage(named: "bottom_tabbar_mallhome_selected_22x22_")
        static let mineNormal = UIImage(named: "bottom_tabbar_user_center_normal_22x22_")
        static let mineSelected = UIImage(named: "bottom_tabbar_user_center_selected_22x22_")
    }

    struct Launch {
        static let pinkLogo = UIImage(named: "launcher_logo_2020")
        static let shadowLogo = UIImage(named: "player_shadow_logo_40x17_")
        static let content = UIImage(named: "launcher_image_2020_0709")
    }

    struct NetError {
        static let `default` = UIImage(named: "bblivebc_battle_pk_panel_load_error_184x140_")
    }

    struct Common {
        static let whiteBack = UIImage(named: "column_back_white_8x14_")
        static let whiteArrow = UIImage(named: "arrow_right_white_24x24_")
    }
}
