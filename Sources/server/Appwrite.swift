import Appwrite
import Foundation

/// A class that provides convenient access to Appwrite API methods for interacting with the project, account, and databases.
class AppwriteSDK: ObservableObject {
    
    private let client: Client
    private let account: Account
    private let databases: Databases
    
    /// Change these in Config.plist
    private let PROJECT_ID: String
    private let PROJECT_NAME: String
    private let PUBLIC_APPWRITE_ENDPOINT: String
    
    init() {
        let config = AppwriteSDK.loadConfig()
        
        self.PROJECT_ID = config.projectId
        self.PROJECT_NAME = config.projectName
        self.PUBLIC_APPWRITE_ENDPOINT = config.endpoint
        
        client = Client()
            .setProject(PROJECT_ID)
            .setEndpoint(PUBLIC_APPWRITE_ENDPOINT)
        
        account = Account(client)
        databases = Databases(client)
    }
    
    /// Returns project-related information such as endpoint, project ID, name, and version.
    func getProjectInfo() -> (endpoint: String, projectId: String, projectName: String, version: String) {
        return (
            client.endPoint,
            PROJECT_ID,
            PROJECT_NAME,
            client.headers["x-appwrite-response-format"] ?? "1.6.0"
        )
    }
    
    /// Performs a ping request to the Appwrite API and returns the response as a `Log`.
    /// - Returns: A `Log` object representing the ping request's result.
    func ping() async -> Log {
        do {
            return try await executeRequest()
        } catch {
            return Log(
                date: getCurrentDate(),
                status: "Error",
                method: "GET",
                path: "/ping",
                response: "Request failed: \(error.localizedDescription)"
            )
        }
    }
    
    // TODO: Remove this once the SDK supports ping.
    /// Executes a manual request to the /ping endpoint of the Appwrite API and returns the result as a `Log`.
    /// - Throws: An error if the request fails.
    /// - Returns: A `Log` object with the response data.
    private func executeRequest() async throws -> Log {
        let url = URL(string: client.endPoint + "/ping")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add custom headers from client
        client.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
        }
        
        let status = String(httpResponse.statusCode)
        let responseString: String
        
        if httpResponse.statusCode == 200, let stringResponse = String(data: data, encoding: .utf8) {
            responseString = stringResponse
        } else {
            responseString = "Request failed with status code \(status)"
        }
        
        return Log(
            date: getCurrentDate(),
            status: status,
            method: "GET",
            path: "/ping",
            response: responseString
        )
    }
    
    /// Returns the current date formatted as "MMMM dd, HH:mm".
    /// - Returns: A string representing the current date.
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, HH:mm"
        return formatter.string(from: Date())
    }
    
    /// Loads configuration values from the Config.plist file.
    /// - Returns: A tuple containing the project ID, project name, and endpoint URL as strings.
    private static func loadConfig() -> (projectId: String, projectName: String, endpoint: String) {
        guard let configPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: configPath) as? [String: Any],
              let projectId = config["APPWRITE_PROJECT_ID"] as? String,
              let projectName = config["APPWRITE_PROJECT_NAME"] as? String,
              let endpoint = config["APPWRITE_PUBLIC_ENDPOINT"] as? String else {
            fatalError("Missing or invalid Config.plist or required keys")
        }
        
        return (projectId, projectName, endpoint)
    }
}
