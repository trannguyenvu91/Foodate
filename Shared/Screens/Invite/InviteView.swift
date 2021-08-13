//
//  InviteView.swift
//  Foodate
//
//  Created by Vu Tran on 05/08/2021.
//

import SwiftUI
import MapKit
import CoreStore

struct InviteView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var model = InviteViewModel()
    let leftWidth: CGFloat = 40
    let iconWidth: CGFloat = 22
    
    var body: some View {
        NavigationView {
            ScrollView {
                titleView
                scheduleView
                placeView
                guestView
                splitBillView
                settingHeader
                reminderView
                calendarView
                Spacer(minLength: 40)
            }
            .animation(.linear)
            .padding([.leading, .trailing])
            .navigationBarTitle("Lời mời mới", displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: sendButton)
        }
        .onReceive(model.didCreateCommand) { _ in
            self.presentationMode.wrappedValue.dismiss()
        }
        .bindErrorAlert(to: $model)
        .resignKeyboardOnDragGesture()
    }
    
    var scheduleView: some View {
        HStack(spacing: 0) {
            iconView("clock")
            VStack(alignment: .leading) {
                timeView(at: model.draft.startAt) {
                    self.isEditingEnd = false
                    self.isEditingStart.toggle()
                }
                if isEditingStart {
                    datePicker(date: $model.draft.startAt)
                }
                timeView(at: model.draft.endAt) {
                    self.isEditingStart = false
                    self.isEditingEnd.toggle()
                }
                if isEditingEnd {
                    datePicker(date: $model.draft.endAt)
                }
                Divider()
            }
        }
    }
    
    var settingHeader: some View {
        VStack(alignment: .leading) {
            Spacer()
            Divider()
            Text("Cài đặt của bạn")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.leading, leftWidth)
        }
    }
    
    var titleView: some View {
        VStack {
            MultilineTextField("Thêm tiêu đề", text: $model.draft.title)
                .font(.title)
                .padding(.leading, leftWidth)
                .padding(.top)
            Divider()
        }
        .padding(.bottom)
    }
    
    var placeView: some View {
        HStack(spacing: 0) {
            iconView("mappin.circle")
            VStack(alignment: .leading) {
                if let place = model.draft.place {
                    placeInfo(place)
                } else {
                    addPlaceView
                }
                Divider()
            }
        }
    }
    
    var guestView: some View {
        HStack(alignment: .center, spacing: 0) {
            iconView("person.2")
            VStack(alignment: .leading) {
                if let toUser = model.draft.toUser {
                    personInfo(toUser)
                } else {
                    addPersonView
                }
                Divider()
            }
        }
    }
    
    var splitBillView: some View {
        HStack(spacing:0) {
            iconView("dollarsign.circle")
            VStack(alignment: .leading) {
                Text("Cách thức trả tiền")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                billPicker
            }
        }
    }
    
    var reminderView: some View {
        HStack(spacing:0) {
            iconView("bell")
            VStack(alignment: .leading) {
                Text("Trước 30 phút")
            }
            Spacer()
        }
    }
    
    var calendarView: some View {
        HStack(spacing:0) {
            iconView("calendar.badge.plus")
            VStack(alignment: .leading) {
                Text("Thêm vào lịch Apple")
            }
            Spacer()
        }
    }
    
    var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            xCloseImage
                .frame(width: 18, height: 18)
        }
    }
    
    var xCloseImage: some View {
        Image(systemName: "xmark")
            .resizable()
            .scaledToFit()
    }
    
    var sendButton: some View {
        Button(action: {
            model.createCommand.send(nil)
        }) {
            Image(systemName: "paperplane")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(model.draft.isValid ? .blue : .gray)
        }
    }
    
    var billPicker: some View {
        Picker("Bill Type", selection: $model.draft.shareBill) {
            ForEach(FDShareBill.allCases, id: \.self) { type in
                Text(type.title).tag(type)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    func iconView(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: iconWidth, height: iconWidth)
            .padding(.trailing, leftWidth - iconWidth)
            .foregroundColor(.orange)
    }
    
    func mapView(_ snapshot: ObjectSnapshot<FDPlace>) -> some View {
        Map(coordinateRegion: .constant(snapshot.coordinateRegion),
            annotationItems: [model]) { _ in
            MapPin(coordinate: snapshot.locationCoordinate2D, tint: Color.purple)
        }
        .height(90)
        .cornerRadius(12)
        .disabled(true)
    }
    
    func timeView(at date: Date, didPress: @escaping () -> Void) -> some View {
        Button(action: didPress) {
            HStack {
                Text(date.dayText + ", " + date.monthText)
                Spacer()
                Text(date.timeText)
            }
            .height(30)
        }
    }
    
    func placeInfo(_ place: ObjectPublisher<FDPlace>) -> some View {
        ObjectReader(place) { snapshot in
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(snapshot.$name ?? "--")
                            .fontWeight(.medium)
                        Text(snapshot.$vicinity ?? "--")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    Spacer()
                    Button {
                        model.draft.place = nil
                    } label: {
                        xCloseImage
                            .frame(width: 8, height: 8)
                            .padding(6)
                            .background(Color.groupTableViewBackground)
                            .cornerRadius(10)
                    }
                }
                mapView(snapshot)
            }
        }
    }
    
    func personInfo(_ user: ObjectPublisher<FDUserProfile>) -> some View {
        HStack {
            ObjectReader(user) { snapshot in
                UserHeader(snapshot)
                    .height(34)
            }
            Spacer()
            Button {
                model.draft.toUser = nil
            } label: {
                xCloseImage
                    .frame(width: 8, height: 8)
                    .padding(6)
                    .background(Color.groupTableViewBackground)
                    .cornerRadius(10)
            }
        }
    }
    
    var addPlaceView: some View {
        PresentButton(destination: LazyView(
                        SearchView([.place], selectionCommand: model.selectionCommand)
        )) {
            Text("Thêm địa điểm")
            .bold()
        }
    }
    
    var addPersonView: some View {
        PresentButton(destination: LazyView(
                        SearchView([.account], selectionCommand: model.selectionCommand)
        )) {
            Text("Thêm bạn bè")
                .bold()
        }
    }
    
    @State var isEditingStart = false
    @State var isEditingEnd = false
    
    func datePicker(date: Binding<Date>) -> some View {
        DatePicker(selection: date,
                   in: PartialRangeFrom(Date()),
                   displayedComponents: [.date, .hourAndMinute]) {
                    Text("")
        }
        .datePickerStyle(WheelDatePickerStyle())
        .labelsHidden()
    }
    
}

extension InviteView {
    
    init(person: ObjectPublisher<FDUserProfile>? = nil, to place: ObjectPublisher<FDPlace>? = nil) {
        self.init()
        self.model.draft.toUser = person
        self.model.draft.place = place
    }
    
}

extension FDShareBill {
    var title: String {
        switch self {
        case .fifty:
            return "50-50"
        case .seventy:
            return "Bạn trả 70%"
        case .oneHundred:
            return "Bạn mời 100%"
        }
    }
}

struct InviteView_Previews: PreviewProvider {
    static var previews: some View {
        InviteView()
    }
}
