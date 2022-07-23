//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Kevin Won on 7/9/22.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    let defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            palette
        }
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.overlay(
                    OptionalImage(uiImage: document.backgroundImage)
                        .scaleEffect(zoomScale)
                        .position(convertFromEmojiCoordinates((0,0), in: geometry))
                )
                .gesture(deselectAllEmojisGesture().simultaneously(with: doubleTapToZoom(in: geometry.size)))
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView().scaleEffect(2)
                } else {
                    ForEach(document.emojis) { emoji in
                        Text(emoji.text)
                            .gesture(selectionGesture(for: emoji).simultaneously(with: deletionGesture(for: emoji)))
                            .modifier(SelectionEffect(isSelected: selectedEmojisContains(this: emoji)))
                            .font(.system(size: fontSize(for: emoji)))
                            .scaleEffect(zoomScale)
                            .position(position(for: emoji, in: geometry))
                    }
                }
            }
            .clipped()
            .onDrop(of: [.plainText,.url,.image], isTargeted: nil) { providers, location in
                drop(providers: providers, at: location, in: geometry)
            }
            .gesture(panGesture().simultaneously(with: pinchGesture()))
        }
    }
    
    // MARK: - Drag and Drop
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            document.setBackground(.url(url.imageURL))
        }
        if !found {
            found = providers.loadObjects(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackground(.imageData(data))
                }
            }
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(
                        String(emoji),
                        at: convertToEmojiCoordinates(location, in: geometry),
                        size: defaultEmojiFontSize / zoomScale
                    )
                }
            }
        }
        return found
    }
    
    // MARK: - Positioning/Sizing Emoji
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        if selectedEmojisContains(this: emoji) {
            return convertFromEmojiCoordinates((emoji.x + Int(emojiPanOffSet.width), emoji.y + Int(emojiPanOffSet.height)), in: geometry)
        } else {
            return convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
        }
    }
        
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        if selectedEmojisContains(this: emoji) {
            return CGFloat(emoji.size) * finalEmojiZoomScale
        } else {
            return CGFloat(emoji.size)
        }
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (location.x - panOffset.width - center.x) / zoomScale,
            y: (location.y - panOffset.height - center.y) / zoomScale
        )
        return (Int(location.x), Int(location.y))
    }
    
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
            return CGPoint(
                x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
                y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
            )
    }
    
    // MARK: - Zooming
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0  {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    // MARK: - PINCHING
    
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1

    @GestureState private var gestureEmojiZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private var finalEmojiZoomScale: CGFloat {
        return 1 * gestureEmojiZoomScale
    }
    
    private func pinchGesture() -> some Gesture {
        if selectedEmojis.count == 0 {
            return MagnificationGesture()
                .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                    gestureZoomScale = latestGestureScale
                }
                .onEnded { gestureScaleAtEnd in
                    steadyStateZoomScale *= gestureScaleAtEnd
                }
        } else {
            return MagnificationGesture()
                    .updating($gestureEmojiZoomScale) { latestGestureScale, gestureEmojiZoomScale, _ in
                        gestureEmojiZoomScale = latestGestureScale
                    }
                    .onEnded { gestureScaleAtEnd in
                        print(gestureScaleAtEnd)
                        print(selectedEmojis)
                        for emoji in selectedEmojis {
                            document.scaleEmoji(emoji, by: gestureScaleAtEnd)
                        }
                    }
        }
    }
    
    // MARK: - Panning
    
    @State private var steadyStatePanOffset: CGSize = CGSize.zero
    @GestureState private var gesturePanOffset: CGSize = CGSize.zero
    
    @State private var steadyStateEmojiPanOffset: CGSize = CGSize.zero
    @GestureState private var gestureEmojiPanOffset: CGSize = CGSize.zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private var emojiPanOffSet: CGSize {
        (steadyStateEmojiPanOffset + gestureEmojiPanOffset)
    }
    
    private func panGesture() -> some Gesture {
        if selectedEmojis.count == 0 {
            return DragGesture()
                .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                    gesturePanOffset = latestDragGestureValue.translation / zoomScale
                }
                .onEnded { finalDragGestureValue in
                    steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
                }
        } else {
            return DragGesture()
                .updating($gestureEmojiPanOffset) { latestDragGestureValue, gestureEmojiPanOffset, _ in
                    gestureEmojiPanOffset = latestDragGestureValue.translation / zoomScale
                }
                .onEnded { finalDragGestureValue in
                    steadyStateEmojiPanOffset = (finalDragGestureValue.translation / zoomScale)
                    for emoji in selectedEmojis {
                        document.moveEmoji(emoji, by: emojiPanOffSet)
                    }
                    steadyStateEmojiPanOffset = CGSize.zero
                }
        }
    }
    
    // MARK: - DELETION
    
    private func deletionGesture(for emoji: EmojiArtModel.Emoji) -> some Gesture {
        LongPressGesture(minimumDuration: 3)
            .onEnded { _ in
                withAnimation {
                    document.deleteEmoji(emoji)
                }
            }
    }
                                     
    // MARK: - Selection
    
    @State private var selectedEmojis: Array<EmojiArtModel.Emoji> = []
    
    private func selectedEmojisContains(this emoji: EmojiArtModel.Emoji) -> Bool {
        for item in selectedEmojis {
            if item.id == emoji.id {
                return true
            }
        }
        return false
    }
    
    private func selectionGesture(for emoji: EmojiArtModel.Emoji) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    toggleEmojiSelection(for: emoji)
                }
            }
    }
    
    private func toggleEmojiSelection(for emoji: EmojiArtModel.Emoji) {
        if selectedEmojisContains(this: emoji) {
            for index in selectedEmojis.indices {
                if selectedEmojis[index].id == emoji.id {
                    selectedEmojis.remove(at: index)
                    break
                }
            }
        } else {
            selectedEmojis.append(emoji)
        }
    }
    
    // MARK: - DESELECTION
    
    private func deselectAllEmojisGesture() -> some Gesture {
        TapGesture(count: 1)
            .onEnded {
                withAnimation {
                    selectedEmojis = []
                }
            }
    }
    
    // MARK: - Palette
    
    var palette: some View {
        ScrollingEmojisView(emojis: testEmojis)
            .font(.system(size: defaultEmojiFontSize))
    }
    
    let testEmojis = "😀😷🦠💉👻👀🐶🌲🌎🌞🔥🍎⚽️🚗🚓🚲🛩🚁🚀🛸🏠⌚️🎁🗝🔐❤️⛔️❌❓✅⚠️🎶➕➖🏳️"
}

struct ScrollingEmojisView: View {
    let emojis: String

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}

