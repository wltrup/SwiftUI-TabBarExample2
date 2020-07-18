import SwiftUI

struct ContentView: View {

    @ObservedObject var tabBarViewModel = TabBarViewModel.mock

    var body: some View {
        VStack {
            ZStack {
                Rectangle().fill(Color.orange.opacity(0.4))
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Image(uiImage: tabBarViewModel.selectedItem.image!)
                        .font(.largeTitle)
                    Text(tabBarViewModel.selectedItem.title!)
                        .font(.title)
                    Spacer()
                    TabBarView(viewModel: tabBarViewModel)
                        .background(Color.white)
                }
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension TabBarViewModel {

    static let mock: TabBarViewModel = TabBarViewModel(items: [
        BarItem(
            title: "Timer",
            image: UIImage(systemName: "stopwatch"),
            tag: 0
        ),
        BarItem(
            title: "Stats",
            image: UIImage(systemName: "chart.bar"),
            tag: 1
        ),
        BarItem(
            title: "Learn",
            image: UIImage(systemName: "book"),
            tag: 2
        ),
        BarItem(
            title: "Share",
            image: UIImage(systemName: "square.and.arrow.up"),
            tag: 3
        ),
        BarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: 4
        ),
    ])

}
