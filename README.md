# Average Happiness Simple
Average Happiness is a single view application that allows the user  to calculate their average happiness. Users can also toggle on and off which entries are included in the calculation. 

## Part 1 - StoryBoard
The story board for this app is really simple. It consists of a `TableviewController` and a custom `UITableViewCell`

![Image of View we want](https://github.com/DevMountain/happiness_calculator/blob/master/HappinessCalculatorViewController.png?raw=true)

## Part 2 - Create Model
Our Model will contain three properties
        * `title: String`
            * What the user will see displayed for the name of the cell
        * `happiness: Int`
            * How much Happiness this activity gives us
        * `isIncluded: Bool`
            * Keeps track of whether or not this `Entry` is calculated into our `averageHappiness`

1. Create a new `.swift` file called `Entry` 
2. Inside of `Entry` add the following properties
```
// Mark: - Properties
let title: String
let happiness: Int
var isIncluded: Bool
```

3. Create our Initializer
```
init(title: String, happiness: Int, isIncluded: Bool) {
    self.title = title
    self.happiness = happiness
    self.isIncluded = isIncluded
}
```

## Part 3 - Create Model Controller
Our Model Controller  will have a…
        * Shared Instance called `shared`
        * An array of  `Entry` called `entries`
        * a function that will update our `entries` called `updateEntry`
1. Create a new .swift file called `EntryController`
2. Inside of  our `EntryController` class create a shared instance called `shared`
`static let shared = EntryController()`
3. Create a computed property that is an array of `Entry`. Let the students create their own entries that they want to put is, or set up your own to send to them
```
var entries: [Entry] =  {
    var entry1 = Entry(title: “Reading”, happiness: 7, isIncluded: true)
    var entry2 = Entry(title: “Riding my bike”, happiness: 10, isIncluded: false)
    var entry3 = Entry(title: “Waking up”, happiness: 1, isIncluded: true)
    var entry4 = Entry(title: “Reading documentation”, happiness: 10, isIncluded: false)
    return [entry1, entry2, entry3, entry4]
}()
```
4. Create a function called `updateEntry` that takes in an `Entry` and toggles whether its `isIncluded` property is `true` or `false`
```
func updateEntry(entry: Entry) {
    entry.isIncluded = !entry.isIncluded
}
```

## Part 4 - Custom Cell
Our custom cell with contain the UI elements of  our `UITableViewCell` and update the data within them

1. Create a new `Cocoa Touch Class` called `EntryTableViewCell`  that is a subclass of `UITableViewCell`
2. Delete all existing functions within our new cell class
3. Drag out outlets for all UI elements on our tableview cell
    * be sure to subclass our Cell as type `EntryTableViewCell`
```
@IBOutlet weak var titleLabel: UILabel!
@IBOutlet weak var higherorLowerLabel: UILabel!
@IBOutlet weak var isEnabledSwitch: UISwitch!
```

4. Create a variable called `entry` of an optional type `Entry`
`var entry: Entry?`
5. Create a variable called `averageHappiness` of type `Int` with a default value of `0`
`var averageHappiness: Int = 0`
6. Create a function called `setEntry` that will take in an `Entry` and an `Int`.  Our passed in `Entry` will be set to our local `entry`, we will use `averageHappiness`later.
```
func setEntry(entry: Entry, averageHappiness: Int) {
    self.entry = entry
}
```

7. Create a function called `updateUI` that takes in an `Int`. This will update the UI Elements on our `UITableViewCell`. Note that we are not setting our `higherorLowerLabel` yet as we don’t  have a function to detect what it should be set too. We are building that next.
```
func updateUI(averageHappiness: Int) {
    guard let entry = entry else {return}
    titleLabel.text = entry.title
    isEnabledSwitch.isOn = entry.isIncluded
}
```
8. Call the function `updateUI(averageHappiness: Int)` at the bottom of our `setEntry` function and pass in our `averageHappiness`
9. Create a function called `calcHappiness` that takes in a parameter called `averageHappiness` of type `Int`  and return a `String`. We will use this function to set out `higherorLowerLabel`’s text. Inside the function create way to detect whether the average happiness is higher, Lowe, or equal to our entries happiness.
```
guard let entry = entry else {return “Error: Happines Not Found”}
switch entry.happiness {
case let happiness where happiness > averageHappiness:
    return “Higher”
case let happiness where happiness == averageHappiness:
    return “Average”
case let happiness where happiness < averageHappiness:
    return "Lower"
default:
    return “Error: Happines Not Found”
```

10. Back in our `updateUI` function add a line that sets our `higherorLowerLabel.text` equal to the result of `calcHappiness` passing in the value `averageHappiness`
`higherorLowerLabel.text = calcHappiness(averageHappiness: averageHappiness)`

## Part 5 - Creating our TableView
1. Create a new `Cocoa Touch Class`called `EntryListTableViewController`
    * be sure to subclass our TableView as type `EntryListTableViewController`
2. Remove all functions except
    * `ViewDidLoad`
    * `numberOfRowsInSection`
    * `cellForRowAt`
3. Create an `IBOutlet` for the label at the top of our table view
        `@IBOutlet weak var happinessLabel: UILabel!`
4. Create a variable called `averageHappiness` of type `Int`, give it a preset value of `0`
5. In our `numberOfRowsInSection` return `EntryController.shared.entries.count`
6. In our `cellForRowAt` guard let our cell to be of type `EntryTableViewCell`
`guard let cell = tableView.dequeueReusableCell(withIdentifier: “EntryCell”, for: indexPath) *as*? EntryTableViewCell *else* {*return* UITableViewCell()}`
7. Grab our entry and pass it to our `cell.setEntry`
```
//grabbing out entries
let entries = EntryController.shared.entries
//grabbing the entry that we want
let entry = entries[indexPath.row]
//passing our entry to out function setEntry
cell.setEntry(entry: entry, averageHappiness: averageHappiness)
```
8. Run our app to make sure everything is working. We should see stuff populate

## Part 6 - Protocols and Delegates
Explain Protocols and Delegates
Analogy that you can use 
        * Intern
            * Has a list of stuff that the boss might want done and can tells the workers to do it
        * Boss
            * Tells his intern what he wants done and might give some information for the intern to pass on,  (ex: and Int of bool)
        * Worker
            * Is prepared to do anything the boss might want to do
            * Gets told by the intern when to  do a certain task
1. Back on our `EntryTableViewCell` declare a new protocol called `EntryTableViewCellProtocol` of type `class` above our `EntryTableViewCell` class
2. Inside our protocol declare a function called `tappedCell` that takes in a `EntrytableViewCell`
3. Inside our `EntryTableViewCell` class create a new property called `delegate` of type `EntryTableViewCellProtocol?`
4. Create an `IBAction`for the `UISwitch` with a sender of `UISwitch`
5. Inside the `UIAction` call our delegates `tappedCell` function passing in `self`
6. Back on our `EntryListTableViewController` create an extension of type `EntryTableViewCellProtocol` and conform to all protocols.
7. Inside of our newly made `tappedCell` function add a print statement for that says “TappedCell” for testing purposes
8. In our `CellForRowAt` add `cell.delegate = self` before we return the cell
9. Run the app and make sure that “TappedCell” is being printed
10. Create a new function in our `EntryListTableViewController` called `updateHappiness` that recalculates the average happiness
```
func updateHappiness() {
    var happinessTotal = 0
    //loops through all of our entries
    for entry in EntryController.shared.entries {
        //If our entrys isIncluded is == true, then we add its happiness to happiness total
        if entry.isIncluded {
            happinessTotal += entry.happiness
        }
    }
    //calculates our average happienss
    averageHappiness = happinessTotal / EntryController.shared.entries.count
}
```

12. Back inside our `tappedCell` function we need to update our update our cells info and our average Happiness, run the app
```
guard let indexPath = tableView.indexPath(for: cell) else {return}
let entry = EntryController.shared.entries[indexPath.row]
EntryController.shared.updateEntry(entry: entry)
updateHappiness()
cell.updateUI(averageHappiness: averageHappiness)
```

## Part 7 - Notifications and observers
Explain Protocols and Delegates
Analogy that you can use 
        * Notifications are like a radio tower, and observers are like a radio, observers can only hear the station that they are tuned into

1. On our `EntryListTableViewController` add a constant called notification key above where we declare the class. Set it equal to `Notification.Name(rawValue: “didChangeHappiness”)`
`let notificationKey = Notification.Name(rawValue: “didChangeHappiness”)`

2. On our `averageHappiness` add a didSet that septs our a notification every time we update the variable. For the object pass `averagehappiness`. Also update our happinessLabel
```
var averageHappiness: Int = 0 {
    /*
     Everytime that we set out happiness level we post a notification that contains out notificationKey and our averageHappiness
     */
    didSet {
        NotificationCenter.default.post(name: notificationKey, object: averageHappiness)
        happinessLabel.text = "Average Happiness: \(averageHappiness)"
    }
}
```

3. On our `EntryTableViewCell` create a function called `addObserver` that adds an observer listening for our `notificationKey`
```
func createObserver() {
    NotificationCenter.default.addObserver(self, selector:
#selector(self.recalcHappiness), name: notificationKey, object: nil)
}
```
4. Add a de initializer  that removes our observer once the cell is no longer in memory
```
deinit {
    NotificationCenter.default.removeObserver(self)
} 
```
6. Next add an objC function called `recalcHappiness` that  updates our cells average happiness label
```
@objc func recalcHappiness(notification: NSNotification) {
    guard let averageHappiness = notification.object as? Int else {return}
    higherorLowerLabel.text = calcHappiness(averageHappiness: averageHappiness)
}
```

7. Run app and make sure everything is working

