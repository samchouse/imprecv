#import "@preview/imprecv:1.0.1": *

#let cvdata = yaml("template.yml")

#let uservars = (
    headingfont: "Libertinus Serif",
    bodyfont: "Libertinus Serif",
    fontsize: 10pt,          // https://typst.app/docs/reference/layout/length
    linespacing: 6pt,        // length
    sectionspacing: 0pt,     // length
    showAddress:  true,      // https://typst.app/docs/reference/foundations/bool
    showNumber: true,        // bool
    showTitle: true,         // bool
    headingsmallcaps: false, // bool
    sendnote: false,         // bool. set to false to have sideways endnote
    lang: "en",              // ISO 639-1/2/3 code string, https://iso639-3.sil.org/code_tables/639/data
    region: none,            // none or ISO 3166-1 alpha-2 code string, e.g. "BR" for Brazil
)

// setrules and showrules can be overridden by re-declaring it here
// #let setrules(doc) = {
//      // add custom document style rules here
//
//      doc
// }

#let customrules(doc) = {
    // add custom document style rules here
    set page(                 // https://typst.app/docs/reference/layout/page
        paper: "us-letter",
        numbering: "1 / 1",
        number-align: center,
        margin: 1.25cm,
    )

    // set list(indent: 1em)

    doc
}

#let cvinit(doc) = {
    doc = setrules(uservars, doc)
    doc = showrules(uservars, doc)
    doc = customrules(doc)

    doc
}

// each section body can be overridden by re-declaring it here
// #let cveducation = []

// ========================================================================== //

#show: doc => cvinit(doc)

#let strings = setstrings(uservars)

#cvheading(cvdata, uservars)
#cvwork(cvdata, strings)
#cveducation(cvdata, strings)
#cvaffiliations(cvdata, strings)
#cvprojects(cvdata, strings)
#cvawards(cvdata, strings)
#cvcertificates(cvdata, strings)
#cvpublications(cvdata, strings)
#cvskills(cvdata, strings)
#cvreferences(cvdata, strings)
#endnote(uservars, strings)
