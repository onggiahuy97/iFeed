import UIKit

var service = Service.shared

let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json")!

let defaultValue: AppGroup = .init(feed: .init(title: "Unknown", results: []))

service.fetchGeneric(url: url, defaultValue: defaultValue) { appGroup in
    print(appGroup.feed.title)
}
