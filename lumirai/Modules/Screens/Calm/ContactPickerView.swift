//
//  ContactPickerView.swift
//  lumirai
//
//  Created by dana nur fiqi on 19/01/26.
//

import Foundation
import SwiftUI
import ContactsUI

struct ContactPickerView: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss
    var onSelectNumber: (String) -> Void  // Closure untuk kirim nomor ke SwiftUI

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        picker.displayedPropertyKeys = [CNContactPhoneNumbersKey] // Hanya nomor telepon
        return picker
    }

    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CNContactPickerDelegate {
        let parent: ContactPickerView
        init(_ parent: ContactPickerView) { self.parent = parent }

        // Dipanggil saat user memilih nomor telepon
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
            if let number = contactProperty.value as? CNPhoneNumber {
                parent.onSelectNumber(number.stringValue)
            }
            parent.dismiss.callAsFunction()
        }

        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            parent.dismiss.callAsFunction()
        }
    }
}
