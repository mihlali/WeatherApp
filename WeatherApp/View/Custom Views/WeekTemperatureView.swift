//
//  WeekTemperatureView.swift
//  WeatherApp
//
//  Created by Mihlali Mazomba on 2023/05/10.
//

import SwiftUI

struct WeekTemperatureView: View {
    let weeksTemperatures: [TemperatureModel]
    let backgroundColor: Color
    
    var body: some View {
        VStack  {
            ForEach(weeksTemperatures,id: \.self) { temperature in
                DaysTemperatureView(temperatureModel: temperature)
            }
        }.background(backgroundColor)
    }
}

struct TemperatureModel: Hashable {
    let weatherDay : String
    let image: String
    let Temperature: String
}

struct DaysTemperatureView: View {
    let temperatureModel: TemperatureModel
    
    var body: some View {
        
        HStack {
            Text(temperatureModel.weatherDay)
                .font(.body)
                .foregroundColor(Color.white)
            
            Spacer()
            
            Image(temperatureModel.image)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
            Spacer()
            
            Text("\(temperatureModel.Temperature)°")
                .foregroundColor(Color.white)
            
        }.frame(maxWidth: .infinity, alignment: .leading)
         .padding(.horizontal)
    }
}

struct WeekTemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        WeekTemperatureView(
            weeksTemperatures:
                [TemperatureModel(
                    weatherDay: "Monday",
                    image: "clear",
                    Temperature: "20"),
                 TemperatureModel(
                    weatherDay: "TuesDay",
                    image: "rain",
                    Temperature: "10")],
            backgroundColor: Color.weatherColor.sunny)
    }
}
