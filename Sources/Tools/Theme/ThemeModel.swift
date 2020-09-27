//
//  ThemeModel.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import ObjectMapper

struct ThemeMainStyleModel: ImmutableMappable {

    let colors : ThemeMainColorModel
    let id : Int
    let isDark : Bool
    let style : ThemeStyle
    let statusBarStyle : Int

    init(map: Map) throws {
        colors = try map.value("colors")
        id = try map.value("id")
        isDark = try map.value("isDark")
        style = try map.value("name")
        statusBarStyle = try map.value("statusBarStyle")
    }
}
// swiftlint:disable type_body_length
struct ThemeMainColorModel: ImmutableMappable {
    let ba0 : UIColor
    let ba0S : UIColor
    let ba0T : UIColor
    let bl0 : UIColor
    let bl1 : UIColor
    let bl10 : UIColor
    let bl2 : UIColor
    let bl3 : UIColor
    let bl4 : UIColor
    let bl5 : UIColor
    let bl6 : UIColor
    let bl7 : UIColor
    let bl8 : UIColor
    let bl9 : UIColor
    let br0 : UIColor
    let br1 : UIColor
    let br10 : UIColor
    let br2 : UIColor
    let br3 : UIColor
    let br4 : UIColor
    let br5 : UIColor
    let br6 : UIColor
    let br7 : UIColor
    let br8 : UIColor
    let br9 : UIColor
    let cy0 : UIColor
    let cy1 : UIColor
    let cy10 : UIColor
    let cy2 : UIColor
    let cy3 : UIColor
    let cy4 : UIColor
    let cy5 : UIColor
    let cy6 : UIColor
    let cy7 : UIColor
    let cy8 : UIColor
    let cy9 : UIColor
    let ga0 : UIColor
    let ga0S : UIColor
    let ga0T : UIColor
    let ga1 : UIColor
    let ga10 : UIColor
    let ga10T : UIColor
    let ga1E : UIColor
    let ga1S : UIColor
    let ga1T : UIColor
    let ga2 : UIColor
    let ga2T : UIColor
    let ga3 : UIColor
    let ga3T : UIColor
    let ga4 : UIColor
    let ga4T : UIColor
    let ga5 : UIColor
    let ga5T : UIColor
    let ga6 : UIColor
    let ga6T : UIColor
    let ga7 : UIColor
    let ga7T : UIColor
    let ga8 : UIColor
    let ga8T : UIColor
    let ga9 : UIColor
    let ga9T : UIColor
    let gr0 : UIColor
    let gr1 : UIColor
    let gr10 : UIColor
    let gr2 : UIColor
    let gr3 : UIColor
    let gr4 : UIColor
    let gr5 : UIColor
    let gr6 : UIColor
    let gr7 : UIColor
    let gr8 : UIColor
    let gr9 : UIColor
    let lb0 : UIColor
    let lb1 : UIColor
    let lb10 : UIColor
    let lb2 : UIColor
    let lb3 : UIColor
    let lb4 : UIColor
    let lb5 : UIColor
    let lb6 : UIColor
    let lb7 : UIColor
    let lb8 : UIColor
    let lb9 : UIColor
    let lg0 : UIColor
    let lg1 : UIColor
    let lg10 : UIColor
    let lg2 : UIColor
    let lg3 : UIColor
    let lg4 : UIColor
    let lg5 : UIColor
    let lg6 : UIColor
    let lg7 : UIColor
    let lg8 : UIColor
    let lg9 : UIColor
    let ly0 : UIColor
    let ly1 : UIColor
    let ly10 : UIColor
    let ly2 : UIColor
    let ly3 : UIColor
    let ly4 : UIColor
    let ly5 : UIColor
    let ly6 : UIColor
    let ly7 : UIColor
    let ly8 : UIColor
    let ly9 : UIColor
    let ma0 : UIColor
    let ma1 : UIColor
    let ma10 : UIColor
    let ma2 : UIColor
    let ma3 : UIColor
    let ma4 : UIColor
    let ma5 : UIColor
    let ma6 : UIColor
    let ma7 : UIColor
    let ma8 : UIColor
    let ma9 : UIColor
    let or0 : UIColor
    let or1 : UIColor
    let or10 : UIColor
    let or2 : UIColor
    let or3 : UIColor
    let or4 : UIColor
    let or5 : UIColor
    let or6 : UIColor
    let or7 : UIColor
    let or8 : UIColor
    let or9 : UIColor
    let pi0 : UIColor
    let pi1 : UIColor
    let pi10 : UIColor
    let pi2 : UIColor
    let pi3 : UIColor
    let pi4 : UIColor
    let pi5 : UIColor
    let pi5T : UIColor
    let pi6 : UIColor
    let pi7 : UIColor
    let pi8 : UIColor
    let pi9 : UIColor
    let pu0 : UIColor
    let pu1 : UIColor
    let pu10 : UIColor
    let pu2 : UIColor
    let pu3 : UIColor
    let pu4 : UIColor
    let pu5 : UIColor
    let pu6 : UIColor
    let pu7 : UIColor
    let pu8 : UIColor
    let pu9 : UIColor
    let re0 : UIColor
    let re1 : UIColor
    let re10 : UIColor
    let re2 : UIColor
    let re3 : UIColor
    let re4 : UIColor
    let re5 : UIColor
    let re6 : UIColor
    let re7 : UIColor
    let re8 : UIColor
    let re9 : UIColor
    let si0 : UIColor
    let si1 : UIColor
    let si10 : UIColor
    let si2 : UIColor
    let si3 : UIColor
    let si4 : UIColor
    let si5 : UIColor
    let si6 : UIColor
    let si7 : UIColor
    let si8 : UIColor
    let si9 : UIColor
    let wh0 : UIColor
    let wh0T : UIColor
    let ye0 : UIColor
    let ye1 : UIColor
    let ye10 : UIColor
    let ye2 : UIColor
    let ye3 : UIColor
    let ye4 : UIColor
    let ye5 : UIColor
    let ye6 : UIColor
    let ye7 : UIColor
    let ye8 : UIColor
    let ye9 : UIColor

