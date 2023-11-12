module Route.Blog.Slug_ exposing (ActionData, Data, Model, Msg, route)

--import SiteOld
--import UnsplashImage

import Article
import BackendTask exposing (BackendTask)
import Date exposing (Date)
import DateOrDateTime
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra
import Markdown.Block
import Markdown.Renderer
import MarkdownCodec
import Pages.Url
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import StructuredData
import Tailwind.Breakpoints as Bp
import Tailwind.Theme as Theme
import Tailwind.Utilities as Tw
import TailwindMarkdownRenderer
import UrlPath
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { slug : String }


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.preRender
        { head = head
        , pages = pages
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


pages : BackendTask FatalError (List RouteParams)
pages =
    Article.blogPostsGlob
        |> BackendTask.map
            (List.map
                (\globData ->
                    { slug = globData.slug }
                )
            )


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app shared =
    let
        body : List (Html (PagesMsg msg))
        body =
            [ div
                [ css
                    [ Tw.min_h_screen
                    , Tw.w_full
                    , Tw.relative
                    ]
                ]
                [ div
                    [ css
                        [ Tw.pt_16
                        , Tw.pb_16
                        , Tw.px_8
                        , Tw.flex
                        , Tw.flex_col
                        ]
                    ]
                    [ div
                        [ css
                            [ Bp.md [ Tw.mx_auto ]
                            ]
                        ]
                        [ h1
                            [ css
                                [ Tw.text_center
                                , Tw.text_4xl
                                , Tw.font_bold
                                , Tw.tracking_tight
                                , Tw.mt_2
                                , Tw.mb_8
                                ]
                            ]
                            [ text app.data.metadata.title
                            ]
                        , authorView "Kristian" app.data
                        , div
                            [ css
                                [ Tw.prose
                                ]
                            ]
                            (app.data.body
                                |> Markdown.Renderer.render TailwindMarkdownRenderer.renderer
                                |> Result.withDefault []
                            )
                        ]
                    ]
                ]
            ]
    in
    { title = app.data.metadata.title
    , body =body
    }


authorView : String -> Data -> Html msg
authorView authorString app =
    div
        [ css
            [ Tw.flex
            , Tw.mb_16

            --, Tw.flex_shrink_0
            ]
        ]
        [ img
            [ css
                [ Tw.rounded_full
                , Tw.h_10
                , Tw.w_10
                ]
            ]
            []
        , div
            [ css [ Tw.ml_3 ]
            ]
            [ div
                [ css
                    []
                ]
                [ p
                    [ css
                        [ Tw.text_sm
                        , Tw.font_medium
                        , Tw.text_color Theme.gray_900
                        ]
                    ]
                    [ span
                        []
                        [ text authorString ]
                    ]
                ]
            , div
                [ css
                    [ Tw.flex
                    , Tw.space_x_1
                    , Tw.text_sm
                    , Tw.text_color Theme.gray_500
                    , Tw.text_color Theme.gray_400
                    ]
                ]
                [ time
                    [ Attr.datetime "2020-03-16"
                    ]
                    [ text (app.metadata.published |> Date.format "MMMM ddd, yyyy") ]
                ]
            ]
        ]


author =
    "Kristian L"


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    let
        metadata =
            app.data.metadata
    in
    Head.structuredData
        (StructuredData.article
            { title = metadata.title
            , description = metadata.description
            , author = StructuredData.person { name = author }
            , publisher = StructuredData.person { name = author }
            , url = UrlPath.toAbsolute app.path
            , datePublished = Date.toIsoString metadata.published
            , mainEntityOfPage =
                StructuredData.softwareSourceCode
                    { codeRepositoryUrl = "https://github.com/mousaka/qrizzly-pages"
                    , description = "Me blog"
                    , author = author
                    , programmingLanguage = StructuredData.elmLang
                    }
            }
        )
        :: (Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = "elm-pages"
                , image =
                    { url = Pages.Url.external "https://avatars.githubusercontent.com/u/3679268?v=4"
                    , alt = metadata.description
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = metadata.description
                , locale = Nothing
                , title = metadata.title
                }
                |> Seo.article
                    { tags = []
                    , section = Nothing
                    , publishedTime = Just (DateOrDateTime.Date metadata.published)
                    , modifiedTime = Nothing
                    , expirationTime = Nothing
                    }
           )


type alias Data =
    { metadata : ArticleMetadata
    , body : List Markdown.Block.Block
    }


type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    MarkdownCodec.withFrontmatter Data
        frontmatterDecoder
        TailwindMarkdownRenderer.renderer
        ("content/blog/" ++ routeParams.slug ++ ".md")


type alias ArticleMetadata =
    { title : String
    , description : String
    , published : Date
    , draft : Bool
    }


frontmatterDecoder : Decoder ArticleMetadata
frontmatterDecoder =
    Decode.map4 ArticleMetadata
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "published"
            (Decode.string
                |> Decode.andThen
                    (\isoString ->
                        Date.fromIsoString isoString
                            |> Json.Decode.Extra.fromResult
                    )
            )
        )
        (Decode.field "draft" Decode.bool
            |> Decode.maybe
            |> Decode.map (Maybe.withDefault False)
        )
