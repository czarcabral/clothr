//
//  SettingsModel.swift
//  clothr
//
//  Created by Gilbert Aragon on 11/26/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit
import Parse

class Settings {
    var userName = PFUser.current()?.username
    var userEmail = PFUser.current()?.email
    let tut: String? = ""
    let description: String? = "Cheeseburgers make your knees weak and your soul tingle. A great cheeseburger is a gastronomical event with so many varieties you couldn’t get tired of it if you tried. There’s cheesy incarnation waiting for you no matter what your palate preferences are. Unless you’re vegan, in which case we’re sorry for your loss."
}
