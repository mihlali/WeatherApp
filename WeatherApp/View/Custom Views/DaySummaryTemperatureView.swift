//
//  DaySummaryTemperatureView.swift
//  WeatherApp
//
//  Created by Mihlali Mazomba on 2023/05/10.
//

import SwiftUI

struct TempModel: Hashable {
    let title: String
    let subTitle: String
}

struct DaySummaryTemperatureView : View {
    
    let temperatures: [TempModel]
    let backgroundColor: Color
    
    var body: some View {
        
        VStack {
            HStack() {
                ForEach(temperatures, id: \.self) { temp in
                    TitleSubtileView(tempViewData: temp)
                    if temp != temperatures.last  {
                        Spacer()
                    }
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.all)
                .background(backgroundColor)
        }
    }
}

struct TitleSubtileView: View {
    let tempViewData: TempModel
    
    var body: some View {
        VStack {
            Group {
                Text(tempViewData.title + "°")
                    .foregroundColor(Color.white)
                
                Text(tempViewData.subTitle)
                    .fontWeight(.light)
                    .foregroundColor(Color.white)
            }
        }
    }
}

struct DaySummaryTemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        TitleSubtileView(
            tempViewData: TempModel(
                title: "Hello",
                subTitle: "world"))
    }
}
