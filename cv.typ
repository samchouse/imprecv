#import "util.typ"

#let getI18n(options) = {
    let data = yaml("i18n.yml")

    if options.lang == "en" {
        data.en
    } else if options.lang == "fr" {
        data.fr
    }
}

#let setRules(doc, options) = {
    set page(
        paper: "us-letter",
        numbering: "1 / 1",
        number-align: center,
        margin: 1.25cm,
    )

    set text(
        font: options.bodyFont,
        size: options.fontSize,
        hyphenate: false,
        lang: options.lang,
    )

    set par(
        leading: options.lineSpacing,
        justify: true,
    )

    doc
}

#let showRules(doc, options) = {
    show heading.where(
        level: 1,
    ): it => block(width: 100%)[
        #set text(font: options.headingFont, size: 1.5em, weight: "bold")
        #upper(it.body)
        #v(2pt)
    ]

    show heading.where(
        level: 2,
    ): it => block(width: 100%)[
        #set align(left)
        #set text(font: options.headingFont, size: 1em, weight: "bold")
        #upper(it.body)
        #v(-0.75em) #line(length: 100%, stroke: 1pt + black) // Draw a line
    ]

    doc
}

// Address
#let addressText(info, options) = {
    if options.showAddress {
        block(width: 100%)[
            #info.personal.location.city, #info.personal.location.region, #info.personal.location.country #info.personal.location.postalCode
            #v(-4pt)
        ]
    } else {none}
}

// Arrange the contact profiles with a diamond separator
#let contactText(info, options) = block(width: 100%)[
    // Contact Info
    // Create a list of contact profiles
    #let profiles = (
        box(link("mailto:" + info.personal.email)),
        if options.showNumber {box(link("tel:" + info.personal.phone))} else {none},
        box(link(info.personal.url)[#info.personal.url.split("//").at(1)]),
    )

    // Remove any none elements from the list
    #if none in profiles {
        profiles.remove(profiles.position(it => it == none))
    }

    // Add any social profiles
    #if info.personal.profiles.len() > 0 {
        for profile in info.personal.profiles {
            profiles.push(
                box(link(profile.url)[#profile.url.split("//").at(1)])
            )
        }
    }

    // #set par(justify: false)
    #set text(font: options.bodyFont, weight: "medium", size: options.fontSize * 1)
    #pad(x: 0em)[
        #profiles.join([#sym.space.en #sym.diamond.filled #sym.space.en])
    ]
]

// Create layout of the title + contact info
#let cvHeading(info, options) = {
    align(center)[
        = #info.personal.name
        #addressText(info, options)
        #contactText(info, options)
        // #v(0.5em)
    ]
}

#let cvSummary(info, i18n) = {
    if info.summary != none [
        == #i18n.summary

        #info.summary
    ]
}

// Education
#let cvEducation(info, i18n) = {
    if info.education != none [
        == #i18n.education.title

        #for edu in info.education {
            // Parse ISO date strings into datetime objects
            let start = util.strpDate(edu.startDate)
            let end = util.strpDate(edu.endDate)

            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(edu.url)[#edu.institution]* #h(1fr) *#edu.location* \
                // Line 2: Degree and Date Range
                #text(style: "italic")[#edu.studyType#if edu.area != none [ in #edu.area]] #h(1fr)
                #util.monthName(start.month(), i18n, display: "short") #start.year() #sym.dash.en #util.monthName(end.month(), i18n, display: "short") #end.year() \
                // Bullet points
                - *#i18n.education.honors*: #edu.honors.join(", ")
                - *#i18n.education.courses*: #edu.courses.join(", ")
                // Highlights or Description
                #if edu.highlights != none {
                    for hi in edu.highlights [
                        - #eval("[" + hi + "]")
                    ]
                }
            ]
        }
    ]
}

// Work Experience
#let cvWork(info, i18n) = {
    if info.work != none [
        == #i18n.work.title

        #for w in info.work {
            // Parse ISO date strings into datetime objects
            let start = util.strpDate(w.startDate)
            let end = if w.endDate != none {
                let endDate = util.strpDate(w.endDate)
                end = [#util.monthName(endDate.month(), i18n, display: "short") #endDate.year()]
            } else [#i18n.time.present]

            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(w.url)[#w.organization]* #h(1fr) *#w.location* \
                // Line 2: Degree and Date Range
                #text(style: "italic")[#w.position] #h(1fr)
                #util.monthName(start.month(), i18n, display: "short") #start.year() #sym.dash.en #end \
                // Highlights or Description
                #for hi in w.highlights [
                    - #eval("[" + hi + "]")
                ]
            ]
        }
    ]
}

