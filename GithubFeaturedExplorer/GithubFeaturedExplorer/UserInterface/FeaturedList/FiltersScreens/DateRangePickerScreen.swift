//
//  DateRangePicker.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 05/06/2025.
//

import SwiftUI

enum DateRange: String, CaseIterable, Identifiable {
    case today
    case thisWeek
    case thisMonth

    var id: String { rawValue }

    var title: String {
        switch self {
        case .today: "Today"
        case .thisWeek: "This Week"
        case .thisMonth: "This Month"
        }
    }
    
    private var value: Int {
        switch self {
        case .today: -1
        case .thisWeek: -7
        case .thisMonth: -30
        }
    }
    
    var calculatedDateRange: String {
        guard
            let date = Calendar.current.date(byAdding: .day, value: value, to: Date())
        else { return "" }
        
        let stringDate = date.string(with: .apiDate)
        return stringDate
    }
}

struct DateRangePickerScreen: View {
    private let ranges = DateRange.allCases
    
    @Binding var selectedRange: DateRange
    var onDismiss: () -> Void

    var body: some View {
        List(ranges, id: \.self) { range in
            Button {
                selectedRange = range
                onDismiss()
            } label: {
                HStack {
                    Text(range.title)
                    Spacer()
                    if selectedRange == range {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
            }
        }
        .listStyle(.insetGrouped)
    }
}

#Preview {
    DateRangePickerScreen(selectedRange: .constant(.today), onDismiss: {})
}
