//
//  ImageCaptureView.swift
//  SeniorConnect
//
//  Created by Aadi Juthani on 9/5/25.
//

import SwiftUI
import PhotosUI

struct ImageCaptureView: View {
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
           VStack(spacing: 20) {
               Text("Get Help with Your Device")
                   .font(.largeTitle)
                   .fontWeight(.bold)
                   .multilineTextAlignment(.center)

               PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                   VStack {
                       Image(systemName: "camera.fill")
                           .font(.system(size: 40))
                           .foregroundColor(.white)

                       Text("Add Screenshot")
                           .font(.title2)
                           .fontWeight(.semibold)
                           .foregroundColor(.white)
                   }
                   .frame(width: 200, height: 120)
                   .background(Color.blue)
                   .cornerRadius(15)
               }

               if let selectedImage = selectedImage {
                   Image(uiImage: selectedImage)
                       .resizable()
                       .scaledToFit()
                       .frame(maxWidth: 200, maxHeight: 200)
                       .cornerRadius(10)
               }
           }
           .padding()
           .onChange(of: selectedPhotoItem) { oldValue, newItem in
               Task {
                   if let data = try? await newItem?.loadTransferable(type: Data.self),
                      let uiImage = UIImage(data: data) {
                       selectedImage = uiImage
                   }
               }
           }
       }
   }
