//
//  Styles.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/8/26.
//

import SwiftUI

// MARK: - Colors
extension Color {
    // Your custom colors
    static let appPrimary = Color(red: 0.5, green: 0.69, blue: 1) // Soft blue
    static let appAccent = Color(red: 1, green: 0.64, blue: 0.47) // Coral orange - THIS WAS MISSING
    
    // Supporting colors for good contrast
    static let appSecondary = Color(red: 0.3, green: 0.5, blue: 0.8) // Darker blue for text
    static let appBackground = Color(red: 0.97, green: 0.98, blue: 1) // Very light blue tint
    static let appCardBackground = Color.white
    static let appTextPrimary = Color(red: 0.2, green: 0.2, blue: 0.3) // Dark blue-gray
    static let appTextSecondary = Color(red: 0.5, green: 0.5, blue: 0.6) // Medium gray
    static let appSuccess = Color(red: 0.4, green: 0.8, blue: 0.6) // Mint green
}

// MARK: - Buttons
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.appPrimary, Color.appSecondary]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)
            .shadow(color: Color.appPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

struct AccentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color.appAccent)
            .cornerRadius(12)
            .shadow(color: Color.appAccent.opacity(0.3), radius: 6, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.appSecondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.appPrimary.opacity(0.15))
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
    
    func cardStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appCardBackground)
            .cornerRadius(16)
            .shadow(color: Color.appPrimary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    func featuredCardStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.appPrimary.opacity(0.1),
                        Color.appAccent.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.appPrimary.opacity(0.3), Color.appAccent.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
    
    func appTextField() -> some View {
        self
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appPrimary.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Color.appPrimary.opacity(0.05), radius: 4, x: 0, y: 2)
            .padding(.horizontal)
    }
}

// MARK: - Spacing
struct Spacing {
    static let tiny: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xLarge: CGFloat = 32
}

// MARK: - Corner Radius
struct CornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xLarge: CGFloat = 20
}
