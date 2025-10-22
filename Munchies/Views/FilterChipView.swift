//
//  FilterChipView.swift
//  Munchies
//
//  Created by Brad Woodard on 10/21/25.
//

import SwiftUI

struct FilterChipView: View {
    let filter: Filter
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            // Filter Icon
            AsyncImage(url: filter.imageURL) { phase in
                switch phase {
                case .empty:
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 48, height: 48)
                        .overlay {
                            ProgressView()
                        }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                case .failure:
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 48, height: 48)
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.system(size: 20))
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 48, height: 48)

            // Filter Name
            Text(filter.name)
                .font(.poppins(size: 14))
                .foregroundStyle(Color.black)
                .lineLimit(1)
                .padding(.trailing, 16)
        }
        .frame(height: 48)
        .background(
            ZStack {
                // NOTE: Applying shadow to a semi-transparent layer often doesn't draw
                // correctly in the UI. Figma shows the background should be #FFFFFF with
                // an opacity of 40%. My fix is to add an opaque background and apply the
                // shadow to that so we're not applying shadow to a semi-transparent layer.
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.background)
                    .shadow(color: .black.opacity(0.04),  radius: 10,  x: 0, y: 4)

                // Visual chip layer (can be translucent)
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(isSelected ? Color.selected : Color.white.opacity(0.4))
            }
        )
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    HStack {
        FilterChipView(filter: .mock, isSelected: false) {}
        FilterChipView(filter: .mock, isSelected: true) {}
    }
    .padding()
}
