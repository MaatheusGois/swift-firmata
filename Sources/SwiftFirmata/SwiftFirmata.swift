import Firmata
import Foundation

public enum DigitalLevel: Int {
    case Low, High
}

public enum PinMode: Int {
    case Input, Output
}

public struct Pin {
    var number: Int
    var mode: PinMode
    public init(number: Int,mode: PinMode){
        self.number = number
        self.mode = mode
    }
}

public enum SwiftFirmataError: Error {
    case couldntConnect
}

public class SwiftFirmata {
    private var firmataC: UnsafeMutablePointer<t_firmata>?
    
    public init(connect: String, baud: Int) throws {
        self.firmataC = firmata_new(strdup(connect))
        
        if self.firmataC == nil {
            throw SwiftFirmataError.couldntConnect
        }
    }
    
    deinit {
        if self.firmataC != nil {
            free(self.firmataC)
        }
    }
    
    public func configure(pin: Pin) {
        firmata_pinMode(firmataC, Int32(pin.number), Int32(pin.mode.rawValue))
    }
    
    public func digitalWrite(pin: Pin, level: DigitalLevel) {
        firmata_digitalWrite(firmataC, Int32(pin.number), Int32(level.rawValue))
    }
    
    public func analogWrite(pin: Pin, width: Int) {
        firmata_analogWrite(firmataC, Int32(pin.number), Int32(width))
    }
}