    // swiftlint:disable function_body_length
    init(map: Map) throws {
        ba0 = try map.value("Ba0",using: HexColorTransform())
        ba0S = try map.value("Ba0_s",using: HexColorTransform())
        ba0T = try map.value("Ba0_t",using: HexColorTransform())
        bl0 = try map.value("Bl0",using: HexColorTransform())
        bl1 = try map.value("Bl1",using: HexColorTransform())
        bl10 = try map.value("Bl10",using: HexColorTransform())
        bl2 = try map.value("Bl2",using: HexColorTransform())
        bl3 = try map.value("Bl3",using: HexColorTransform())
        bl4 = try map.value("Bl4",using: HexColorTransform())
        bl5 = try map.value("Bl5",using: HexColorTransform())
        bl6 = try map.value("Bl6",using: HexColorTransform())
        bl7 = try map.value("Bl7",using: HexColorTransform())
        bl8 = try map.value("Bl8",using: HexColorTransform())
        bl9 = try map.value("Bl9",using: HexColorTransform())
        br0 = try map.value("Br0",using: HexColorTransform())
        br1 = try map.value("Br1",using: HexColorTransform())
        br10 = try map.value("Br10",using: HexColorTransform())
        br2 = try map.value("Br2",using: HexColorTransform())
        br3 = try map.value("Br3",using: HexColorTransform())
        br4 = try map.value("Br4",using: HexColorTransform())
        br5 = try map.value("Br5",using: HexColorTransform())
        br6 = try map.value("Br6",using: HexColorTransform())
        br7 = try map.value("Br7",using: HexColorTransform())
        br8 = try map.value("Br8",using: HexColorTransform())
        br9 = try map.value("Br9",using: HexColorTransform())
        cy0 = try map.value("Cy0",using: HexColorTransform())
        cy1 = try map.value("Cy1",using: HexColorTransform())
        cy10 = try map.value("Cy10",using: HexColorTransform())
        cy2 = try map.value("Cy2",using: HexColorTransform())
        cy3 = try map.value("Cy3",using: HexColorTransform())
        cy4 = try map.value("Cy4",using: HexColorTransform())
        cy5 = try map.value("Cy5",using: HexColorTransform())
        cy6 = try map.value("Cy6",using: HexColorTransform())
        cy7 = try map.value("Cy7",using: HexColorTransform())
        cy8 = try map.value("Cy8",using: HexColorTransform())
        cy9 = try map.value("Cy9",using: HexColorTransform())
        ga0 = try map.value("Ga0",using: HexColorTransform())
        ga0S = try map.value("Ga0_s",using: HexColorTransform())
        ga0T = try map.value("Ga0_t",using: HexColorTransform())
        ga1 = try map.value("Ga1",using: HexColorTransform())
        ga10 = try map.value("Ga10",using: HexColorTransform())
        ga10T = try map.value("Ga10_t",using: HexColorTransform())
        ga1E = try map.value("Ga1_e",using: HexColorTransform())
        ga1S = try map.value("Ga1_s",using: HexColorTransform())
        ga1T = try map.value("Ga1_t",using: HexColorTransform())
        ga2 = try map.value("Ga2",using: HexColorTransform())
        ga2T = try map.value("Ga2_t",using: HexColorTransform())
        ga3 = try map.value("Ga3",using: HexColorTransform())
        ga3T = try map.value("Ga3_t",using: HexColorTransform())
        ga4 = try map.value("Ga4",using: HexColorTransform())
        ga4T = try map.value("Ga4_t",using: HexColorTransform())
        ga5 = try map.value("Ga5",using: HexColorTransform())
        ga5T = try map.value("Ga5_t",using: HexColorTransform())
        ga6 = try map.value("Ga6",using: HexColorTransform())
        ga6T = try map.value("Ga6_t",using: HexColorTransform())
        ga7 = try map.value("Ga7",using: HexColorTransform())
        ga7T = try map.value("Ga7_t",using: HexColorTransform())
        ga8 = try map.value("Ga8",using: HexColorTransform())
        ga8T = try map.value("Ga8_t",using: HexColorTransform())
        ga9 = try map.value("Ga9",using: HexColorTransform())
        ga9T = try map.value("Ga9_t",using: HexColorTransform())
        gr0 = try map.value("Gr0",using: HexColorTransform())
        gr1 = try map.value("Gr1",using: HexColorTransform())
        gr10 = try map.value("Gr10",using: HexColorTransform())
        gr2 = try map.value("Gr2",using: HexColorTransform())
        gr3 = try map.value("Gr3",using: HexColorTransform())
        gr4 = try map.value("Gr4",using: HexColorTransform())
        gr5 = try map.value("Gr5",using: HexColorTransform())
        gr6 = try map.value("Gr6",using: HexColorTransform())
        gr7 = try map.value("Gr7",using: HexColorTransform())
        gr8 = try map.value("Gr8",using: HexColorTransform())
        gr9 = try map.value("Gr9",using: HexColorTransform())
        lb0 = try map.value("Lb0",using: HexColorTransform())
        lb1 = try map.value("Lb1",using: HexColorTransform())
        lb10 = try map.value("Lb10",using: HexColorTransform())
        lb2 = try map.value("Lb2",using: HexColorTransform())
        lb3 = try map.value("Lb3",using: HexColorTransform())
        lb4 = try map.value("Lb4",using: HexColorTransform())
        lb5 = try map.value("Lb5",using: HexColorTransform())
        lb6 = try map.value("Lb6",using: HexColorTransform())
        lb7 = try map.value("Lb7",using: HexColorTransform())
        lb8 = try map.value("Lb8",using: HexColorTransform())
        lb9 = try map.value("Lb9",using: HexColorTransform())
        lg0 = try map.value("Lg0",using: HexColorTransform())
        lg1 = try map.value("Lg1",using: HexColorTransform())
        lg10 = try map.value("Lg10",using: HexColorTransform())
        lg2 = try map.value("Lg2",using: HexColorTransform())
        lg3 = try map.value("Lg3",using: HexColorTransform())
        lg4 = try map.value("Lg4",using: HexColorTransform())
        lg5 = try map.value("Lg5",using: HexColorTransform())
        lg6 = try map.value("Lg6",using: HexColorTransform())
        lg7 = try map.value("Lg7",using: HexColorTransform())
        lg8 = try map.value("Lg8",using: HexColorTransform())
        lg9 = try map.value("Lg9",using: HexColorTransform())
        ly0 = try map.value("Ly0",using: HexColorTransform())
        ly1 = try map.value("Ly1",using: HexColorTransform())
        ly10 = try map.value("Ly10",using: HexColorTransform())
        ly2 = try map.value("Ly2",using: HexColorTransform())
        ly3 = try map.value("Ly3",using: HexColorTransform())
        ly4 = try map.value("Ly4",using: HexColorTransform())
        ly5 = try map.value("Ly5",using: HexColorTransform())
        ly6 = try map.value("Ly6",using: HexColorTransform())
        ly7 = try map.value("Ly7",using: HexColorTransform())
        ly8 = try map.value("Ly8",using: HexColorTransform())
        ly9 = try map.value("Ly9",using: HexColorTransform())
        ma0 = try map.value("Ma0",using: HexColorTransform())
        ma1 = try map.value("Ma1",using: HexColorTransform())
        ma10 = try map.value("Ma10",using: HexColorTransform())
        ma2 = try map.value("Ma2",using: HexColorTransform())
        ma3 = try map.value("Ma3",using: HexColorTransform())
        ma4 = try map.value("Ma4",using: HexColorTransform())
        ma5 = try map.value("Ma5",using: HexColorTransform())
        ma6 = try map.value("Ma6",using: HexColorTransform())
        ma7 = try map.value("Ma7",using: HexColorTransform())
        ma8 = try map.value("Ma8",using: HexColorTransform())
        ma9 = try map.value("Ma9",using: HexColorTransform())
        or0 = try map.value("Or0",using: HexColorTransform())
        or1 = try map.value("Or1",using: HexColorTransform())
        or10 = try map.value("Or10",using: HexColorTransform())
        or2 = try map.value("Or2",using: HexColorTransform())
        or3 = try map.value("Or3",using: HexColorTransform())
        or4 = try map.value("Or4",using: HexColorTransform())
        or5 = try map.value("Or5",using: HexColorTransform())
        or6 = try map.value("Or6",using: HexColorTransform())
        or7 = try map.value("Or7",using: HexColorTransform())
        or8 = try map.value("Or8",using: HexColorTransform())
        or9 = try map.value("Or9",using: HexColorTransform())
        pi0 = try map.value("Pi0",using: HexColorTransform())
        pi1 = try map.value("Pi1",using: HexColorTransform())
        pi10 = try map.value("Pi10",using: HexColorTransform())
        pi2 = try map.value("Pi2",using: HexColorTransform())
        pi3 = try map.value("Pi3",using: HexColorTransform())
        pi4 = try map.value("Pi4",using: HexColorTransform())
        pi5 = try map.value("Pi5",using: HexColorTransform())
        pi5T = try map.value("Pi5_t",using: HexColorTransform())
        pi6 = try map.value("Pi6",using: HexColorTransform())
        pi7 = try map.value("Pi7",using: HexColorTransform())
        pi8 = try map.value("Pi8",using: HexColorTransform())
        pi9 = try map.value("Pi9",using: HexColorTransform())
        pu0 = try map.value("Pu0",using: HexColorTransform())
        pu1 = try map.value("Pu1",using: HexColorTransform())
        pu10 = try map.value("Pu10",using: HexColorTransform())
        pu2 = try map.value("Pu2",using: HexColorTransform())
        pu3 = try map.value("Pu3",using: HexColorTransform())
        pu4 = try map.value("Pu4",using: HexColorTransform())
        pu5 = try map.value("Pu5",using: HexColorTransform())
        pu6 = try map.value("Pu6",using: HexColorTransform())
        pu7 = try map.value("Pu7",using: HexColorTransform())
        pu8 = try map.value("Pu8",using: HexColorTransform())
        pu9 = try map.value("Pu9",using: HexColorTransform())
        re0 = try map.value("Re0",using: HexColorTransform())
        re1 = try map.value("Re1",using: HexColorTransform())
        re10 = try map.value("Re10",using: HexColorTransform())
        re2 = try map.value("Re2",using: HexColorTransform())
        re3 = try map.value("Re3",using: HexColorTransform())
        re4 = try map.value("Re4",using: HexColorTransform())
        re5 = try map.value("Re5",using: HexColorTransform())
        re6 = try map.value("Re6",using: HexColorTransform())
        re7 = try map.value("Re7",using: HexColorTransform())
        re8 = try map.value("Re8",using: HexColorTransform())
        re9 = try map.value("Re9",using: HexColorTransform())
        si0 = try map.value("Si0",using: HexColorTransform())
        si1 = try map.value("Si1",using: HexColorTransform())
        si10 = try map.value("Si10",using: HexColorTransform())
        si2 = try map.value("Si2",using: HexColorTransform())
        si3 = try map.value("Si3",using: HexColorTransform())
        si4 = try map.value("Si4",using: HexColorTransform())
        si5 = try map.value("Si5",using: HexColorTransform())
        si6 = try map.value("Si6",using: HexColorTransform())
        si7 = try map.value("Si7",using: HexColorTransform())
        si8 = try map.value("Si8",using: HexColorTransform())
        si9 = try map.value("Si9",using: HexColorTransform())
        wh0 = try map.value("Wh0",using: HexColorTransform())
        wh0T = try map.value("Wh0_t",using: HexColorTransform())
        ye0 = try map.value("Ye0",using: HexColorTransform())
        ye1 = try map.value("Ye1",using: HexColorTransform())
        ye10 = try map.value("Ye10",using: HexColorTransform())
        ye2 = try map.value("Ye2",using: HexColorTransform())
        ye3 = try map.value("Ye3",using: HexColorTransform())
        ye4 = try map.value("Ye4",using: HexColorTransform())
        ye5 = try map.value("Ye5",using: HexColorTransform())
        ye6 = try map.value("Ye6",using: HexColorTransform())
        ye7 = try map.value("Ye7",using: HexColorTransform())
        ye8 = try map.value("Ye8",using: HexColorTransform())
        ye9 = try map.value("Ye9",using: HexColorTransform())
    }
}
