// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import ArgumentParser


struct TotalDeliveryCost: ParsableCommand {
    static var configuration = CommandConfiguration(
           abstract: "A utility for calculating the total delivery cost."
       )
    @Argument(help: "Base delivery cost.")
    var baseDeliveryCost: Double
    
    @Argument(help: "Number of packages.")
    var numberOfPackages: Int
    
    @Argument(help: "Package details in the format 'ID Weight Distance OfferCode'.")
    var packageStrings: [String]

    func run() throws {
        
        if packageStrings.count != numberOfPackages*4 {
            throw ValidationError("The number of packages provided does not match the expected count.")
        }
        var packages = [Package]()
        for index in stride(from: 0, to: packageStrings.count, by: 4) {
            guard index + 3 < packageStrings.count else {
                print("Incomplete group at index \(index)")
                break
            }
            
            let group = Array(packageStrings[index..<index+4])
           
            guard let package = Package(from: group) else {continue}
            packages.append(package)
            
        }
        
      
       // Load offer codes
        let offerCodes = OfferCodes.loadOfferCodes()
    
        for package in packages {
            let discount = calculateDiscount(for: package, with: offerCodes)
            let (totalCost,discountPrice) = calculateTotalCost(for: package, baseCost: baseDeliveryCost, discount: discount)
           
            print("\(package.id) \(Int(discountPrice)) \(Int(totalCost))")
        }
    }
    private func calculateDiscount(for package: Package, with offerCodes: [String: OfferCode]) -> Double {
            guard let offerCode = offerCodes[package.offerCode] else {
                return 0.0
            }
            return offerCode.getDiscountPercentage(for: package)
        }

    private func calculateTotalCost(for package: Package, baseCost: Double, discount: Double) -> (Double, Double) {
            let deliveryCost = baseCost + (package.weight * 10) + (package.distance * 5)
            return (deliveryCost - (deliveryCost * discount),deliveryCost * discount)
        }
}
                  
struct Package {
    var id: String
    var weight: Double
    var distance: Double
    var offerCode: String
    
    init?(from string: [String]) {
       
       
        guard string.count == 4,
              let weight = Double(string[1]),
              let distance = Double(string[2]) else {
            return nil
        }
        self.id = string[0]
        self.weight = weight
        self.distance = distance
        self.offerCode = string[3]
    }
}

struct OfferCode {
    var discount: Double
    var minWeight: Double
    var maxWeight: Double
    var minDistance: Double
    var maxDistance:Double
   

    func getDiscountPercentage(for package: Package) -> Double {
           if package.weight >= minWeight && package.weight <= maxWeight &&
              package.distance >= minDistance && package.distance <= maxDistance {
               return discount
           }
           return 0.0
       }
}

class OfferCodes {
    static func loadOfferCodes() -> [String: OfferCode] {
        return [
            "OFR001": OfferCode(discount: 0.10, minWeight: 70.00, maxWeight: 200.00, minDistance:0.00 ,maxDistance:200.00),
            "OFR002": OfferCode(discount: 0.07, minWeight: 100.00, maxWeight: 250.00, minDistance:50.00 ,maxDistance:150.00),
            "OFR003": OfferCode(discount: 0.05, minWeight: 10.00, maxWeight: 150.00, minDistance:50.00 ,maxDistance:250.00)
        ]
    }
}


TotalDeliveryCost.main()
