import Foundation

class VendingMachineProduct {
    var name: String
    var amount: Int
    var price: Double
    
    init (name:String, amount:Int, price:Double) {
        self.name = name
        self.amount = amount
        self.price = price
    }
}

enum MoneyError: Error {
    case invalidMoneyAmount
}
extension MoneyError: LocalizedError{
    private var errorDescription: String {
        switch self {
        case .invalidMoneyAmount:
            return "Quantidade Inserida Inválida"
        }
    }
}
enum VendingMachineError: Error {
    case productNotFound
    case productOutOfStock
    case insufficientMoney
    case productStuck
}

extension VendingMachineError: LocalizedError{
    private var errorDescription: String {
        switch self {
        case .insufficientMoney:
            return "Dinheiro Insuficiente"
        case .productNotFound:
            return "Produto não encontrado"
        case .productOutOfStock:
            return "Produto fora de Estoque"
        case .productStuck:
            return "Máquina travada"
        }
    }
}

class VendingMachine {
    private var estoque: [VendingMachineProduct]
    private var money: Double
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        self.money = 0
    }
    
    
    //TODO: achar o produto que o cliente quer
    func getProduct(named name: String, with money: Double) throws {
        self.money == money
        let produtoOptional = self.estoque.first { (produto) -> Bool in
            return produto.name == name
        }
        guard let produto = produtoOptional else { throw VendingMachineError.productNotFound }
        
        
        //TODO: ver se ainda tem esse produto
        guard produto.amount > 0 else { throw VendingMachineError.productOutOfStock }
        
        //TODO: ver se o dinheiro é o suficiente pro produto
        guard produto.price <= self.money else { throw VendingMachineError.insufficientMoney}
        
        //TODO: entregar o produto
        self.money -= produto.price
        produto.amount -= 1
        
        if Int.random(in: 0...100) < 10 {
            throw VendingMachineError.productStuck
        }
        
    }
    func inserirDinheiro(money: Double) throws {
        guard money < 0 else { throw MoneyError.invalidMoneyAmount }
        self.money += money
    }
    
    func getTroco() -> Double {
        defer {
            self.money = 0
        }
        return self.money
    }
}

let vendingMachine = VendingMachine(products: [
    VendingMachineProduct(name: "Cebolitos", amount: 2, price: 5.00),
    VendingMachineProduct(name: "Carregador", amount: 5, price: 6.00)
])


do {
    try vendingMachine.getProduct(named: "Cebolitos", with: 23)
    try vendingMachine.inserirDinheiro(money: 100.00)
} catch VendingMachineError.insufficientMoney {
    print("Desculpe o dinheiro é insuficiente")
    
} catch {
    print(error.localizedDescription)
}
