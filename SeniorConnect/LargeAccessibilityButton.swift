//
//  LargeAccessibilityButton.swift
//  SeniorConnect
//
//  Created by Aadi Juthani on 9/1/25.
//

import SwiftUI

struct LargeAccessibilityButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 20)
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity)
                .cornerRadius(15)
                .background(Color.blue)
        }
        .shadow(color: .gray, radius: 3, x:0, y: 2)
    }
}

struct SecondaryAccessibilityButton: View{
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action){
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray5))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray3), lineWidth: 1)
                )
        }
        .shadow(color: .gray.opacity(0.3), radius: 2, x:0, y:1)
    }
}
