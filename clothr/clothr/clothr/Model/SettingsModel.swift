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
    let tut: String? = "Swipe Right = Like \nSwipe Left = Dislike"
    let description: String? = " At Clothr, we (five college students) aim for fast and efficient shopping for people on the go. With inspiration from Tinder, we wanted to create a dating app for clothes. You can swipe through dozens of clothing options to find their perfect outfit in minutes. We took our love for clothes and created a fun, aesthetically pleasing app to find any type of clothing you can desire. Clothr even includes filter options to narrow down the selections, so that you can find exactly what you are looking for." + "\n \n Contact Info: \n Sunpreet Singh    singsam123@gmail.com \n Andrew Guterres  \n Gilbert Aragon     gcaragon@ucsc.ed \n Gabe Cabral         czar.cabral@gmail.com \n Kianna Mark         kiannamark@yahoo.com"
}
