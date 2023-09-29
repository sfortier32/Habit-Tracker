//
//  Confetti.swift
//  Habit Tracker
//
//  Created by Sophia Fortier on 9/28/23.
//

import SwiftUI
import CoreHaptics
import UIKit

struct ConfettiView: UIViewRepresentable {
  @Binding var isVisible: Bool

  func makeUIView(context: Context) -> UIConfettiView {
    let confettiView = UIConfettiView()
    confettiView.setUp(isOn: isVisible)
    return confettiView
  }

  func updateUIView(_ uiView: UIConfettiView, context: Context) {
    if isVisible {
      uiView.start()
    }
    else {
      uiView.stop()
    }
  }
}

enum ConfettiShape {
  case rectangle
  case circle
  case square
  case triangle
  case star
  
  var size: CGFloat {
    switch self {
    case .rectangle: return 4
    case .circle: return 4
    case .square: return 4
    case .triangle: return 6
    case .star: return 6
    }
  }
  
  func image(color: UIColor) -> UIImage {
    switch self {
      
    case .rectangle:
      let rect = CGRect(origin: .zero, size: CGSize(width: size, height: size * 1.6))
      let path = CGPath(rect: rect, transform: nil)
      return UIGraphicsImageRenderer(size: rect.size).image { context in
        context.cgContext.setFillColor(color.cgColor)
        context.cgContext.addPath(path)
        context.cgContext.fillPath()
      }
      
    case .circle:
      let rect = CGRect(origin: .zero, size: CGSize(width: size, height: size))
      return UIGraphicsImageRenderer(size: rect.size).image { context in
        context.cgContext.setFillColor(color.cgColor)
        context.cgContext.addEllipse(in: rect)
        context.cgContext.drawPath(using: .fill)
      }
      
    case .square:
      let rect = CGRect(origin: .zero, size: CGSize(width: size, height: size))
      let path = CGPath(rect: rect, transform: nil)
      return UIGraphicsImageRenderer(size: rect.size).image { context in
        context.cgContext.setFillColor(color.cgColor)
        context.cgContext.addPath(path)
        context.cgContext.fillPath()
      }
      
    case .triangle:
      let rect = CGRect(origin: .zero, size: CGSize(width: size, height: size))
      let path = CGPath.triangle(withSize: size)
      return UIGraphicsImageRenderer(size: rect.size).image { context in
        context.cgContext.setFillColor(color.cgColor)
        context.cgContext.addPath(path)
        context.cgContext.fillPath()
      }
      
    case .star:
      let rect = CGRect(origin: .zero, size: CGSize(width: size, height: size))
      let path = CGPath.star(withSize: size)
      return UIGraphicsImageRenderer(size: rect.size).image { context in
        context.cgContext.setFillColor(color.cgColor)
        context.cgContext.addPath(path)
        context.cgContext.fillPath()
      }
    }
  }
}

struct Confetti {
  let shape: ConfettiShape
  let color: UIColor
  let size: CGFloat = 6.0

  var image: UIImage {
    return shape.image(color: color)
  }
}

public final class UIConfettiView: UIView {

  func setUp(isOn: Bool) {
    let emitter = Emitter()
    emitter.configure()
    emitter.frame = self.bounds
    emitter.needsDisplayOnBoundsChange = true
    emitter.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: -50)
    emitter.emitterShape = .line
    self.layer.addSublayer(emitter)
  }

  func stop() {
    if let emitter = getEmitterFromSublayer() {
      emitter.scale = 0.0
    }
  }

  func start() {
    if let emitter = getEmitterFromSublayer() {
      emitter.scale = 1.0
    }
  }

  private func getEmitterFromSublayer() -> Emitter? {
    if let sublayer = self.layer.sublayers?.first,
       let emitter = sublayer as? Emitter {
      return emitter
    }
    return nil
  }
}

class Emitter: CAEmitterLayer {
  func configure() {
    emitterCells = [
      
      // Customise these however you want, with different shapes and colours.
      getCells(withConfetti: Confetti(shape: .circle, color: UIColor.systemYellow)),
      getCells(withConfetti: Confetti(shape: .rectangle, color: UIColor.systemRed)),
      getCells(withConfetti: Confetti(shape: .triangle, color: UIColor.systemGreen)),
      getCells(withConfetti: Confetti(shape: .circle, color: UIColor.systemTeal)),
      getCells(withConfetti: Confetti(shape: .star, color: UIColor.systemPink)),
      getCells(withConfetti: Confetti(shape: .square, color: UIColor.systemPurple))
    ]
  }

  func getCells(withConfetti confetti: Confetti) -> CAEmitterCell {
    let cell = CAEmitterCell()
    cell.birthRate = 50.0
    cell.lifetime = 10.0
    cell.velocity = 1000.0
    cell.velocityRange = 100.0
    cell.emissionLongitude = .pi
    cell.emissionRange = .pi / 2
    cell.spinRange = .pi * 8
    cell.scaleRange = 0.25
    cell.scale = 1.0 - cell.scaleRange
    cell.contents = confetti.image.cgImage
    cell.color = confetti.color.cgColor
    return cell
  }
}

