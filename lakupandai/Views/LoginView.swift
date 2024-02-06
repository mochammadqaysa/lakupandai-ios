//
//  LoginView.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/12/23.
//

import SwiftUI
import AlertToast
import UserNotifications

struct LoginView: View {
    
    @ObservedObject var loginVM = LoginViewModel()
    @Binding var isUnlocked : Bool
    var body: some View {
        NavigationStack {
                ZStack{
                    Color("colorPrimary").ignoresSafeArea()
                    VStack{
                        Spacer()
                        Image("ic_logo_diy_white")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom,100)
                            .padding(.leading,20)
                            .padding(.trailing,20)
                        HStack {
                            Image(systemName: "person.fill")
                            ZStack(alignment: .leading) {
                                if loginVM.username.isEmpty {
                                    Text("Username") .bold() .foregroundColor(.white)
                                }
                                TextField("", text: $loginVM.username)
                                    .foregroundColor(.white)
                            }
                            
                        }
                        .foregroundColor(.white)
                        .accentColor(.white)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.white))
                        HStack {
                            Image(systemName: "lock.fill")
                            ZStack(alignment: .leading){
                                if loginVM.password.isEmpty {
                                    Text("PIN") .bold() .foregroundColor(.white)
                                }
                                if loginVM.showPassword {
                                    TextField("", text: $loginVM.password)
                                        .keyboardType(.numberPad)
                                        .foregroundColor(.white)
                                } else {
                                    SecureField("", text: $loginVM.password).foregroundColor(.white)
                                        .keyboardType(.numberPad)
                                        .textContentType(.password)
                                }
                            }
                            .onChange(of: loginVM.password) { newValue in
                                if newValue.count > 6 {
                                    loginVM.password = String(newValue.prefix(6))
                                }
                            }
                            Button(action: { loginVM.showPassword.toggle() }) {
                                Image(systemName: loginVM.showPassword ? "eye.fill" : "eye.slash.fill")
                            }
                        }
                        .foregroundColor(.white)
                        .accentColor(.white)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.white))
                        Toggle(isOn: $loginVM.rememberMe){
                            Text("Ingat Saya").frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(.white)
                        }.accentColor(.white)
                        
                        Button(action: {
                            loginVM.validateForm()
                        }) {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                        }
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(Rectangle())
                        .onChange(of: loginVM.isLogin) { newValue in
                            self.isUnlocked = newValue
                        }
                        .alert(isPresented: $loginVM.showAlert) {
                            Alert(title: Text("Peringatan"), message: Text(loginVM.alertMessage), dismissButton: .default(Text("OK")))
                        }
                        
                        
                        Spacer()
                        
                        Text("Versi 2.0").foregroundColor(.white).padding()
                        Image("motif_bawah")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding(.horizontal,30)
                    
                }
//            .blur(radius: loginVM.isLoading ? 20 : 0)
            
            .toast(isPresenting: $loginVM.isLoading) {
                AlertToast(displayMode: .alert, type: .loading, title: "Loading", subTitle: "Please Wait...", style: .style(backgroundColor: .gray, titleColor: .white, subTitleColor: .white))
            }
            .alert(isPresented: $loginVM.showAlert){
                Alert(
                    title: Text("Peringatan"),
                    message: Text(loginVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isUnlocked: .constant(false))
    }
}
