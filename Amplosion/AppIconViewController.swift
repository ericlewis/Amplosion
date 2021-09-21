//
//  AppIconViewController.swift
//  DogWalk
//
//  Created by Christian Selig on 2021-08-26.
//

import SwiftUI

struct AppIconStatus: Hashable {
    let appIcon: AppIcon
    let isCurrentAppIcon: Bool
}

extension AppIconStatus: Identifiable {
    var id: AppIcon {
        appIcon
    }
}

extension String: Identifiable {
    public var id: Self { self }
}

class AppIconViewController: UIHostingController<AppIconView> {
    convenience init() {
        self.init(rootView: AppIconView())
        title = "App Icon"
    }
}

struct AppIconView: View {
    @State
    private var appIconStatuses: [AppIconStatus] = createAppIconStatuses()

    @State
    private var errorMessage: String?

    var body: some View {
        List {
            Section {
                ForEach(appIconStatuses) { status in
                    makeCell(for: status)
                }
            } footer: {
                Text("Lightning ⚡️ icons done by Matthew Skiles, and doggy 🐶 icons done by Lux")
                    .font(.system(.caption2, design: .rounded))
            }
        }
        .alert(item: $errorMessage) { errorMessage in
            Alert(title: Text("Error Setting Icon :("), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func makeCell(for status: AppIconStatus) -> some View {
        Button {
            let alternateIconName: String? = status.appIcon == .default ? nil : status.appIcon.rawValue

            UIApplication.shared.setAlternateIconName(alternateIconName) { error in
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    withAnimation {
                        appIconStatuses = Self.createAppIconStatuses()
                    }
                }
            }
        } label: {
            HStack {
                Image(uiImage: status.appIcon.thumbnail)
                    .resizable()
                    .frame(width: 68, height: 68)
                    .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text(status.appIcon.title)
                        .font(.system(.callout, design: .rounded))
                        .foregroundColor(.primary)
                    Text(status.appIcon.subtitle)
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.secondary)
                }
                Spacer()
                if status.isCurrentAppIcon {
                    Image(systemName: "checkmark")
                        .font(.headline)
                }
            }
            .padding(.vertical, 10)
        }
        .accessibilityHint(Text("Changes home screen app icon."))
        .accessibilityLabel(Text(status.appIcon.accessibilityDescription))
    }

    private static func createAppIconStatuses() -> [AppIconStatus] {
        AppIcon.unlockedIcons.map { unlockedIcon in
            AppIconStatus(appIcon: unlockedIcon, isCurrentAppIcon: AppIcon.currentAppIcon == unlockedIcon)
        }
    }
}
