// Helper Functions
#let monthname(n, strings, display: "short") = {
    n = int(n)
    let month = ""

    if n == 1 { 
        month = strings.january
        if display == "short" { month = month.codepoints().slice(0, strings.abbreviate.january).join() }
    } else if n == 2 { 
        month = strings.february
        if display == "short" { month = month.codepoints().slice(0, strings.abbreviate.february).join() }
    } else if n == 3 { 
        month = strings.march
        if display == "short" { month = month.codepoints().slice(0, strings.abbreviate.march).join() }
    } else if n == 4 { 
        month = strings.april
        if display == "short" { month = month.codepoints().slice(0, strings.abbreviate.april).join() }
    } else if n == 5 { 
        month = strings.may
        if display == "short" { month = month.codepoints().slice(0, strings.abbreviate.may).join() }
    } else if n == 6 { 
        month = strings.june
        if display == "short" { month = month.codepoints().slice(0, strings.abbreviate.june).join() }
    } else if n == 7 { 
        month = strings.july
        if display == "short" { month = month.codepoints().slice(0, strings.abbreviate.july).join() }
    } else if n == 8 { 
        month = strings.august
        if display == "short" { month = month.codepoints().slice(0, strings.abbreviate.august).join() }
    } else if n == 9 { 
        month = strings.september
        if display == "short" { month = month.codepoints().slice(0, strings.abbreviate.september).join() }
    } else if n == 10 { 
        month = strings.october
        if display == "short" { month = month.codepoints().slice(0, strings.abbreviate.october).join() }
    } else if n == 11 {
        month = strings.november
        if display == "short" { month = month.codepoints().slice(0, strings.abbreviate.november).join() }
    } else if n == 12 { 
        month = strings.december
        if display == "short" { month = month.codepoints().slice(0, strings.abbreviate.december).join() }
    } else { month = none }

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
