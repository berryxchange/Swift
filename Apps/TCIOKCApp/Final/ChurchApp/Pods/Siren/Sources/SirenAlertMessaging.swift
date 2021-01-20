//
//  SirenAlertMessaging.swift
//  Siren
//
//  Created by Arthur Sabintsev on 12/6/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Siren Alert Messaging Customization

/// Allows the overriding of all the `UIAlertController` and `UIActionSheet` Strings to which Siren defaults.
///
/// - Warning: Overriding any of these keys will result in the loss of the built-in internationalization that Siren provides.
///
/// As SirenAlertMessaging is a Struct, one _or_ more keys can be modified. Overriding only one string will result in the other keys retaining their default (and internationalizable) values.
public struct SirenAlertMessaging {

    /// The default constants used for the alert messaging.
    public struct Constants {

        /// The button text that conveys the message that the user should be prompted to update next time the app launches.
        public static let nextTime = "Next time"

        /// The text that conveys the message that the the user wants to skip this verison update.
        public static let skipVersion = "Skip this version"

        /// The text that conveys the message that there is an app update available
        public static let updateMessage = "A new version of %@ is available. Please update to version %@ now."

        /// The alert title which defaults to *Update Available*.
        public static let updateTitle = "Update Available"

        /// The button text that conveys the message that the user would like to update the app right away.
        public static let updateNow = "Update"
    }

    let nextTimeButtonMessage: String
    let skipVersionButtonMessage: String
    let updateButtonMessage: String
    let updateMessage: String
    let updateTitle: String

    /// The public initializer
    ///
    /// - Parameters:
    ///   - title: The title field of the `UIAlertController`.
    ///   - message: The `message` field of the `UIAlertController`.
    ///   - updateButtonMessage: The `title` field of the Update Button `UIAlertAction`.
    ///   - nextTimeButtonMessage: The `title` field of the Next Time Button `UIAlertAction`.
    ///   - skipVersionButtonMessage: The `title` field of the Skip Button `UIAlertAction`.
    public init(updateTitle title: String = Constants.updateTitle,
                updateMessage message: String = Constants.updateMessage,
                updateButtonMessage: String = Constants.updateNow,
                nextTimeButtonMessage: String = Constants.nextTime,
                skipVersionButtonMessage: String = Constants.skipVersion) {
        self.updateTitle = title
        self.nextTimeButtonMessage = nextTimeButtonMessage
        self.updateButtonMessage = updateButtonMessage
        self.updateMessage = message
        self.skipVersionButtonMessage = skipVersionButtonMessage
    }

}
