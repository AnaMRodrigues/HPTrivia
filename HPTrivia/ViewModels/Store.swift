//
//  Store.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 27/03/26.
//

import StoreKit

@MainActor
@Observable
class Store {
    var products: [Product] = []
    var purchased = Set<String>()
    
    private var updates: Task<Void, Never>? = nil
    
    // Load available products
    func loadProducts() async {
        do {
            products = try await Product.products(for: ["hp4", "hp5", "hp6", "hp7"])
            products.sort {
                $0.displayName < $1.displayName
            }
        } catch {
            print("Unable to load products: \(error)")
        }
    }
    
    // Purchase a product
    func purchase (_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
            //Purchase successful, but now we have to verify receipt and transaction
            case .success(let verificationResult):
                switch verificationResult {
                case .unverified(let signedType, let verificationError):
                    print("Error on \(signedType): \(verificationError)")
                    
                case .verified(let signedType):
                    purchased.insert(signedType.productID)
                    
                    await signedType.finish()
                }
            
            // User cancelled or parent disaproved child's purchase request
            case .userCancelled:
                break
                
            // Waiting for some sort of approval
            case .pending:
                break
                
            @unknown default:
                break
            }
        } catch {
            print("Unable to purchase product: \(error)")
        }
    }
    
    // Check for purchased products
    
    // Connect with App Store to watch for purchase and transaction updates
}
