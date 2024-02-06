//
//  OTPTextField.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//

import SwiftUI
import Combine

struct OTPTextField: View {
    
    let otpLength: Int = 6
    @State var otpText: String = ""
    
    //keyboard state
    @FocusState private var isKeyboardShowing: Bool
    
    
    var body: some View {
        
        VStack {
            HStack(spacing: 0) {
                // otp text box
                ForEach(0..<otpLength, id: \.self) { index in
                    otpTextBox(index)
                }
            }
            .background(content: {
                TextField("", text: $otpText.limit(otpLength))
                //heidng the text feild
                    .frame(width: 1, height: 1)
                    .opacity(0.0001)
                    .blendMode(.screen)
                    .focused($isKeyboardShowing)
                    .keyboardType(.numberPad)
                //to show most recent OTP from message
                    .textContentType(.oneTimeCode)
            })
            .containerShape(Rectangle())
            .onTapGesture {
                //open keyboard
                isKeyboardShowing = true
            }
            .padding()
            
            
            
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done"){
                    isKeyboardShowing = false
                }
            }
        }
    }
    
    @ViewBuilder
    func otpTextBox(_ index: Int) -> some View {
        ZStack {
            if otpText.count > index {
                //finding char for current index
                let firstIndex = otpText.startIndex
                let currentIndex = otpText.index(firstIndex, offsetBy: index)
                
                Text(String(otpText[currentIndex]))
            } else {
                Text("")
            }
        }
        .frame(width: 45, height: 45)
        .background {
            //highlight current box
            let status = (isKeyboardShowing && otpText.count == index)
            RoundedRectangle(cornerRadius: 6, style:  .continuous)
                .stroke(.gray, lineWidth: status ? 1 : 0.4)
                .animation(.easeInOut(duration: 0.2), value: status)
        }
        .frame(maxWidth: .infinity)
    }
}

struct OTPTextField_Previews: PreviewProvider {
    static var previews: some View {
        OTPTextField()
    }
}


extension View {
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
}

/*
 Since we only need 6 characters from the TextField as we have only 6 boxes, creating an extension for limiting the binding string to some prescribed limit
 */
// Binding <String> extension
extension Binding where Value == String {
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}
