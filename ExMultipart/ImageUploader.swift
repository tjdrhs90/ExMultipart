//
//  ImageUploader.swift
//  ExMultipart
//
//  Created by ssg on 2023/09/08.
//

import Foundation

final class ImageUploader: NSObject {
    
    func uploadImageUsingURLSession(model: Codable, completion: @escaping (Error?) -> Void) {
        
        let url = URL(string: "https://webhook.site/3e90fd7a-a647-47da-8af3-e0bac1248fda")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        /// 폼 데이터 생성
        var body = Data()
        
        for (key, value) in model.toDictionary {
            body.appendString("--\(boundary)\r\n")
            
            if let stringValue = value as? String {
                // 이미지
                if let data = stringValue.toBase64Data,
                   data.imageFormat != .unknown {
                    let type = data.imageFormat
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).\(type)\"\r\n")
                    body.appendString("Content-Type: image/\(type)\r\n\r\n")
                    body.append(data)
                    body.appendString("\r\n")
                } else { // 일반 필드
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(stringValue)
                    body.appendString("\r\n")
                }
            } else if let numberValue = value as? NSNumber { // 숫자
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(numberValue.stringValue)
                body.appendString("\r\n")
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        
        
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = TimeInterval(20)
        session.configuration.timeoutIntervalForResource = TimeInterval(20)
        
        let task = session.uploadTask(with: request, from: body) { data, response, error in
            DispatchQueue.main.async {
                if let error {
                    completion(error)
                    return
                }
                // 응답 처리
                completion(nil)
            }
        }
        
        task.delegate = self
        
        task.resume()
    }
}

extension ImageUploader: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("progress = ", Double(bytesSent) / Double(totalBytesSent))
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

extension Encodable {
    /// Codable 을 딕셔너리로 변환
    var toDictionary : [String: Any] {
        guard let object = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return [:] }
        return dictionary
    }
}

extension String {
    var toBase64Data : Data? {
        if let data = self.data(using: .utf8) {
            return Data(base64Encoded:data)
        }
        return nil
    }
}
