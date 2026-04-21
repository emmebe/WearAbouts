//
//  Styles.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/8/26.
//

import SwiftUI

// MARK: - Brand Colors
extension Color {
    // Primary brand colors
    static let brandPrimary = Color(red: 0.5, green: 0.69, blue: 1) // Periwinkle blue
    static let brandAccent = Color(red: 1, green: 0.64, blue: 0.47) // Coral
    static let brandDark = Color(red: 0.25, green: 0.35, blue: 0.55) // Deep blue
    
    // Functional colors
    static let appPrimary = Color.brandPrimary
    static let appAccent = Color.brandAccent
    static let appSecondary = Color.brandDark
    static let appBackground = Color(red: 0.98, green: 0.99, blue: 1)
    static let appCardBackground = Color.white
    static let appTextPrimary = Color(red: 0.15, green: 0.15, blue: 0.25)
    static let appTextSecondary = Color(red: 0.5, green: 0.5, blue: 0.6)
    static let appSuccess = Color(red: 0.3, green: 0.8, blue: 0.6)
    static let appWarning = Color.orange
    static let appDanger = Color.red
}

// MARK: - Typography
struct AppFont {
    static let largeTitle = Font.system(size: 32, weight: .bold, design: .rounded)
    static let title = Font.system(size: 24, weight: .bold, design: .rounded)
    static let title2 = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 16, weight: .regular, design: .default)
    static let caption = Font.system(size: 13, weight: .regular, design: .default)
}

// MARK: - Buttons
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFont.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.brandPrimary, Color.brandDark]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .shadow(
                color: Color.brandPrimary.opacity(0.4),
                radius: configuration.isPressed ? 4 : 12,
                x: 0,
                y: configuration.isPressed ? 2 : 6
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct AccentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFont.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 16)
            .background(Color.brandAccent)
            .cornerRadius(16)
            .shadow(
                color: Color.brandAccent.opacity(0.4),
                radius: configuration.isPressed ? 4 : 12,
                x: 0,
                y: configuration.isPressed ? 2 : 6
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFont.body)
            .fontWeight(.semibold)
            .foregroundColor(.brandDark)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.brandPrimary.opacity(0.15))
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - View Extensions
extension View {
    func primaryButton() -> some View {
        self.buttonStyle(PrimaryButtonStyle())
    }
    
    func accentButton() -> some View {
        self.buttonStyle(AccentButtonStyle())
    }
    
    func secondaryButton() -> some View {
        self.buttonStyle(SecondaryButtonStyle())
    }
    
    func brandCard() -> some View {
        self
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appCardBackground)
            .cornerRadius(20)
            .shadow(color: Color.brandPrimary.opacity(0.08), radius: 12, x: 0, y: 6)
    }
    
    func cardStyle() -> some View {
        brandCard()
    }
    
    func featuredCard() -> some View {
        self
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.brandPrimary.opacity(0.12),
                                    Color.brandAccent.opacity(0.08)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.brandPrimary.opacity(0.4),
                                    Color.brandAccent.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            )
    }
    
    func featuredCardStyle() -> some View {
        featuredCard()
    }
    
    func brandTextField() -> some View {
        self
            .font(AppFont.body)
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.brandPrimary.opacity(0.3), lineWidth: 1.5)
            )
            .shadow(color: Color.brandPrimary.opacity(0.05), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
    }
    
    func appTextField() -> some View {
        brandTextField()
    }
}

// MARK: - Spacing
struct Spacing {
    static let tiny: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xLarge: CGFloat = 32
    static let xxLarge: CGFloat = 48
}
