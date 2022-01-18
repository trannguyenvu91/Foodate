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
    @StateObject var model = InviteViewModel()
    @State var isEditingStart = false
    
    var body: some View {
        GeometryReader(content: { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                Spacer(minLength: 110)
                titleView
                placeView
                scheduleView
                guestView
                splitBillView
                Spacer(minLength: 100)
            }
            .animation(.linear, value: 1)
            .padding([.leading, .trailing])
            .overlay(createButton(geometry.size.width), alignment: .bottom)
            .overlay(cancelButton, alignment: .topLeading)
        })
            .onReceive(AppSession.shared.newInvitation) { _ in
            self.presentationMode.wrappedValue.dismiss()
        }
        .bindErrorAlert(to: $model)
        .resignKeyboardOnDragGesture()
    }
    
    var scheduleView: some View {
        VStack(alignment: .leading) {
            sectionLabel("InviteView_Start_Title".localized())
            timeView(at: model.draft.startAt) {
                self.isEditingStart.toggle()
            }
            if isEditingStart {
                datePicker(date: $model.draft.startAt)
            }
            Divider()
        }
    }
    
    var titleView: some View {
        VStack {
            sectionLabel("InviteView_Title".localized())
            MultilineTextField("InviteView_Placeholder".localized(), text: $model.draft.title)
                .font(.title)
                .padding(.top)
            Divider()
        }
        .padding(.bottom)
    }
    
    var placeView: some View {
        VStack(alignment: .leading) {
            sectionLabel("InviteView_Place_Title".localized())
            if let place = model.draft.place {
                placeInfo(place)
            } else {
                addPlaceView
            }
            Divider()
        }
    }
    
    var guestView: some View {
        VStack(alignment: .leading) {
            sectionLabel("Invite_Button_Title".localized())
            if let toUser = model.draft.toUser {
                personInfo(toUser)
            } else {
                addPersonView
            }
            Divider()
        }
    }
    
    var splitBillView: some View {
        VStack(alignment: .leading) {
            sectionLabel("InviteView_ShareBill".localized())
                .foregroundColor(.gray)
                .font(.subheadline)
            billPicker
        }
    }
    
    var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            xCloseImage
                .frame(width: 12, height: 12)
                .padding(14)
                .background(Color.groupTableViewBackground)
                .clipShape(Circle())
                .padding()
        }
    }
    
    var xCloseImage: some View {
        Image(systemName: "xmark")
            .resizable()
            .scaledToFit()
    }
    
    var billPicker: some View {
        Picker("Bill Type", selection: $model.draft.shareBill) {
            ForEach(FDShareBill.allCases, id: \.self) { type in
                Text(type.title).tag(type)
            }
        }
        .pickerStyle(.segmented)
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
        HStack {
            Button(action: didPress) {
                Text(date.timeText + "  " + date.dayText + ", " + date.monthText)
                    .fontWeight(.semibold)
                    .height(30)
            }
            Text("trong")
                .foregroundColor(.gray)
            Button(action: {
                
            }, label: {
                Text(model.draft.durationText)
                    .fontWeight(.semibold)
            })
        }
    }
    
    func placeInfo(_ snapshot: ObjectSnapshot<FDPlace>) -> some View {
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
    
    func personInfo(_ snapshot: ObjectSnapshot<FDUserProfile>) -> some View {
        HStack {
            UserHeader(snapshot)
                .height(50)
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
            SearchView(model: .init([.place]), selectionCommand: model.selectionCommand)
        )) {
            HStack {
                Image(systemName: "pin")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 14, height: 14)
                Text("InviteView_Add_Place_Button_Title".localized())
                    .fontWeight(.semibold)
            }
            .padding(14)
            .foregroundColor(.orange)
        }
        .background(Color.orange.opacity(0.2).clipShape(.stadium))
    }
    
    var addPersonView: some View {
        PresentButton(destination: LazyView(
                        SearchView(model: .init([.account]), selectionCommand: model.selectionCommand)
        )) {
            CircleView(Image(systemName: "person.badge.plus")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(22)
                        .foregroundColor(.blue)
                        .background(Color.blue.opacity(0.2)),
                       lineWidth: 1,
                       lineColor: .clear)
        }
    }
    
    func sectionLabel(_ text: String) -> some View {
        HStack {
            Text(text)
                .foregroundColor(.gray)
                .fontWeight(.medium)
                .padding(.bottom, 6)
            Spacer()
        }
    }
    
    func createButton(_ width: CGFloat) -> some View {
        AsyncButton(task: {
            try await model.createInvitation()
        }, error: $model.error) {
            Text("InviteView_Send_Invitation_Button_Title".localized())
                .font(.title2)
                .fontWeight(.semibold)
                .padding([.top, .bottom], 16)
                .width(width - 40)
        }
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(16)
    }
    
    func datePicker(date: Binding<Date>) -> some View {
        DatePicker(selection: date,
                   in: PartialRangeFrom(Date()),
                   displayedComponents: [.date, .hourAndMinute]) {
                    Text("")
        }
                   .datePickerStyle(.wheel)
        .labelsHidden()
    }
    
}

extension InviteView {
    
    init(_ person: ObjectPublisher<FDUserProfile>? = nil, to place: ObjectPublisher<FDPlace>? = nil) {
        self.init()
        self.model.draft.toUser = person?.asSnapshot(in: .defaultStack)
        self.model.draft.place = place?.asSnapshot(in: .defaultStack)
    }
    
    init(_ person: ObjectSnapshot<FDUserProfile>? = nil, to place: ObjectSnapshot<FDPlace>? = nil) {
        self.init()
        self.model.draft.toUser = person
        self.model.draft.place = place
    }
}

extension FDShareBill {
    var title: String {
        switch self {
        case .fifty:
            return "ShareBill_Fifty_Title".localized()
        case .seventy:
            return "ShareBill_Seventy_Title".localized()
        case .oneHundred:
            return "ShareBill_OneHundred_Title".localized()
        }
    }
}

struct InviteView_Previews: PreviewProvider {
    static var previews: some View {
        InviteView()
    }
}
