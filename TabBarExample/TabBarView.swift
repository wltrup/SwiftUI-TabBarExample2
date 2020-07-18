import SwiftUI

struct TabBarView: View {

    @ObservedObject private var viewModel: TabBarViewModel

    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack(alignment: .centerOfSelectedItem) {

            TabBarCircle(barHeight: barHeight)
                .animation(tabBarCircleAnimation)

            HStack(alignment: .lastTextBaseline) {
                Spacer()
                ForEach(viewModel.items) { item in
                    self.button(for: item)
                    Spacer()
                }
            }

        }
        .frame(height: barHeight)
    }

    private let barHeight: CGFloat = 60
    private let buttonHeight: CGFloat = 60
    private let buttonHorizPadding: CGFloat = 5
    private let centerAlignmentSpringDampingFraction: Double = 0.7

}

private extension TabBarView {

    var tabBarCircleAnimation: Animation {
        .spring(dampingFraction: centerAlignmentSpringDampingFraction)
    }

    func button(for item: BarItem) -> some View {

        let itemIsSelected = (item.tag == viewModel.indexOfSelectedItem)

        return Button(action: {
            if itemIsSelected.isFalse {
                self.viewModel.select(item)
            }
        }) {
            VStack {
                if item.image != nil {
                    Image(uiImage: item.image!)
                        .offset(x: 0, y: offsetY(for: item))
                        .scaleEffect(scaleEffect(for: item))
                        .animation(tabBarCircleAnimation)
                }
                if item.title != nil {
                    Text(item.title!)
                }
            }
        }
        .frame(height: buttonHeight)
        .centerAlignment(itemIsSelected: itemIsSelected)

    }

    func offsetY(for item: BarItem) -> CGFloat {
        let itemWasSelected = (item.tag == viewModel.indexOfLastSelectedItem)
        let itemIsSelected = (item.tag == viewModel.indexOfSelectedItem)
        let itemWasNotSelectedButIsNow = itemWasSelected.isFalse && itemIsSelected
        return itemWasNotSelectedButIsNow ? -0.5 * (barHeight/2) : 0
    }

    func scaleEffect(for item: BarItem) -> CGFloat {
        let itemWasSelected = (item.tag == viewModel.indexOfLastSelectedItem)
        let itemIsSelected = (item.tag == viewModel.indexOfSelectedItem)
        let itemWasNotSelectedButIsNow = itemWasSelected.isFalse && itemIsSelected
        return itemWasNotSelectedButIsNow ? 1.5 : 1
    }

}

private struct TabBarCircle: View {

    init(barHeight: CGFloat) {
        self.barHeight = barHeight
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: barHeight+10, height: barHeight+10)
            Circle()
                .fill(Color.orange.opacity(0.4))
                .frame(width: barHeight+10, height: barHeight+10)
            Circle()
                .fill(Color.white)
                .frame(width: barHeight-4, height: barHeight-4)
        }
        .offset(x: 0, y: -1.25 * (barHeight/2))
        .centerAlignment()
    }

    private var barHeight: CGFloat

}

// MARK: - Animated alignment support

extension HorizontalAlignment {
    private enum HA: AlignmentID {
        static func defaultValue(in viewDims: ViewDimensions) -> CGFloat {
            viewDims[HorizontalAlignment.center]
        }
    }
    fileprivate static let ha = HorizontalAlignment(HA.self)
}

extension Alignment {
    fileprivate static let centerOfSelectedItem = Alignment(horizontal: .ha, vertical: .center)
}

private struct AlignmentModifier: ViewModifier {

    private var itemIsSelected: Bool?

    init(itemIsSelected: Bool?) {
        self.itemIsSelected = itemIsSelected
    }

    func body(content: Content) -> some View {

        let horizA = (itemIsSelected ?? true)
            ? HorizontalAlignment.ha
            : HorizontalAlignment.center

        return content.alignmentGuide(horizA, computeValue: { viewDims in
            viewDims[HorizontalAlignment.center]
        })

    }
}

extension View {
    // nil indicates the "item" is the animated tab-bar shape
    fileprivate func centerAlignment(itemIsSelected: Bool? = nil) -> some View {
        self.modifier(AlignmentModifier(itemIsSelected: itemIsSelected))
    }
}
