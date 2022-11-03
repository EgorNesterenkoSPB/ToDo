import Foundation


final class RegisterRequest {
    
    func postRequest(parameters:[String:Any],url:URL,withCompletion: @escaping (Int?,String?) -> Void) {
        
        // create the session object
        let session = URLSession.shared
        
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            // convert parameters to Data and assign dictionary to httpBody of request
            //TODO: - Mock data, for test api
            let mockData:[String:Any] = ["id":0,"name":"testName","password":"testPassword","description":"testDescription"]
            request.httpBody = try JSONSerialization.data(withJSONObject: mockData, options: .prettyPrinted)
        } catch let error {
            withCompletion(nil,error.localizedDescription)
        }
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                withCompletion(nil,"Post Request Error: \(error.localizedDescription)")
                return
            }
            
            // ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                withCompletion(nil,"Invalid Response received from the server")
                return
            }
            withCompletion(httpResponse.statusCode,nil)
            // ensure there is data returned
            //        guard let responseData = data else {
            //          print("nil Data received from the server")
            //          return
            //        }
            //
            //        do {
            //          // create json object from data or use JSONDecoder to convert to Model stuct
            //          if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
            //            print(jsonResponse)
            //            // handle json response
            //          } else {
            //            print("data maybe corrupted or in wrong format")
            //            throw URLError(.badServerResponse)
            //          }
            //        } catch let error {
            //          print(error.localizedDescription)
            //        }
        }
        // perform the task
        task.resume()
    }
}

