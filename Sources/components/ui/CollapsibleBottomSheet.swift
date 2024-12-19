import SwiftUI

/// A view that displays a collapsible bottom sheet showing logs. It includes a header with a
/// title and a count of logs, and the content of the bottom sheet can be expanded or collapsed
/// based on user interaction.
struct CollapsibleBottomSheet: View {
    let title: String
    let logs: [Log]
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        Spacer()
        
        VStack(spacing: 0) {
            // Header Section
            VStack {
                HStack {
                    // Title and log count
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("\(logs.count)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(minWidth: 20, minHeight: 20)
                            .padding(.vertical, 2)
                            .padding(.horizontal, logs.count > 99 ? 5 : logs.count > 9 ? 3 : 2)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(6)
                    }
                    .foregroundColor(Color(hex: "#56565C"))
                    
                    Spacer()
                    
                    // Chevron icon for expanding/collapsing
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color(hex: "#97979B"))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding()
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
            }
            .background(Color.white)
            .overlay(Divider().background(Color(hex: "#EDEDF0")), alignment: .top)
            
            // Collapsible Content Section
            if isExpanded {
                LogsBottomSheet(logs: logs)
                    .transition(.move(edge: .bottom))
                    .background(Color.white)
            }
        }
        /// push down
        .padding(.bottom, -16)
        .fixedSize(horizontal: false, vertical: true)
    }
}

/// A view displaying logs in a table format, including a project section and a list of logs.
/// If there are no logs, a placeholder message is shown.
struct LogsBottomSheet: View {
    let logs: [Log]
    
    private let columns: [(name: String, width: CGFloat)] = [
        ("Date", 170),
        ("Status", 90),
        ("Method", 100),
        ("Path", 125),
        ("Response", 225)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Project Section
                ProjectSection()
                
                // Logs Table
                if logs.isEmpty {
                    VStack {
                        HStack(spacing: 0) {
                            Text("Logs")
                                .font(.subheadline)
                                .padding(.vertical, 12)
                                .background(Color(hex: "#F9F9FA"))
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .foregroundColor(Color(hex: "#97979B"))
                        .background(Color(hex: "#FAFAFB"))
                        .overlay(
                            VStack {
                                Divider().background(Color(hex: "#EDEDF0"))
                                Spacer()
                                Divider().background(Color(hex: "#EDEDF0"))
                            }
                        )
                        
                        Text("There are no logs to show")
                            .font(.subheadline.monospaced())
                            .foregroundColor(Color(hex: "#56565C"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                } else {
                    ScrollView(.horizontal) {
                        VStack(spacing: 0) {
                            // Table Headers
                            LogsTableHeader(columns: columns)
                            
                            // Table Rows
                            ForEach(logs) { log in
                                LogsTableRow(log: log, columns: columns)
                            }
                        }
                    }
                }
            }.animation(.default, value: logs.count)
        }
        .frame(maxHeight: UIScreen.main.bounds.height * 0.485)
    }
}

/// A view to display project information like endpoint, project ID, name, and version.
struct ProjectSection: View {
    @EnvironmentObject var appwrite: AppwriteSDK
    private var appwriteProjectData: (endpoint: String, projectId: String, projectName: String, version: String) {
        appwrite.getProjectInfo()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Project Title
            Text("Project")
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .foregroundColor(Color(hex: "#97979B"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "#FAFAFB"))
                .overlay(
                    VStack {
                        Divider().background(Color(hex: "#EDEDF0"))
                        Spacer()
                        Divider().background(Color(hex: "#EDEDF0"))
                    }
                )
            
            // Project Details in a Grid
            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 16) {
                GridRow {
                    ProjectRow(title: "Endpoint", value: appwriteProjectData.endpoint)
                    
                    
                    ProjectRow(title: "Project ID", value: appwriteProjectData.projectId)
                }
                GridRow {
                    ProjectRow(title: "Project name", value: appwriteProjectData.projectName)
                    
                    ProjectRow(title: "Version", value: appwriteProjectData.version)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

/// A reusable component to display individual project details like endpoint, project ID, etc.
struct ProjectRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundColor(Color(hex: "#97979B"))
            Text(value)
                .font(.callout)
                .foregroundColor(Color(hex: "#56565C"))
                .lineLimit(1)
                .truncationMode(.middle)
        }
        .padding([.top, .bottom], 4)
    }
}

/// A component that displays a log row in the table, with dynamic content based on the column name.
struct LogsTableRow: View {
    let log: Log
    let columns: [(name: String, width: CGFloat)]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(columns, id: \.name) { column in
                Group {
                    switch column.name {
                    case "Date":
                        Text(log.date)
                    case "Status":
                        StatusTag(status: log.status)
                    case "Method":
                        Text(log.method)
                    case "Path":
                        Text(log.path)
                    case "Response":
                        Text(log.response)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 5)
                            .background(Color.gray.opacity(0.25))
                            .cornerRadius(6)
                    default:
                        EmptyView()
                    }
                }
                .font(.subheadline.monospaced())
                .foregroundColor(Color(hex: "#56565C"))
                .frame(width: column.width, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.white)
        .overlay(Divider(), alignment: .bottom)
    }
}

/// A view to display the header of the logs table, with column names as headers.
struct LogsTableHeader: View {
    let columns: [(name: String, width: CGFloat)]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(columns, id: \.name) { column in
                Text(column.name)
                    .font(.subheadline)
                    .frame(width: column.width, alignment: .leading)
                    .background(Color(hex: "#F9F9FA"))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .foregroundColor(Color(hex: "#97979B"))
        .background(Color(hex: "#FAFAFB"))
        .overlay(
            VStack {
                Divider().background(Color(hex: "#EDEDF0"))
                Spacer()
                Divider().background(Color(hex: "#EDEDF0"))
            }
        )
    }
}

/// A view to display a status tag with conditional styling based on the status value.
struct StatusTag: View {
    let status: String
    
    var body: some View {
        Text(status)
            .font(.footnote)
            .fontWeight(.medium)
            .padding(.vertical, 2)
            .padding(.horizontal, 5)
            .background(Color(hex: statusColor.background).cornerRadius(6).opacity(0.24))
            .foregroundColor(Color(hex: statusColor.text))
            .fixedSize(horizontal: true, vertical: true)
    }
    
    private var statusColor: (background: String, text: String) {
        if let statusCode = Int(status), statusCode >= 200 && statusCode < 400 {
            return ("#10B981", "#0A714F")
        } else {
            return ("#FF453A", "#B31212")
        }
    }
}

/// A sample log model for displaying log entries.
struct Log: Identifiable {
    let id = UUID()
    let date: String
    let status: String
    let method: String
    let path: String
    let response: String
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var showEmpty = false
    
    ZStack {
        VStack {
            // Button to toggle between empty and full logs state
            Button("Logs state: \(showEmpty ? "Empty" : "Full")") {
                showEmpty.toggle()
            }
        }
        
        VStack {
            Spacer()
            
            CollapsibleBottomSheet(
                title: "Logs",
                logs: showEmpty ? [] :
                    Array(repeating:
                            Log(
                                date: "Dec 10, 02:51",
                                status: "200",
                                method: "GET",
                                path: "/v1/ping",
                                response: "Success"),
                          count: 5
                         )
            )
            .environmentObject(AppwriteSDK())
        }
    }
}
