//
//  PasscodeField.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 27/12/23.
//
import SwiftUI
public struct PasscodeField: View {
    
    var maxDigits: Int = 6
    
    @Binding var pin: String
    @State var showPin = true
    @FocusState var showKeyboard : Bool
    //@State var isDisabled = false
    
    
//    var handler: (String, (Bool) -> Void) -> Void
    
    public var body: some View {
        VStack{
            ZStack {
                pinDots
                backgroundField
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done"){
                    showKeyboard.toggle()
                }
            }
        }
        
    }
    
    private var pinDots: some View {
        HStack {
            ForEach(0..<maxDigits, id: \.self) { index in
                ZStack {
                    if index >= self.pin.count {
                        Text("")
                    } else {
//                        Text(self.pin.digits[index].numberString)
                        Text("•")
                            .font(.system(size: 40))
                            .bold()
                    }
                }
                .frame(width: 45, height: 45, alignment: .center)
                .background {
                    //highlight current box
                    let status = (self.showKeyboard && self.pin.count == index)
                    RoundedRectangle(cornerRadius: 6, style:  .continuous)
                        .stroke(Color("colorPrimary"), lineWidth: status ? 1 : 0.4)
                        .animation(.easeInOut(duration: 0.2), value: status)
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
        }
        .padding(.horizontal,20)
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
//            self.submitPin()
        })
        
//        return TextField("", text: boundPin, onCommit: submitPin).focused(self.$showKeyboard)
        return SecureField("", text: boundPin)
            .focused(self.$showKeyboard)
            
        
        // Introspect library can used to make the textField become first resonder on appearing
        // if you decide to add the pod 'Introspect' and import it, comment #50 to #53 and uncomment #55 to #61
        
            .accentColor(.clear)
            .foregroundColor(.clear)
            .keyboardType(.numberPad)
        //.disabled(isDisabled)
        
        //             .introspectTextField { textField in
        //                 textField.tintColor = .clear
        //                 textField.textColor = .clear
        //                 textField.keyboardType = .numberPad
        //                 textField.becomeFirstResponder()
        //                 textField.isEnabled = !self.isDisabled
        //         }
    }
    
    
//    private func submitPin() {
//        //guard !pin.isEmpty else {
//        //showPin = false
//        //return
//        //}
//        print("ini dari passcode \(pin)")
//        handler(pin) { isSuccess in
//            if isSuccess {
//                print("pin matched, go to next page, no action to perfrom here")
//            } else {
//                pin = ""
//                //isDisabled = false
//                print("this has to called after showing toast why is the failure")
//            }
//        }
//
//        if pin.count == maxDigits {
//            //isDisabled = true
//
//
//        }
//
//        // this code is never reached under  normal circumstances. If the user pastes a text with count higher than the
//        // max digits, we remove the additional characters and make a recursive call.
//        if pin.count > maxDigits {
//            pin = String(pin.prefix(maxDigits))
//            submitPin()
//        }
//    }
}

extension String {
    
    var digits: [Int] {
        var result = [Int]()
        
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        
        return result
    }
    
}

extension Int {
    
    var numberString: String {
        
        guard self < 10 else { return "0" }
        
        return String(self)
    }
}