struct ConfettiView_Previews: PreviewProvider {
  static var previews: some View {
    ConfettiView(isVisible: .constant(true))
  }
}

extension View {
  
  /// Add an `onPress` and `onRelease` action to a view.
  func pressAction(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
    modifier(PressActions(onPress: { onPress() }, onRelease: { onRelease() }))
  }
  
  func withConfetti(isVisible: Binding<Bool>) -> some View {
    ZStack {
      self
      ConfettiView(isVisible: isVisible)
      // Without this, you won't be able to interact with the underlying
      // view as the invisible ConfettiView will be covering it.
        .allowsHitTesting(false)
    }
  }
}
/// Add an `onPress` and `onRelease` action
/// to a view.
struct PressActions: ViewModifier {
  var onPress: () -> Void
  var onRelease: () -> Void

  func body(content: Content) -> some View {
    content.simultaneousGesture(
      DragGesture(minimumDistance: 0)
        .onChanged({ _ in
          onPress()
        })
        .onEnded({ _ in
          onRelease()
        })
    )
  }
}

struct Haptics {
  var engine: CHHapticEngine?

  init() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
      engine = nil
      return
    }

    do {
      engine = try CHHapticEngine()
      try engine?.start()
    } catch {
      print("There was an error creating the engine: \(error.localizedDescription)")
      engine = nil
    }
  }

  func poppingSensation() {
    var events = [CHHapticEvent]()

    events.append(
      CHHapticEvent(
        eventType: .hapticTransient,
        parameters: [
          CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3),
          CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        ],
        relativeTime: 0
      )
    )
    events.append(
      CHHapticEvent(
        eventType: .hapticTransient,
        parameters: [
          CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
          CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        ],
        relativeTime: 0.1
      )
    )

    play(events: events)
  }

  private func play(events: [CHHapticEvent]) {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

    // convert those events into a pattern and play it immediately
    do {
      let pattern = try CHHapticPattern(events: events, parameters: [])
      let player = try engine?.makePlayer(with: pattern)
      try player?.start(atTime: 0)
    } catch {
      print("Failed to play pattern: \(error.localizedDescription).")
    }
  }
}


extension CGPath {
  
  static func triangle(withSize size: CGFloat) -> CGPath {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: 0, y: size))
    path.addLine(to: CGPoint(x: size/2, y: 0))
    path.addLine(to: CGPoint(x: size, y: size))
    path.addLine(to: CGPoint(x: 0, y: size))
    return path
  }
  
  // From https://stackoverflow.com/q/57448505/1011161
  static func star(withSize size: CGFloat) -> CGPath {
    let path = UIBezierPath()
    let center = CGPoint(x: size / 2.0, y: size / 2.0)
    let xCenter: CGFloat = center.x
    let yCenter: CGFloat = center.y
    let w = size
    let r = w / 2.0
    let flip: CGFloat = -1.0 // use this to flip the figure 1.0 or -1.0
    let polySide = CGFloat(5)
    let theta = 2.0 * Double.pi * Double(2.0 / polySide)
    path.move(to: CGPoint(x: xCenter, y: r * flip + yCenter))
    for i in 1..<Int(polySide) {
      let x: CGFloat = r * CGFloat( sin(Double(i) * theta) )
      let y: CGFloat = r * CGFloat( cos(Double(i) * theta) )
      path.addLine(to: CGPoint(x: x + xCenter, y: y * flip + yCenter))
    }
    path.close()
    return path.cgPath
  }
}


struct CGPathExtensions_Previews: PreviewProvider {
  
  static var triangle: UIImage {
    let size: CGFloat = 60
    let rect = CGRect(origin: .zero, size: CGSize(width: size, height: size))
    let path = CGPath.triangle(withSize: size)
    return UIGraphicsImageRenderer(size: rect.size).image { context in
      context.cgContext.setFillColor(UIColor(.red).cgColor)
      context.cgContext.addPath(path)
      context.cgContext.fillPath()
    }
  }
  
  static var star: UIImage {
    let size: CGFloat = 60
    let rect = CGRect(origin: .zero, size: CGSize(width: size, height: size))
    let path = CGPath.star(withSize: size)
    return UIGraphicsImageRenderer(size: rect.size).image { context in
      context.cgContext.setFillColor(UIColor(.blue).cgColor)
      context.cgContext.addPath(path)
      context.cgContext.fillPath()
    }
  }
  
  static var previews: some View {
    Group {
      Image(uiImage: triangle)
        .previewDisplayName("Triangle")
      Image(uiImage: star)
        .previewDisplayName("Star")
    }
    .previewLayout(.sizeThatFits)
  }
}
