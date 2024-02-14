//
//  MemoList.swift
//  MyMemory
//
//  Created by 이명섭 on 1/7/24.
//

import SwiftUI

//이 구조체는 MemoListViewModel 프로토콜을 준수하는 어떤 뷰모델 타입(ViewModel)을 받을 수 있습니다.
struct ProfileMemoList<ViewModel: ProfileViewModelProtocol>: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var isLoadingFetchMemos = false
    @State private var showsAlert = false

    @State private var profile: Profile = {
        var profile = AuthService.shared.currentUser!.toProfile
        
        return AuthService.shared.currentUser!.toProfile
    }()
    var body: some View {
        LazyVStack(spacing: 20) {
            // 각각의 뷰 모델을 활용하여 메모 리스트를 가져옴
            
            ForEach($viewModel.memoList.indices, id: \.self) { i in
                NavigationLink {
                    MemoDetailView(memos: $viewModel.memoList, selectedMemoIndex: i)
                } label: {
                    //ProfileMemoListCell(memo: memo, viewModel: viewModel)
                    MemoCard(memo: $viewModel.memoList[i], profile:$profile, isMyPage: true) { action in
                        switch action {
                        case .like:
                            print("like")
                        case .pinned(let success):
                            if success {
                                print("pinned")
                            } else {
                                showsAlert.toggle()
                            }
                        default:
                            break
                        }
                    }.frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onAppear {
                            Task {
                                // 1. 로그인 되어있는지 체크
                                // 2. 뷰모델에 따라 알맞은 로직을 실행
                                if let userId = UserDefaults.standard.string(forKey: "userId") {
                                    if i == viewModel.memoList.count - 1 {
                                        if let mypageViewModel = viewModel as? MypageViewModel {
                                            self.isLoadingFetchMemos = true
                                            await mypageViewModel.pagenate(userID: userId)
                                            self.isLoadingFetchMemos = false
                                        } else if let otherUserViewModel = viewModel as? OtherUserViewModel {
                                            self.isLoadingFetchMemos = true
                                            self.profile = otherUserViewModel.memoCreator.toProfile
                                            let userId = otherUserViewModel.memoCreator.id?.description
                                            await otherUserViewModel.pagenate(userID: userId ?? "")
                                            self.isLoadingFetchMemos = false
                                        }
                                    }
                                }
                            }
                        }
                }
                .buttonStyle(.plain)
            }

            
        }
        .moahAlert(isPresented: $showsAlert) {
            MoahAlertView(title: "핀을 다 써버렸어요!", message: "5개까지만 고정할 수 있습니다.",firstBtn: MoahAlertButtonView(type: .CONFIRM, isPresented: $showsAlert, action: {
                
            }))
        }
        if isLoadingFetchMemos {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .padding(.vertical, 16)
        }
    }
}
