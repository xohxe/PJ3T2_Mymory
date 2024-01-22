//
//  MemoCell.swift
//  MyMemory
//
//  Created by 김소혜 on 1/15/24.
//

import SwiftUI
import CoreLocation

struct MemoCell: View {
    
    @State var isVisible: Bool = true
    @State var isDark: Bool = false
    @Binding var location: CLLocation?
    
    var item: Memo
    var body: some View {
        HStack(spacing: 16) {
            
            VStack{
                Image(systemName: isVisible ? "heart.fill": "lock")
                    .foregroundColor(.gray)
                    .frame(width: 46, height: 46)
                    .background(isDark ? .white : .lightGray)
                    .clipShape(Circle())
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 6) {
                
                // Tag는 세 개까지 표시
                HStack {
                    if item.tags.count > 3 {
                        ForEach(item.tags[0..<3], id: \.self) { str in
                        Text("#\(str)")
                        }
                    } else {
                        ForEach(item.tags, id: \.self) { str in
                        Text("#\(str)")
                        }
                    }
                }

                .foregroundColor(.gray)
                .font(.regular14)
                Text(isVisible ? item.title : "거리가 멀어서 볼 수 없어요.")
                    .lineLimit(1)
                    .font(.black20)
                    .foregroundStyle(isDark ? .white : .black)
                
                Button {
                    // 메모 정보 확인
                    // 추후 디테일뷰 연결해서 메모 전달 해주면 될거같음
                    print(item)
                } label: {
                    Text("해당 장소 메모보기")
                }
                .buttonStyle(isDark ? Pill.deepGray : Pill.lightGray)
                
                Spacer()
                    .padding(.bottom, 12)
                
                
                
                
                HStack(alignment:  .center) {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("\(item.likeCount)개")
                        Text("|")
                        Image(systemName: "location.fill")
                        if let loc = location {
                            Text("\(item.location.distance(from: loc).distanceToMeters())")
                                .lineLimit(1)
                        } else {
                            Text("\(-1)m")
                                .lineLimit(1)
                        }
                    }
                    .foregroundColor(.gray)
                    .font(.regular12)
                    
                    Spacer()
                    
                    if isVisible {
                        
                        Button {
                            // 디테일 뷰로 이동
                        } label: {
                            HStack {
                                Image(systemName: "location.fill")
                                Text("방문하기")
                            }
                            
                        }
                    }
                    
                }
                .buttonStyle(RoundedRect.primary)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
        }
        .padding(20)
        .background(isDark ? Color(UIColor.black) : .white)
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .cornerRadius(20)
    }
}

#Preview {
    VStack {
//        MemoCell(isVisible: true, isDark: true)
//        MemoCell(isVisible: true, isDark: false)
//        MemoCell(isVisible: false, isDark: true)
//        MemoCell(isVisible: false, isDark: false)
    }
    
}
