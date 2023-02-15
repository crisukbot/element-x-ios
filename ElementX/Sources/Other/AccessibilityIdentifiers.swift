//
// Copyright 2023 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

struct A11yIdentifiers {
    static let bugReportScreen = BugReportScreen()
    static let changeServerScreen = ChangeServer()
    static let homeScreen = HomeScreen()
    static let loginScreen = LoginScreen()
    static let onboardingScreen = OnboardingScreen()
    static let roomScreen = RoomScreen()
    static let sessionVerificationScreen = SessionVerificationScreen()
    static let softLogoutScreen = SoftLogoutScreen()
        
    struct BugReportScreen {
        let report = "bug_report-report"
        let sendLogs = "bug_report-send_logs"
        let screenshot = "bug_report-screenshot"
        let removeScreenshot = "bug_report-remove_screenshot"
        let send = "bug_report-send"
        let attachScreenshot = "bug-report-attach_screenshot"
    }
    
    struct ChangeServer {
        let server = "change_server-server"
        let `continue` = "change_server-continue"
        let dismiss = "change_server-dismiss"
    }
    
    struct HomeScreen {
        let userAvatar = "home_screen-user_avatar"
        
        func roomName(_ name: String) -> String {
            "home_screen-room_name:\(name)"
        }
    }
    
    struct LoginScreen {
        let emailUsername = "login-email_username"
        let password = "login-password"
        let `continue` = "login-continue"
        let changeServer = "login-change_server"
        let oidc = "login-oidc"
        let unsupportedServer = "login-unsupported_server"
    }
    
    struct OnboardingScreen {
        let signIn = "onboarding-sign_in"
        let hidden = "onboarding-hidden"
    }
        
    struct RoomScreen {
        let name = "room_name"
        let avatar = "room_avatar"
    }
    
    struct SessionVerificationScreen {
        let requestVerification = "session_verification-request_verification"
        let startSasVerification = "session_verification-start_sas_verification"
        let acceptChallenge = "session_verification-accept_challenge"
        let declineChallenge = "session_verification-accept_challenge"
        let close = "session_verification-close"
    }
        
    struct SoftLogoutScreen {
        let title = "soft_logout-title"
        let message = "soft_logout-message"
        let password = "soft_logout-password"
        let forgotPassword = "soft_logout-forgot_password"
        let next = "soft_logout-next"
        let unsupportedServer = "soft_logout-unsupported_server"
        let clearDataTitle = "soft_logout-clear_data_title"
        let clearDataMessage = "soft_logout-clear_data_message"
        let clearData = "soft_logout-clear_data"
    }
}