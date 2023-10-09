// Helper Functions
#let monthName(n, i18n, display: "short") = {
    n = int(n)
    let month = ""

    if n == 1 { month = i18n.time.months.jan }
    else if n == 2 { month = i18n.time.months.feb }
    else if n == 3 { month = i18n.time.months.mar }
    else if n == 4 { month = i18n.time.months.apr }
    else if n == 5 { month = i18n.time.months.may }
    else if n == 6 { month = i18n.time.months.jun }
    else if n == 7 { month = i18n.time.months.jul }
    else if n == 8 { month = i18n.time.months.aug }
    else if n == 9 { month = i18n.time.months.sep }
    else if n == 10 { month = i18n.time.months.oct }
    else if n == 11 { month = i18n.time.months.nov }
    else if n == 12 { month = i18n.time.months.dec }
    else { month = none }
    if month != none {
        if display == "short" {
            let shortened = ""
            
            let i = 0
            for char in month {
                if i < 3 {
                    shortened = shortened + char
                }
                i += 1
            }

            shortened
        } else {
            month
        }
    }
}

#let strpDate(isodate) = {
    let date = ""
    date = datetime(
        year: int(isodate.slice(0, 4)),
        month: int(isodate.slice(5, 7)),
        day: int(isodate.slice(8, 10))
    )
    date
}
