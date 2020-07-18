import Foundation

final class TabBarViewModel: ObservableObject {

    @Published private(set) var items: [BarItem]
    @Published private(set) var indexOfSelectedItem: Int
    @Published private(set) var indexOfLastSelectedItem: Int?

    init(items: [BarItem] = [], indexOfSelectedItem: Int = 0) {
        self.items = items
        self.indexOfLastSelectedItem = nil
        self.indexOfSelectedItem = indexOfSelectedItem
    }

    func select(_ item: BarItem) {
        indexOfLastSelectedItem = indexOfSelectedItem
        indexOfSelectedItem = item.tag
    }

    var selectedItem: BarItem {
        items[indexOfSelectedItem]
    }

}