// Leadership and Activities
#let cvAffiliations(info) = {
    if info.affiliations != none [
        == Leadership & Activities

        #for org in info.affiliations {
            // Parse ISO date strings into datetime objects
            let start = util.strpDate(org.startDate)
            let end = util.strpDate(org.endDate)

            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(org.url)[#org.organization]* #h(1fr) *#org.location* \
                // Line 2: Degree and Date Range
                #text(style: "italic")[#org.position] #h(1fr)
                #util.monthName(start.month(), i18n, display: "short") #start.year() #sym.dash.en #util.monthName(end.month(), i18n, display: "short") #end.year() \
                // Highlights or Description
                #if org.highlights != none {
                    for hi in org.highlights [
                        - #eval("[" + hi + "]")
                    ]
                } else {}
            ]
        }
    ]
}

// Projects
#let cvProjects(info, i18n) = {
    if info.projects != none [
        == #i18n.projects.title

        #for project in info.projects {
            // Parse ISO date strings into datetime objects
            let start = util.strpDate(project.startDate)
            let end = [#i18n.time.present]
            if project.endDate != none {
                let endDate = util.strpDate(project.endDate)
                end = [#util.monthName(endDate.month(), i18n, display: "short") #endDate.year()]
            }

            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(project.url)[#project.name]* \
                // Line 2: Degree and Date Range
                #text(style: "italic")[#project.affiliation]  #h(1fr) #util.monthName(start.month(), i18n, display: "short") #start.year() #sym.dash.en #end \
                // Summary or Description
                #for hi in project.highlights [
                    - #eval("[" + hi + "]")
                ]
            ]
        }
    ]
}

// Honors and Awards
#let cvAwards(info) = {
    if info.awards != none [
        == Honors & Awards

        #for award in info.awards {
            // Parse ISO date strings into datetime objects
            let date = util.strpDate(award.date)

            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(award.url)[#award.title]* #h(1fr) *#award.location*\
                // Line 2: Degree and Date Range
                Issued by #text(style: "italic")[#award.issuer]  #h(1fr) #util.monthName(date.month(), i18n, display: "short") #date.year() \
                // Summary or Description
                #if award.highlights != none {
                    for hi in award.highlights [
                        - #eval("[" + hi + "]")
                    ]
                } else {}
            ]
        }
    ]
}

// Certifications
#let cvCertificates(info, i18n) = {
    if info.certificates != none [
        == #i18n.certificates.title

        #for cert in info.certificates {
            // Parse ISO date strings into datetime objects
            let date = util.strpDate(cert.date)

            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(cert.url)[#cert.name]* \
                // Line 2: Degree and Date Range
                #i18n.certificates.issuedBy #text(style: "italic")[#cert.issuer]  #h(1fr) #util.monthName(date.month(), i18n, display: "short") #date.year() \
                #i18n.certificates.credentialId #text(style: "italic")[#cert.credentialId] \
            ]
        }
    ]
}

// Research & Publications
#let cvPublications(info) = {
    if info.publications != none [
        == Research & Publications

        #for pub in info.publications {
            // Parse ISO date strings into datetime objects
            let date = util.strpDate(pub.releaseDate)

            // Create a block layout for each education entry
            block(width: 100%)[
                // Line 1: Institution and Location
                *#link(pub.url)[#pub.name]* \
                // Line 2: Degree and Date Range
                Published on #text(style: "italic")[#pub.publisher]  #h(1fr) #util.monthName(date.month(), i18n, display: "short") #date.year() \
            ]
        }
    ]
}

// Skills, Languages, and Interests
#let cvSkills(info, i18n) = {
    if (info.languages != none) or (info.skills != none) or (info.interests != none) [
        #let title = (i18n.skills.titles.languages, i18n.skills.titles.skills, i18n.skills.titles.interests)
        #if info.languages == none {
            let _ = title.remove(0)
        } else if info.skills == none {
            let _ = title.remove(1)
        } else if info.interests == none {
            let _ = title.remove(2)
        }

        == #title.join(", ", last: " & ")

        #if (info.languages != none) [
            #let langs = ()
            #for lang in info.languages {
                langs.push([#lang.language (#lang.fluency)])
            }
            - *Languages*: #langs.join(", ")
        ]
        #if (info.skills != none) [
            #for group in info.skills [
                - *#group.category*: #group.skills.join(", ")
            ]
        ]
        #if (info.interests != none) [
            - *Interests*: #info.interests.join(", ")
        ]
    ]
}

// References
#let cvReferences(info) = {
    if info.references != none [
        == References

        #for ref in info.references [
            - *#link(ref.url)[#ref.name]*: "#ref.reference"
        ]
    ] else {}
}

// #cvreferences

// =====================================================================

// End Note
#let endNote(i18n) = {
    place(
        bottom + right,
        block[
            #set text(size: 5pt, font: "Consolas", fill: silver)
            \*#i18n.endNote #datetime.today().display("[year]-[month]-[day]")
        ]
    )
}
