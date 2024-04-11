struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    init (amount a: Int, currency c: String){
        amount = a
        currency = c
    }
    
    
    func convert (_ currencyOutput: String) -> Money{
        var output = 0
        if currencyOutput != "USD"{ //USD -> other Currency
            if currencyOutput == "GBP" { //USD -> GBP
                output = (amount / 2)
            }
            else if currencyOutput == "EUR" { //USD -> EUR
                output = ((amount * 2)/3)
            }
            else if currencyOutput == "CAN" { //USD -> CAN
                output = ((amount * 4)/5)
            }
        } else { // Other Currency -> USD
            if currency == "GBP"{ //GBP -> USD
                output = (amount * 2)
            }
            else if currency == "EUR"{ //EUR -> USD
                output = ((amount * 3)/2)
            }
            else if currency == "CAN"{ //CAN -> USD
                output = ((amount * 5)/4)
            }
        }
        return Money(amount: output, currency: currencyOutput)
        //currency = currencyOutput
        //return output
    }
    
    func add (_ more: Money) -> Money{
        return Money(amount: amount + more.amount, currency: currency)
    }
    
    func subtract (_ subt: Money)  -> Money{
        return Money(amount: amount - subt.amount, currency: currency)
    }
    
}

////////////////////////////////////
// Job
//
public class Job {
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title: String
    var type: JobType
    
    init(title ti: String, type: JobType){
        title = ti
        switch type {
        case . Salary(let wage):
            self.type = .Salary(max(0, wage))
        case .Hourly(let wage):
            self.type = .Hourly(max(0.0, wage))
        }
    }
        
    func calculateIncome(_ hours: Int = 2000) -> Int{
        switch type {
        case .Hourly(let wage):
            return Int(Double(hours) * wage)
        case .Salary(let wage):
            return Int(wage)
        }
    }
    
    func raise(byAmount: Double){
        switch type {
        case .Hourly(let wage):
            type = .Hourly(wage + byAmount)
        case .Salary(let wage):
            type = .Salary(wage + UInt(byAmount))
        }
    }
    
    func raise(byPercent: Double){
        switch type {
        case .Hourly(let wage):
            type = .Hourly(wage * (byPercent + 1))
        case .Salary(let wage):
            type = .Salary(UInt(Double(wage) * (byPercent + 1)))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName : String
    var lastName : String
    var age : UInt
    //var job : String? = nil
    //var spouse: String? = nil
    private var _job: Job?
    private var _spouse: Person?
    
    init(firstName f : String, lastName l : String, age a : UInt){
        firstName = f
        lastName = l
        age = a
//        self._job = nil
//        self._spouse = nil
    }
    
    var job: Job? {
        get {
            return self.job
        }
        set{
            if age >= 16 {
                self.job = newValue
            } else {
                self.job = nil
            }
        }
    }
    
    var spouse: Person? {
        get {
            return self.spouse
        }
        set {
            if age >= 18 {
                self.spouse = newValue
            } else{
                self.spouse = nil
            }
        }
    }
    
    func toString () -> String{
        let jobName = job != nil ? job!.title : "nil"
        let spouseFName = spouse != nil ? spouse!.firstName : "nil"
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobName) spouse:\(spouseFName)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    
    init(spouse1: Person, spouse2: Person){
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        self.members = [spouse1, spouse2]
    }
    
    func haveChild(_ child: Person) -> Bool{
//        if members.age >= 21{
//            self.members.append(child)
//            return true
//        }
//        return false
        if((members[0].age > 21) || (members[1].age > 21)) {
            members.append(child)
            return true
        }
        return false
    }
    
    func householdIncome() -> Int{
        var totalIncome = 0
        for person in members {
            totalIncome += Int(person.job?.calculateIncome() ?? 0)
        }
        return totalIncome
    }

}
