//
//  ConfettiView.swift
//  challenge3
//
//

import SwiftUI

struct ConfettiView: View {

    var particleCount: Int = 180
    var animationDuration: Double = 8.5

    @State private var particles: [ConfettiParticle] = []
    @State private var startDate = Date()
    @State private var isAnimating = false
    @State private var stopTask: Task<Void, Never>?

    var body: some View {
        TimelineView(
            .animation(minimumInterval: 1.0 / 60.0, paused: !isAnimating)
        ) { timeline in
            Canvas { context, size in
                let elapsed = max(0, timeline.date.timeIntervalSince(startDate))

                for particle in particles {
                    let age = elapsed - particle.delay
                    guard age >= 0, age <= particle.lifetime else { continue }

                    let position = particle.position(at: age, in: size)
                    guard position.x > -80,
                          position.x < size.width + 80,
                          position.y > -120,
                          position.y < size.height + 80 else { continue }

                    let fadeStart = particle.lifetime * 0.8
                    let opacity: Double

                    if age > fadeStart {
                        opacity = max(
                            0,
                            1 - (age - fadeStart) / (particle.lifetime - fadeStart)
                        )
                    } else {
                        opacity = 1
                    }

                    let spinPhase = particle.initialRotation + particle.spin * age
                    let flip = max(0.15, abs(cos(spinPhase)))
                    let width = particle.size.width * flip

                    var layer = context
                    layer.opacity = opacity
                    layer.translateBy(x: position.x, y: position.y)
                    layer.rotate(by: .radians(spinPhase))

                    let rect = CGRect(
                        x: -width / 2,
                        y: -particle.size.height / 2,
                        width: width,
                        height: particle.size.height
                    )

                    let path: Path = particle.isCircle
                        ? Path(ellipseIn: rect)
                        : Path(roundedRect: rect, cornerRadius: width * 0.25)

                    layer.fill(path, with: .color(particle.color))
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear(perform: start)
        .onDisappear {
            stopTask?.cancel()
            stopTask = nil
            isAnimating = false
        }
    }

    private func start() {
        stopTask?.cancel()

        particles = Self.makeParticles(count: particleCount)
        startDate = .now
        isAnimating = true

        stopTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(animationDuration))
            guard !Task.isCancelled else { return }
            isAnimating = false
        }
    }

    private static func makeParticles(count: Int) -> [ConfettiParticle] {
        let palette: [Color] = [
            .red, .orange, .yellow, .green, .mint,
            .blue, .indigo, .purple, .pink
        ]

        return (0..<count).map { _ in
            let color = palette.randomElement() ?? .blue
            let size = CGSize(
                width: .random(in: 7...14),
                height: .random(in: 4...8)
            )
            let isCircle = Double.random(in: 0...1) < 0.3
            let isCannon = Double.random(in: 0...1) < 0.78

            let startX: CGFloat
            let startY: CGFloat
            let velocityX: CGFloat
            let velocityY: CGFloat
            let gravity: CGFloat
            let delay: Double
            let lifetime: Double

            if isCannon {
                let fromLeft = Bool.random()
                let spread = Double.random(in: 0.02...0.38)
                let speed = CGFloat.random(in: 950...1500)
                let direction: CGFloat = fromLeft ? 1 : -1

                startX = fromLeft ? 0.02 : 0.98
                startY = 1.03
                velocityX = direction * speed * CGFloat(sin(spread))
                    + CGFloat.random(in: -60...60)
                velocityY = -speed * CGFloat(cos(spread))
                gravity = 1250
                delay = Double.random(in: 0...0.45)
                lifetime = Double.random(in: 5.5...7.2)
            } else {
                startX = .random(in: -0.05...1.05)
                startY = .random(in: -0.18...(-0.03))
                velocityX = .random(in: -60...60)
                velocityY = .random(in: 60...220)
                gravity = 320
                delay = Double.random(in: 0...1.4)
                lifetime = Double.random(in: 5.0...7.0)
            }

            return ConfettiParticle(
                startX: startX,
                startY: startY,
                velocityX: velocityX,
                velocityY: velocityY,
                gravity: gravity,
                size: size,
                color: color,
                isCircle: isCircle,
                initialRotation: Double.random(in: 0...(2 * .pi)),
                spin: Double.random(in: -9...9),
                delay: delay,
                lifetime: lifetime
            )
        }
    }
}

private struct ConfettiParticle {

    let startX: CGFloat
    let startY: CGFloat
    let velocityX: CGFloat
    let velocityY: CGFloat
    let gravity: CGFloat
    let size: CGSize
    let color: Color
    let isCircle: Bool
    let initialRotation: Double
    let spin: Double
    let delay: Double
    let lifetime: Double

    func position(at age: Double, in canvasSize: CGSize) -> CGPoint {
        let t = CGFloat(age)

        return CGPoint(
            x: startX * canvasSize.width + velocityX * t,
            y: startY * canvasSize.height
                + velocityY * t
                + 0.5 * gravity * t * t
        )
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.85)
            .ignoresSafeArea()

        ConfettiView()
    }
}
