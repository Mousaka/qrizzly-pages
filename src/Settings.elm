module Settings exposing
    ( author
    , canonicalUrl
    , locale
    , subtitle
    , title
    )

import LanguageTag.Language as Language
import LanguageTag.Region as Region


canonicalUrl : String
canonicalUrl =
    "https://qrizzly-pages.netlify.app"


locale : Maybe ( Language.Language, Region.Region )
locale =
    Just ( Language.en, Region.se )


title : String
title =
    "Qrizzly Pages"


subtitle : String
subtitle =
    "Qrizzly's corner on the world wide web."


author : String
author =
    "Kristian Lundström"
