module Layout.Scryer exposing (seoHeaders, view)

import Content.About exposing (Author)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Extra
import Layout.Markdown as Markdown
import Pages.Url
import Settings
import UrlPath


seoHeaders : Author -> List Head.Tag
seoHeaders author =
    let
        imageUrl =
            author.avatar
                |> Maybe.map (\authorAvatar -> Pages.Url.fromPath <| UrlPath.fromString authorAvatar)
                |> Maybe.withDefault
                    ([ "media", "blog-image.png" ] |> UrlPath.join |> Pages.Url.fromPath)
    in
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Settings.title
        , image =
            { url = imageUrl
            , alt = author.name
            , dimensions = Just { width = 300, height = 300 }
            , mimeType = Nothing
            }
        , description = author.name ++ " - " ++ (author.occupation |> Maybe.withDefault ("Author of blogposts on " ++ Settings.title))
        , locale = Settings.locale
        , title = author.name
        }
        |> Seo.website


view : { code : String, evalRes : String } -> Html msg
view { code, evalRes } =
    Html.div
        [ Attrs.class "divide-y divide-gray-200 dark:divide-nord-9"
        ]
        [ Html.div
            [ Attrs.class "space-y-2 pb-8 pt-6 md:space-y-5"
            ]
            [ Html.h1
                [ Attrs.class "text-3xl font-extrabold leading-9 tracking-tight text-gray-900 dark:text-nord-5 sm:text-4xl sm:leading-10 md:text-6xl md:leading-14"
                ]
                [ Html.text "Scryer Prolog" ]
            ]
        , Html.div
            [ Attrs.class "items-start space-y-2 xl:grid xl:grid-cols-3 xl:gap-x-8 xl:space-y-0"
            ]
            [ Html.div
                [ Attrs.class "prose max-w-none pb-8 pt-8 dark:prose-invert xl:col-span-2"
                ]
                [ Html.text "Heheh" ]
            ]
        ]
