//
//  Constants.swift
//  SmackAlpha
//
//  Created by Ghita on 10/6/17.
//  Copyright © 2017 Ghita. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ success: Bool) -> ()

//URL constants
let BASE_URL = "https://slackappclone.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)/channel"
let URL_GET_MESSAGES = "\(BASE_URL)message/byChannel/"


//Headers
let HEADER = [
    "Content-type": "application/json; charset=utf-8"
]
let BEARER_HEADER = [
    "Authorization": "Bearer \(AuthService.instance.authKey)",
    "Content-type": "application/json; charset=utf-8"
]


// Segues

let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let TO_AVATAR_PICKER = "toAvatarPicker"

//User Defaults

let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// Notification constants

let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("notifChannelsLoaded")
let NOTIF_CHANNEL_SELECTED = Notification.Name("notifChannelSelected")





