import UIKit


protocol CalendarViewControllerProtocol {
    func getDeadlineTime(time:Date)
}

class CalendarViewController: BaseViewController {
    
    let backButton = UIButton()
    let nextButton = UIButton()
    let horizontalDaysStackView = UIStackView()
    let topDataLabel = UILabel()
    var daysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    let calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let months = ["January", "February", "March", "April","May","June","July","August","September","Octeber","November","December"]
    let daysOfMonth = ["Monday","Tuesday","Wednesday","Thursday", "Friday","Saturday","Sunday"]
    var currentYear = CalendarData.shared.getYear()
    var currentMonth = CalendarData.shared.getMonth()
    var weekday = CalendarData.shared.getWeekday()
    var day = CalendarData.shared.getDay()
    var numberOfEmptyBox = Int()
    var nextNumberOfEmptyBox = Int()
    var previousNumberOfEmptyBox = 0
    var direction = 0
    var positionIndex = 0
    var leapYearCounter = 2
    var dayCounter = 0
    var presenter:(ViewToPresenterCalendarProtocol & InteractorToPresenterCalendarProtocol)?
    var calendarDelegate:CalendarViewControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        if weekday == 0 {
            weekday = 7
        }
        self.getStartDateDayPosition()
    }
}

extension CalendarViewController {
    override func addViews() {
        super.addViews()
        self.view.addSubview(topDataLabel)
        self.view.addSubview(backButton)
        self.view.addSubview(nextButton)
        self.view.addSubview(calendarCollectionView)
        self.view.addSubview(horizontalDaysStackView)
    }
    
    override func configure() {
        super.configure()
        
        topDataLabel.translatesAutoresizingMaskIntoConstraints = false
        topDataLabel.textColor = UIColor(named: Resources.Titles.labelAndTintColor)
        topDataLabel.font = .systemFont(ofSize: 20)
        topDataLabel.text = "\(months[currentMonth]) \(currentYear)"
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.backgroundColor = .clear
        backButton.tintColor = UIColor(named: Resources.Titles.labelAndTintColor)
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextButton.backgroundColor = .clear
        nextButton.tintColor = UIColor(named: Resources.Titles.labelAndTintColor)
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        
        let calendarFlowLayout = UICollectionViewFlowLayout.init()
        calendarCollectionView.setCollectionViewLayout(calendarFlowLayout, animated: false)
         calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
         calendarCollectionView.backgroundColor = .clear
         calendarCollectionView.dataSource = self
         calendarCollectionView.delegate = self
        calendarCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: Resources.Cells.calendarIdentefier)
        
        horizontalDaysStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalDaysStackView.axis = .horizontal
        horizontalDaysStackView.distribution = .equalSpacing
        horizontalDaysStackView.spacing = 3
        horizontalDaysStackView.alignment = .center
        
        for day in 0...daysOfMonth.count - 1 {
            let dayLabel = UILabel()
            dayLabel.translatesAutoresizingMaskIntoConstraints = false
            let dayText = daysOfMonth[day]
            let startIndex = dayText.index(dayText.startIndex, offsetBy: 0)
            let endIndex = dayText.index(dayText.startIndex, offsetBy: 2)
            let trimmingDayText = dayText[startIndex..<endIndex]
            dayLabel.text = String(trimmingDayText)
            dayLabel.textColor = UIColor(named: Resources.Titles.labelAndTintColor)
            dayLabel.font = .systemFont(ofSize: 15)
            horizontalDaysStackView.addArrangedSubview(dayLabel)
        }
    }
    
    override func layoutViews() {
        super.layoutViews()
        NSLayoutConstraint.activate([
            topDataLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            topDataLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 20),
            backButton.centerYAnchor.constraint(equalTo: topDataLabel.centerYAnchor),
            backButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor,constant: 50),
            backButton.widthAnchor.constraint(equalToConstant: backButton.frame.width + 50),
            backButton.heightAnchor.constraint(equalToConstant: backButton.frame.width + 50),
            nextButton.centerYAnchor.constraint(equalTo: topDataLabel.centerYAnchor),
            nextButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor,constant: -50),
            nextButton.widthAnchor.constraint(equalTo: backButton.widthAnchor),
            nextButton.heightAnchor.constraint(equalTo: backButton.heightAnchor),
            calendarCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            calendarCollectionView.topAnchor.constraint(equalTo: horizontalDaysStackView.bottomAnchor, constant: 20),
            calendarCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            calendarCollectionView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100),
            horizontalDaysStackView.topAnchor.constraint(equalTo: topDataLabel.bottomAnchor, constant: 20),
            horizontalDaysStackView.leftAnchor.constraint(equalTo: calendarCollectionView.leftAnchor,constant: 5),
            horizontalDaysStackView.rightAnchor.constraint(equalTo: calendarCollectionView.rightAnchor,constant: -5)
        ])
    }
}

