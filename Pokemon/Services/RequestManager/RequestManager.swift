//
//  RequestManager.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

struct RequestStruct {
    static let DOMAIN = "https://pokeapi.co/api/v2/"
}

class RequestManager {
    static let shared = RequestManager()
    
    internal var observation: NSKeyValueObservation?
    
    private init() {
    }
}

extension RequestManager {
    internal func httpGet(url: String, parameters: [String: Any]?, useToken: Bool = false, httpClosure: @escaping (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> Void) {
        
        var urlStr: String = url
        
        if let para: [String: Any] = parameters {
            let urlComp = NSURLComponents(string: url)!

            var items = [URLQueryItem]()

            for (key, value) in para {
                print("httpGet key:\(key) value:\(value)")
                items.append(URLQueryItem(name: key, value: value as? String))
            }

            items = items.filter{!$0.name.isEmpty}

            if !items.isEmpty {
              urlComp.queryItems = items
            }
            
            urlStr = urlComp.url!.absoluteString
            print("httpGet url: \(urlStr)")
        }
        
        guard let requestUrl = URL(string: urlStr) else { fatalError("httpGet url Error") }
        
        let request = NSMutableURLRequest(url: requestUrl,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 15.0)
        
        request.httpMethod = "GET"
        
        let headers = getHeaders()
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: httpClosure)
        task.resume()
    }
    
    internal func httpPost(url: String, parameters: [String: Any]?, body: [String: Any]?, token: String? = nil, httpClosure: @escaping (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> Void) {
        var urlStr: String = url
        
        if let para: [String: Any] = parameters {
            let urlComp = NSURLComponents(string: url)!

            var items = [URLQueryItem]()

            for (key, value) in para {
                items.append(URLQueryItem(name: key, value: value as? String))
            }

            items = items.filter{!$0.name.isEmpty}

            if !items.isEmpty {
              urlComp.queryItems = items
            }
            
            urlStr = urlComp.url!.absoluteString
            print("httpPost url:\(urlStr)")
        }
        
        guard let requestUrl = URL(string: urlStr) else { fatalError("httpPost url Error") }
        
        let request = NSMutableURLRequest(url: requestUrl,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 15.0)
        
        request.httpMethod = "POST"
        
        if let body: [String: Any] = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
            } catch let error {
                print("JSONSerialization Error \(error)")
            }
        }
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let headers = getHeaders()
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: httpClosure)
        task.resume()
    }
    
    internal func httpPostFile(url: String, file: Data? = nil, parameters: [String: Any]?, useToken: Bool = true, httpClosure: @escaping (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> Void, progressClosure: @escaping (_ progress: Double) -> Void) {
        var urlStr: String = url
        
        if let para: [String: Any] = parameters {
            let urlComp = NSURLComponents(string: url)!

            var items = [URLQueryItem]()

            for (key, value) in para {
                items.append(URLQueryItem(name: key, value: value as? String))
            }

            items = items.filter{!$0.name.isEmpty}

            if !items.isEmpty {
              urlComp.queryItems = items
            }
            
            urlStr = urlComp.url!.absoluteString
            print("httpPost url:\(urlStr)")
        }
        
        guard let requestUrl = URL(string: urlStr) else { fatalError("httpPost url Error") }
        
        let request = NSMutableURLRequest(url: requestUrl,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 15.0)
        
        request.httpMethod = "POST"
        
        //add file
        let uuid = UUID().uuidString
        let CRLF = "\r\n"
        let fileName: String = "\(uuid).jpg"
        let formName = "file"
        let imgType = "image/jpeg"
        let boundary = String(format: "----iOSURLSessionBoundary.%08x%08x", arc4random(), arc4random())
        var body = Data()
        if file != nil {
            body.append(("--\(boundary)" + CRLF).data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(formName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append(("Content-Type: \(imgType)" + CRLF + CRLF).data(using: .utf8)!)
            body.append(file!)
            body.append(CRLF.data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body
        
        let headers = getPostFileHeaders(boundary: boundary)
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: httpClosure)
        
        if let observation = self.observation {
            observation.invalidate()
            self.observation = nil
        }
        self.observation = task.progress.observe(\.fractionCompleted, changeHandler: { progress, _ in
//            print("progress: ", progress.fractionCompleted)
            DispatchQueue.main.async {
                progressClosure(progress.fractionCompleted)
            }
        })
        
        task.resume()
    }
    
    internal func getHeaders() -> [String : String] {
        var dic: [String : String] = Dictionary()
        dic["Content-Type"] = "application/json"
        return dic
    }
    
    internal func getPostFileHeaders(boundary: String) -> [String : String] {
        var dic = getHeaders()
        dic["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        return dic
    }
}

extension RequestManager {
    internal func downloadFile(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(String(describing: error))")
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}
