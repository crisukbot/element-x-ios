//
// Copyright 2022 New Vector Ltd
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

import Combine
import Foundation
import UIKit

enum HomeScreenViewModelAction {
    case presentRoom(roomIdentifier: String)
    case presentRoomDetails(roomIdentifier: String)
    case roomLeft(roomIdentifier: String)
    case presentSessionVerificationScreen
    case presentSecureBackupSettings
    case presentSettingsScreen
    case presentFeedbackScreen
    case presentStartChatScreen
    case presentInvitesScreen
    case presentGlobalSearch
    case logout
}

enum HomeScreenViewUserMenuAction {
    case settings
    case logout
}

enum HomeScreenViewAction {
    case selectRoom(roomIdentifier: String)
    case showRoomDetails(roomIdentifier: String)
    case leaveRoom(roomIdentifier: String)
    case confirmLeaveRoom(roomIdentifier: String)
    case userMenu(action: HomeScreenViewUserMenuAction)
    case startChat
    case verifySession
    case confirmRecoveryKey
    case skipSessionVerification
    case skipRecoveryKeyConfirmation
    case updateVisibleItemRange(range: Range<Int>, isScrolling: Bool)
    case selectInvites
    case globalSearch
    case markRoomAsUnread(roomIdentifier: String)
    case markRoomAsRead(roomIdentifier: String)
}

enum HomeScreenRoomListMode: CustomStringConvertible {
    case migration
    case skeletons
    case empty
    case rooms
    
    var description: String {
        switch self {
        case .migration:
            return "Showing account migration"
        case .skeletons:
            return "Showing placeholders"
        case .empty:
            return "Showing empty state"
        case .rooms:
            return "Showing rooms"
        }
    }
}

enum SecurityBannerMode {
    case none
    case dismissed
    case sessionVerification
    case recoveryKeyConfirmation
}

struct HomeScreenViewState: BindableState {
    let userID: String
    var userDisplayName: String?
    var userAvatarURL: URL?
    
    var securityBannerMode = SecurityBannerMode.none
    var requiresExtraAccountSetup = false
        
    var rooms: [HomeScreenRoom] = []
    var roomListMode: HomeScreenRoomListMode = .skeletons
    
    var shouldShowFilters = false
    var markAsUnreadEnabled = false
    
    var hasPendingInvitations = false
    var hasUnreadPendingInvitations = false
    
    var selectedRoomID: String?
    
    var visibleRooms: [HomeScreenRoom] {
        if roomListMode == .skeletons {
            return placeholderRooms
        }
        
        return rooms
    }
    
    var bindings = HomeScreenViewStateBindings()
    
    var placeholderRooms: [HomeScreenRoom] {
        (1...10).map { _ in
            HomeScreenRoom.placeholder()
        }
    }
    
    // Used to hide all the rooms when the search field is focused and the query is empty
    var shouldHideRoomList: Bool {
        bindings.isSearchFieldFocused && bindings.searchQuery.isEmpty
    }
}

struct HomeScreenViewStateBindings {
    var filtersState = RoomListFiltersState()
    var searchQuery = ""
    var isSearchFieldFocused = false
    
    var alertInfo: AlertInfo<UUID>?
    var leaveRoomAlertItem: LeaveRoomAlertItem?
}

struct HomeScreenRoom: Identifiable, Equatable {
    static let placeholderLastMessage = AttributedString("Hidden last message")
        
    /// The list item identifier can be a real room identifier, a custom one for invalidated entries
    /// or a completely unique one for empty items and skeletons
    let id: String
    
    /// The real room identifier this item points to
    let roomId: String?
    
    var name = ""
    
    var badges: Badges
    struct Badges: Equatable {
        let isDotShown: Bool
        let isMentionShown: Bool
        let isMuteShown: Bool
        let isCallShown: Bool
    }
    
    let isHighlighted: Bool
    
    var timestamp: String?
    
    var lastMessage: AttributedString?
    
    var avatarURL: URL?
    
    var isPlaceholder = false
    
    static func placeholder() -> HomeScreenRoom {
        HomeScreenRoom(id: UUID().uuidString,
                       roomId: nil,
                       name: "Placeholder room name",
                       badges: .init(isDotShown: false, isMentionShown: false, isMuteShown: false, isCallShown: false),
                       isHighlighted: false,
                       timestamp: "Now",
                       lastMessage: placeholderLastMessage,
                       isPlaceholder: true)
    }
}

extension HomeScreenRoom {
    init(details: RoomSummaryDetails, invalidated: Bool, hideUnreadMessagesBadge: Bool) {
        let identifier = invalidated ? "invalidated-" + details.id : details.id
        
        let hasUnreadMessages = hideUnreadMessagesBadge ? false : details.hasUnreadMessages
        
        let isDotShown = hasUnreadMessages || details.hasUnreadMentions || details.hasUnreadNotifications || details.isMarkedUnread
        let isMentionShown = details.hasUnreadMentions && !details.isMuted
        let isMuteShown = details.isMuted
        let isCallShown = details.hasOngoingCall
        let isHighlighted = details.isMarkedUnread || (!details.isMuted && (details.hasUnreadNotifications || details.hasUnreadMentions))
        
        self.init(id: identifier,
                  roomId: details.id,
                  name: details.name,
                  badges: .init(isDotShown: isDotShown,
                                isMentionShown: isMentionShown,
                                isMuteShown: isMuteShown,
                                isCallShown: isCallShown),
                  isHighlighted: isHighlighted,
                  timestamp: details.lastMessageFormattedTimestamp,
                  lastMessage: details.lastMessage,
                  avatarURL: details.avatarURL)
    }
}
