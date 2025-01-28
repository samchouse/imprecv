// Helper Functions
#let monthname(n, strings, display: "short") = {
    n = int(n)
    let month = ""

    if n == 1 { month = strings.january }
    else if n == 2 { month = strings.february }
    else if n == 3 { month = strings.march }
    else if n == 4 { month = strings.april }
    else if n == 5 { month = strings.may }
    else if n == 6 { month = strings.june }
    else if n == 7 { month = strings.july }
    else if n == 8 { month = strings.august }
    else if n == 9 { month = strings.september }
    else if n == 10 { month = strings.october }
    else if n == 11 { month = strings.november }
    else if n == 12 { month = strings.december }
    else { month = none }
    if month != none {
        if display == "short" {
            month = month.codepoints().slice(0, 3).join()
        } else {
            month
        }
    }
    month
}

#let strpdate(isodate, strings) = {
    let date = ""
    if lower(isodate) != "present" {
        let year = int(isodate.slice(0, 4))
        let month = int(isodate.slice(5, 7))
        let day = int(isodate.slice(8, 10))
        let monthName = monthname(month, strings, display: "short")
        date = datetime(year: year, month: month, day: day)
        date = monthName + " " + date.display("[year repr:full]")
    } else if lower(isodate) == "present" {
        date = strings.present
    }
    return date
}

#let daterange(start, end) = {
    if start != none and end != none [
        #start #sym.dash.en #end
    ]
    if start == none and end != none [
        #end
    ]
    if start != none and end == none [
        #start
    ]
}
