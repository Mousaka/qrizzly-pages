module Settings exposing
    ( author
    , canonicalUrl
    , locale
    , subtitle
    , title
    )

import LanguageTag.Country as Country
import LanguageTag.Language as Language


canonicalUrl : String
canonicalUrl =
    ""


locale : Maybe ( Language.Language, Country.Country )
locale =
    Just ( Language.en, Country.se )


title : String
title =
    "Qrizzly Pages"


subtitle : String
subtitle =
    "A Qrizzly" 


author : String
author =
    "Kristian Lundström"
