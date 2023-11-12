module Article exposing (..)

import BackendTask
import BackendTask.File as File
import BackendTask.Glob as Glob
import Date exposing (Date)
import FatalError exposing (FatalError)
import Json.Decode as Decode exposing (Decoder)
import Pages.Url exposing (Url)
import Route


type alias BlogPost =
    { filePath : String
    , slug : String
    }


blogPostsGlob : BackendTask.BackendTask error (List { filePath : String, slug : String })
blogPostsGlob =
    Glob.succeed BlogPost
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask


allMetadata :
    BackendTask.BackendTask
        { fatal : FatalError, recoverable : File.FileReadError Decode.Error }
        (List ( Route.Route, ArticleMetadata ))
allMetadata =
    blogPostsGlob
        |> BackendTask.map
            (\paths ->
                paths
                    |> List.map
                        (\{ filePath, slug } ->
                            BackendTask.map2 Tuple.pair
                                (BackendTask.succeed <| Route.Blog__Slug_ { slug = slug })
                                (File.onlyFrontmatter frontmatterDecoder filePath)
                        )
            )
        |> BackendTask.resolve
        |> BackendTask.map
            (\articles ->
                articles
                    |> List.filterMap
                        (\( route, metadata ) ->
                            if metadata.draft then
                                Nothing

                            else
                                Just ( route, metadata )
                        )
            )
        |> BackendTask.map
            (List.sortBy
                (\( route, metadata ) -> -(Date.toRataDie metadata.published))
            )


type alias ArticleMetadata =
    { title : String
    , published : Date
    , draft : Bool
    , tags : List String
    }


frontmatterDecoder : Decoder ArticleMetadata
frontmatterDecoder =
    Decode.map4 ArticleMetadata
        (Decode.field "title" Decode.string)
        (Decode.field "published"
            (Decode.string
                |> Decode.andThen
                    (\isoString ->
                        case Date.fromIsoString isoString of
                            Ok date ->
                                Decode.succeed date

                            Err error ->
                                Decode.fail error
                    )
            )
        )
        (Decode.field "draft" Decode.bool
            |> Decode.maybe
            |> Decode.map (Maybe.withDefault False)
        )
        (Decode.field "tags" (Decode.list Decode.string)
            |> Decode.maybe
            |> Decode.map (Maybe.withDefault [])
        )