extension CalendarViewController {
    func getStartDateDayPosition() {
        switch direction{
        case 0:
            numberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter>0 {
                numberOfEmptyBox = numberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if numberOfEmptyBox == 0 {
                    numberOfEmptyBox = 7
                }
            }
            if numberOfEmptyBox == 7 {
                numberOfEmptyBox = 0
            }
            positionIndex = numberOfEmptyBox
        case 1...:
            nextNumberOfEmptyBox = (positionIndex + daysInMonths[currentMonth])%7
            positionIndex = nextNumberOfEmptyBox
            
        case -1:
            previousNumberOfEmptyBox = (7 - (daysInMonths[currentMonth] - positionIndex)%7)
            if previousNumberOfEmptyBox == 7 {
                previousNumberOfEmptyBox = 0
            }
            positionIndex = previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
}

extension CalendarViewController {
    @objc private func nextButtonTapped(_ sender:UIButton) {
        switch months[currentMonth] {
        case "December":
            
            direction = 1
            
            currentYear += 1
            currentMonth = 0
            
            if leapYearCounter  < 5 {
                leapYearCounter += 1
            }
            
            if leapYearCounter == 4 {
                daysInMonths[1] = 29
            }
            
            if leapYearCounter == 5{
                leapYearCounter = 1
                daysInMonths[1] = 28
            }
            self.getStartDateDayPosition()
            
            
            topDataLabel.text = "\(months[0]) \(currentYear)"
        default:
            
            direction = 1
            self.getStartDateDayPosition()
            
            currentMonth += 1
            topDataLabel.text = "\(months[currentMonth]) \(currentYear)"
        }
        DispatchQueue.main.async {
            self.calendarCollectionView.reloadData()
        }
    }
    
    @objc private func backButtonTapped(_ sender:UIButton) {
        switch months[currentMonth] {
        case "January":
            
            direction = -1
            
            currentYear -= 1
            currentMonth = 11
            
            if leapYearCounter > 0{
                leapYearCounter -= 1
            }
            if leapYearCounter == 0{
                daysInMonths[1] = 29
                leapYearCounter = 4
            }else{
                daysInMonths[1] = 28
            }
            
            self.getStartDateDayPosition()
            
            topDataLabel.text = "\(months[currentMonth]) \(currentYear)"
        default:
            
            direction = -1
            
            currentMonth -= 1
            
            self.getStartDateDayPosition()
            topDataLabel.text = "\(months[currentMonth]) \(currentYear)"
        }
        DispatchQueue.main.async {
            self.calendarCollectionView.reloadData()
        }
    }
}


//MARK: - Collection methods
extension CalendarViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch direction{
        case 0:
            return daysInMonths[currentMonth] + numberOfEmptyBox
        case 1...:
            return daysInMonths[currentMonth] + nextNumberOfEmptyBox
        case -1:
            return daysInMonths[currentMonth] + previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.Cells.calendarIdentefier, for: indexPath) as? CalendarCollectionViewCell {
            
            cell.backgroundColor = UIColor.clear
            cell.numberLabel.textColor = UIColor(named: Resources.Titles.labelAndTintColor)
            
            if cell.isHidden{
                cell.isHidden = false
            }
            
            switch direction {      //the first cells that needs to be hidden (if needed) will be negative or zero so we can hide them
            case 0:
                cell.numberLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
            case 1:
                cell.numberLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
            case -1:
                cell.numberLabel.text = "\(indexPath.row + 1 - previousNumberOfEmptyBox)"
            default:
                fatalError()
            }
            
            if Int(cell.numberLabel.text!)! < 1{ //here we hide the negative numbers or zero
                cell.isHidden = true
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
            
            if cell.numberLabel.textColor == .red {
                cell.numberLabel.textColor = UIColor(named: Resources.Titles.labelAndTintColor)
                return
            }
            cell.numberLabel.textColor = .red
            guard let cellDay = cell.numberLabel.text else {return}
            guard let correctDay = Int(cellDay) else {return}
//            correctDay += 1
            let cellDate = "\(currentYear)-\(currentMonth + 1)-\(correctDay)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let cellDateConverted = dateFormatter.date(from: cellDate)!
            print(cellDateConverted)
            calendarDelegate?.getDeadlineTime(time: cellDateConverted)
            let todayDate = Date()
            print(todayDate)
            
            let calendar = NSCalendar.current
            let todayDay = calendar.component(.day, from: todayDate)
            let todayMonth = calendar.component(.month, from: todayDate)
            let todayYear = calendar.component(.year, from: todayDate)
            let cellDayCalendar = calendar.component(.day, from: cellDateConverted)
            let cellMonth = calendar.component(.month, from: cellDateConverted)
            let cellYear = calendar.component(.year, from: cellDateConverted)
            print(todayDay)
            print(cellDayCalendar)
            print(todayMonth)
            print(cellMonth)
            print(todayYear)
            print(cellYear)
            print(todayDay == cellDayCalendar && todayMonth == cellMonth && todayYear == cellYear)
            
            let todayDateFormatter = DateFormatter()
            todayDateFormatter.dateStyle = .short
            let today = todayDateFormatter.string(from: todayDate)
            print(today)
            let test = todayDateFormatter.string(from: cellDateConverted)
            print(test)
            print(today == test)
            
            
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension CalendarViewController:PresenterToViewCalendarProtocol {
    
}
