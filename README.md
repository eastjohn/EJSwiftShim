# EJSwiftShim
EJSwiftShim is a framework that can be useful for testing. You can verify the function by replacing the actual object method or property with the desired block. Replaceable targets are objects that inherit NSObject or implement them as dynamic.


## USAGE

- Block signature should be:  (self, method_args...) -> method__return__type
- ClassProperty

    ```swift
    let shim = try Shim.createClassTypeShim(target: NSDate.self,      
                                            targetSelector: #selector(getter: NSDate.timeIntervalSinceReferenceDate),  
                                            replacingBlock: {  
                                                _ in  
                                                return expected
                                            } as @convention(block) (Any)->Double )  
    context.addShim(shim)  
    context.run {  
        XCTAssertEqual(expected, NSDate.timeIntervalSinceReferenceDate)  
    }
    ```
- InstanceProperty
    ```swift
    let date = NSDate()  
    let shim = try Shim.createInstanceTypeShim(target: type(of: date),  
                                               targetSelector: #selector(getter: NSDate.timeIntervalSinceReferenceDate),  
                                               replacingBlock: {  
                                                  _ in  
                                                  return expected  
                                               } as @convention(block) (Any)->Double )  
    context.addShim(shim)  
    context.run {  
        XCTAssertEqual(expected, date.timeIntervalSinceReferenceDate)  
    }
    ```
- IntanceMethod
    ```swift
    let expectedError = NSError(domain: "test", code: 10, userInfo: nil)  
    let motion = CMMotionManager()  
    let shim = try Shim.createInstanceTypeShim(target: type(of: motion),  
                                               targetSelector: #selector(CMMotionManager.startDeviceMotionUpdates(to:withHandler:)),  
                                               replacingBlock: {  
                                                  (_, queue:OperationQueue, handler: CMDeviceMotionHandler) in  
                                                  handler(nil, expectedError)  
                                               } as @convention(block) (Any, OperationQueue, CMDeviceMotionHandler)->() )  
      
    context.addShim(shim)  
    context.run {  
        motion.startDeviceMotionUpdates(to: OperationQueue.current!) { (motion, error) in  
            XCTAssertEqual(expectedError, error! as NSError)  
        }  
    }
    ```


## Installation

- Swift Package Manager
    Set the swift packageManager in the xcode project or add the following code to the Package.swift file.
    ```swift
    dependencies: [
        .package(url: "https://github.com/eastjohn/EJSwiftShim.git", .upToNextMajor(from: "0.2.0"))
    ]
    ```
