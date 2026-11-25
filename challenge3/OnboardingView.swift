//
//  OnboardingView.swift
//  challenge3
//

import SwiftUI

struct OnboardingView: View {
    var onFinish: () -> Void = {}

    @State private var page = 0

    private let pageCount = 4

    private var isLastPage: Bool {
        page == pageCount - 1
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.96, blue: 1.0),
                    Color(red: 0.86, green: 0.89, blue: 0.99)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            decorativePaws

            VStack(spacing: 0) {
                header

                TabView(selection: $page) {
                    welcomePage
                        .tag(0)

                    lessonsPage
                        .tag(1)

                    cameraPage
                        .tag(2)

                    feedbackPage
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: page)

                footer
            }
        }
        .preferredColorScheme(.light)
    }

    // MARK: - Decoration

    private var decorativePaws: some View {
        GeometryReader { proxy in
            Image(systemName: "pawprint.fill")
                .font(.system(size: 90))
                .foregroundStyle(.white.opacity(0.3))
                .rotationEffect(.degrees(-25))
                .position(x: proxy.size.width - 20, y: 210)

            Image(systemName: "pawprint.fill")
                .font(.system(size: 130))
                .foregroundStyle(.white.opacity(0.25))
                .rotationEffect(.degrees(20))
                .position(x: 30, y: proxy.size.height - 110)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "pawprint.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.blue)

                Text("FlickerFox")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }

            Spacer()

            Button("Skip") {
                finish()
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
            .opacity(isLastPage ? 0 : 1)
            .disabled(isLastPage)
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }

    // MARK: - Pages

    private var welcomePage: some View {
        pageContent(
            title: "Welcome to FlickerFox",
            message: "Learn photography one paw at a time. Read short lessons, take real photos, and get instant feedback on every shot."
        ) {
            welcomeIllustration
        }
    }

    private var lessonsPage: some View {
        pageContent(
            title: "Every paw is a lesson",
            message: "Tap a paw to read its lesson, then tap it again to open the camera. Finish a lesson to unlock the next paw — and come back to any paw whenever you want a refresher."
        ) {
            lessonsIllustration
        } extra: {
            infoCard(
                icon: "hand.tap.fill",
                tint: .blue,
                text: "The blue lesson button beside a paw reopens that lesson at any time."
            )
        }
    }

    private var cameraPage: some View {
        pageContent(
            title: "Take your shot",
            message: "A tip for the lesson appears on screen. Line up your photo with the guides, then tap the shutter. If you don't like it, simply retake it before you finish."
        ) {
            cameraIllustration
        } extra: {
            infoCard(
                icon: "arrow.triangle.2.circlepath.camera",
                tint: .orange,
                text: "Use the buttons at the top of the camera to turn on the flash or flip between the front and back cameras."
            )
        }
    }

    private var feedbackPage: some View {
        pageContent(
            title: "Graded on 4 concepts",
            message: "Your photo earns a score out of 10, split across Composition, Lighting, Angles and Framing. Open each concept to see a score out of 2.5, its strengths, and tips to improve. Save a photo to find it, with its feedback, in the Gallery."
        ) {
            feedbackIllustration
        }
    }

    // MARK: - Page Layout

    private func pageContent<Illustration: View>(
        title: String,
        message: String,
        @ViewBuilder illustration: () -> Illustration
    ) -> some View {
        pageContent(
            title: title,
            message: message,
            illustration: illustration,
            extra: { EmptyView() }
        )
    }

    private func pageContent<Illustration: View, Extra: View>(
        title: String,
        message: String,
        @ViewBuilder illustration: () -> Illustration,
        @ViewBuilder extra: () -> Extra
    ) -> some View {
        let illustrationView = illustration()
        let extraView = extra()

        return GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 22) {
                    illustrationView
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)

                    VStack(spacing: 12) {
                        Text(title)
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.primary)

                        Text(message)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    extraView
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity)
                .frame(minHeight: proxy.size.height, alignment: .center)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }

    // MARK: - Footer

    private var footer: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                ForEach(0..<pageCount, id: \.self) { index in
                    Capsule()
                        .fill(index == page ? Color.blue : Color.blue.opacity(0.2))
                        .frame(width: index == page ? 22 : 8, height: 8)
                        .animation(
                            .spring(response: 0.3, dampingFraction: 0.8),
                            value: page
                        )
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Page \(page + 1) of \(pageCount)")

            HStack(spacing: 12) {
                if page > 0 {
                    Button {
                        withAnimation {
                            page -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(.blue)
                            .frame(width: 52, height: 52)
                            .background(.white.opacity(0.8), in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Previous page")
                }

                Button {
                    if isLastPage {
                        finish()
                    
                    } else {
                        withAnimation {
                            page += 1
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        
                            Text(isLastPage ? "Start learning" : "Next")
                                .font(.headline)
                            Image(
                                systemName: isLastPage
                                ? "sparkles"
                                : "arrow.right"
                            )}
                    
                        
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.blue.gradient, in: Capsule())
                    .shadow(
                        color: .blue.opacity(0.35),
                        radius: 12,
                        y: 6
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 16)
    }

    // MARK: - Illustrations

    private var welcomeIllustration: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.7))
                .frame(width: 210, height: 210)
                .shadow(color: .blue.opacity(0.2), radius: 30, y: 15)

            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .indigo],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 140, height: 140)
                .shadow(color: .blue.opacity(0.4), radius: 20, y: 10)

            Image(systemName: "pawprint.fill")
                .font(.system(size: 64, weight: .semibold))
                .foregroundStyle(.white)

            Image(systemName: "camera.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .padding(14)
                .background(Color.orange.gradient, in: Circle())
                .shadow(color: .orange.opacity(0.4), radius: 10, y: 5)
                .offset(x: 78, y: 68)
        }
        .frame(height: 236)
        .accessibilityHidden(true)
    }

    private var lessonsIllustration: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tap a paw to start")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                pawButton(color: .blue)

                lessonCapsule("Rule of Thirds")

                Spacer()
            }

            HStack(spacing: 12) {
                pawButton(color: .orange, isLocked: true)

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "lock.fill")
                    Text("Unlocks next")
                }
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
            }

            Divider()

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.blue)

                Text("The next paw unlocks when you finish the lesson before it.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(20)
        .frame(maxWidth: 340, alignment: .leading)
        .background(.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white, lineWidth: 1)
        }
        .shadow(color: .indigo.opacity(0.15), radius: 20, y: 10)
        .accessibilityHidden(true)
    }

    private var cameraIllustration: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [Color(white: 0.28), Color(white: 0.08)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            GeometryReader { proxy in
                Path { path in
                    let width = proxy.size.width
                    let height = proxy.size.height

                    for index in 1...2 {
                        let x = width * CGFloat(index) / 3
                        let y = height * CGFloat(index) / 3

                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))

                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                }
                .stroke(
                    .white.opacity(0.35),
                    style: StrokeStyle(lineWidth: 1, dash: [6, 6])
                )
            }

            VStack {
                HStack(spacing: 6) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundStyle(.yellow)

                    Text("Place your subject on a third line")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.black.opacity(0.45), in: Capsule())

                Spacer()

                ZStack {
                    Circle()
                        .stroke(.white, lineWidth: 4)
                        .frame(width: 58, height: 58)

                    Circle()
                        .fill(.white)
                        .frame(width: 46, height: 46)
                }
                .padding(.bottom, 18)
            }
            .padding(.top, 16)

            VStack {
                HStack {
                    Image(systemName: "bolt.slash.fill")
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                        .background(.white.opacity(0.18), in: Circle())

                    Spacer()

                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                        .background(.white.opacity(0.18), in: Circle())
                }
                .padding(14)

                Spacer()
            }
        }
        .frame(height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .stroke(.white.opacity(0.3), lineWidth: 1)
        }
        .shadow(color: .indigo.opacity(0.25), radius: 20, y: 10)
        .accessibilityHidden(true)
    }

    private var feedbackIllustration: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Overall grade")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("7.5 / 10")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(.blue)
                }

                Spacer()

                Text("7.5")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(width: 64, height: 64)
                    .background(.white, in: Circle())
                    .overlay {
                        Circle()
                            .stroke(.green, lineWidth: 3)
                    }
                    .shadow(radius: 4)
            }

            Divider()

            HStack(spacing: 10) {
                conceptChip("Composition", symbol: "square.grid.3x3", score: "2.0")
                conceptChip("Lighting", symbol: "sun.max", score: "2.5")
            }

            HStack(spacing: 10) {
                conceptChip("Angles", symbol: "angle", score: "1.5")
                conceptChip("Framing", symbol: "viewfinder", score: "1.5")
            }
        }
        .padding(20)
        .frame(maxWidth: 340)
        .background(.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white, lineWidth: 1)
        }
        .shadow(color: .indigo.opacity(0.15), radius: 20, y: 10)
        .accessibilityHidden(true)
    }

    // MARK: - Illustration Pieces

    private func pawButton(color: Color, isLocked: Bool = false) -> some View {
        Image(systemName: "pawprint.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 64, height: 64)
            .foregroundStyle(color.gradient)
            .shadow(color: color.opacity(0.4), radius: 8, y: 4)
            .overlay {
                if isLocked {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(.black.opacity(0.45), in: Circle())
                        .offset(x: 22, y: 22)
                }
            }
            .opacity(isLocked ? 0.35 : 1)
            .grayscale(isLocked ? 1 : 0)
    }

    private func lessonCapsule(_ title: String) -> some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.cyan)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.cyan.opacity(0.15), in: Capsule())
    }

    private func conceptChip(
        _ title: String,
        symbol: String,
        score: String
    ) -> some View {
        VStack(spacing: 4) {
            Image(systemName: symbol)
                .font(.system(size: 18, weight: .semibold))

            Text(title)
                .font(.caption2.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text("\(score)/2.5")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .foregroundStyle(.blue)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
    }

    private func infoCard(
        icon: String,
        tint: Color,
        text: String
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(tint)
                .frame(width: 40, height: 40)
                .background(tint.opacity(0.12), in: Circle())

            Text(text)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: 340)
        .background(.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 18))
    }

    // MARK: - Actions

    private func finish() {
        onFinish()
        
    }
}

#Preview {
    OnboardingView()
}
