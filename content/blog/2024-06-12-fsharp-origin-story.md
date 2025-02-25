---
title: F# origin story at Insurello
description: "The script for an F# talk I did at Stockholm's F# meetup group about how Insurello started using it."
published: "2024-06-12"
tags: ["F#", "Presentation"]
---

## Intro
I’m Kristian Lundström, and I have worked at Insurello for the last 6 years as a software engineer. During this period we’ve gone from no F# at all to quite a lot. I will summarise this story for you and it will be mainly from my perspective but possibly it also represents Insurello’s tech team as a whole. (What does it mean if it doesn’t?). I’ve seen a lot of talks about OOP vs FP but this talk takes place in a world where FP won the war and left is only some brotherly rivalry and love between Elm and Fsharp.
- But first a bit more about me
    - Started my career working with Java at a product company (Schoolsoft) and was then a consultant for a year
- I’m from Stockholm, Sweden
- Some things I enjoy doing
    - Taekwondo
    - Running
    - Cooking
    - Dota2, but I recently stopped playing!?
    - Prolog (Are YOU my new Prolog-friend?)
# The F# origin story
When I joined Insurello 2018 I was the second developer and the current CTO, who was the other developer, had recently rewritten the whole front-end in Elm. I had been testing Elm and FP a bit and was curious how it would be to work with so that was big part of why I joined. At this time the back-end was mainly written in Typescript but with a bit of an FP-style.

In 2019 Insurello hired more devs, and we mainly looked for people who knew or were curious about functional programming.

The CTO had left us, but we were now a small dev team. We really liked the dev experience and robustness of Elm and our feeling was the back-end TypeScript experience was not on par with that.
### Why not TS?
Using the static typing of ts was sometimes difficult to do in a good way. Especially with Promises.

Using FP to the degree we wanted in TS required using some libraries which somewhat worked as we wanted but the DX was way worse comparing to Elm where a lot of the FP-patterns were encouraged or enforced by the language itself.
One example of this is trying to read type-errors when using FP-libraries in Typescript, or just any type-errors in TS.

Some examples of libraries we used with TS to get functionality we had in Elm were
- Codecs (io-ts)
- Pipes (fp-ts)
- Either/Option/Async types (fp-ts)
### Why FP at all?
- So we knew we didn’t like the DX in TS, and we wanted something different.
- Since we had taken the FP-pill and seen what a nice static algebraic type system together with FP-patterns could do for maintainability, productivity and all around DX none of us were really considering anything like ,  etc.
### How I found fsharp
I had stumbled upon this video I with Scott Wlaschin which introduced me to fsharp https://vimeo.com/113588389.
- I then found his blog (https://fsharpforfunandprofit.com/) which I really like, and then I bought his book Domain Modeling made Functional.
- This book showed me a lot of things about DDD, tech architecture, but most importantly it had practical examples and guidance into how to create an fsharp backend-service and how to structure the code within it into "workflows".
- The style thought in that book has highly influenced how we write fsharp at Insurello.

Felt similar to Elm in a lot of ways.
- No monad talk etc
- Simple yet effective
- Syntax

We decided to try it out and wrote a new service using it. This was May 19, 2019.
### Other considerations
#### Haskell
Some of us, or at least I, was also quite interested in Haskell. Elm as a language is a subset of Haskell, and the compiler is actually written in Haskell. Since we really loved working with Elm it sounded nice to get something similar on the back-end.
No one had any major experience with Haskell it was concluded after some research that it was too difficult to create good production and dev environments with it.
- Many different tools and styles.
- No appealing opinionated single guide to follow.
- We most likely wanted a quite specific flare of Haskell and it would require a lot of effort to understand how to get there with a lot of uncertainties.
- There was a podcast episode with Richard Feldman where he talked about how NoRedInk had been on a similar journey. They had also considered both Haskell and fsharp but eventually landed on Haskell with one of the main motivations being that they had people with great knowledge of Haskell and understanding of how an "Elm-flared" Haskell could look like and how to reach it. Though that sounded very interesting it made us realise that fsharp was probably a better choice for us.
## Some good and bad stuff with F#
- The F# tooling feels quite well-developed but there were some problems and annoyances especially in the beginning when we started using it.
    - Quiz time:
        - What is the best Swedish phrase to yell when your fsharp code formatter causes compiler errors?
            - Faan Tomas!!
        - We’d yell this a lot in the beginning because of bugs causing fantomas to create compile errors after formatting code.
        - The team working on it seem to have done a good job though and it has been a long time since it last messed things up. Now it’s just a great tool!
- I don’t remember the details but I recall were a few issues with fsharp-things not being fully ported to the dotnet core platform yet and we were all using Macs.
- Over the years I feel like things have improved a lot and current state of the tooling feels very good.
- It felt like a lot of documentation and community posts a lot of times assumed that you came from the dotnet-world or specifically csharp and knew exactly what "ASP.NET MVC Pattern" is. This is understandable but was a bit difficult to for us to navigate through sometimes since we would first need to understand the csharp part *and* how to use it in fsharp and also if it’s only relevant if you already use e.g. ASP.NET or MVC.
- Sometimes you have to interop with csharp libraries when coding which adds a cognitive load in writing and reading code which is usually not dramatically bad but always takes a tiny bit of joy out of the coding.
- Namespacing with modules submodules etc.
    - There are many ways to do things and it gets messy sometimes.
    - I still don’t have a strong feeling what is "the best" way.
- Feels unnecessarily sensitive with indenting sometimes.
- Discriminated union
- Pipes
- Fall-through in pattern matching
    - Elm does not have this for example
- I like that the compiler requires all code to be "in order".
- Interop with csharp is also really nice. We use the official AWS library e.g. which is quite nice.
## Challenges
- For communication between our services we use RabbitMQ
    - There is no official F# client for it and we found the official csharp client to ba a bit tedious to use. So we rolled our own wrapper around it but it was not that easy and it is still a bit challenging to maintain it. Apart from that using this client in our projects feels great!
- Continuous form developing and scaling up
    - One challenge we have and have had since the beginning is that a big part of our product is a very large web form with many conditionals based on your answers and the data we have about the insurance world which we continuously work on and try to improve.
    - This led us to eventually create something we call “The Question Editor”
        - To be honest I was not a big fan of us spending time on this in the beginning, but I have come to like it a lot.
        - Demo and or pictures
    - This tool is mainly implemented in Elm but since we didn’t want to rewrite validation logic in the back-end we found a way to generate a javascript file that has the same validation logic as the Elm (front-end) part but that we were able to run in our F# backend.
        - This maybe how strong our love for Elm is. <DRAKE MEME here>
## Conversation starters
I will now list some tech stuff we have that you can use to start a conversation with me
- Event Sourcing with RabbitMQ + PostgreSQL
- Serialising/Deserialising
    - Thoth.Json.Net
    - Codec - A library we wrote for writing combined decoders and encoders
    - In previous projects we experimented with different "autocodecs" with varying and not overall impressive experiences
- Web-server
    - Suave
    - Aspdotnet
        - For our new BankID implementation
- Other
    - Fs.ErrorTooling but homegrown
        - I wished we used this from the start. (I blame bad SEO)
        - Not too late to switch though :)
- Side effect management and testing
    - Typically, we just pass all side-effect-functions as arguments to the functions that needs them.
        - This makes workflows easier to test
    - Xunit + Expecto for testing
## What do I wish could be improved in fsharp?
- Fsharp promotes using FP-patterns, but I think it would be beneficial for both beginners and others if you could get further with FP-patterns without libraries and mixing in OOP-patterns.
- Fsharp interactive is a promising dev tool, but we've found it difficult to use in practise.
    - How do I load all my dependencies without spending hours?
- Fsharp-review
## 6 years in, what has been good about F# and Elm?
- It is and has been really fun to work with both of these!
- Fsharp is a really powerful language where you can write simple clear code that expresses your business domain really well.
- Elm can show you what an fsharp-like, but strict and pure world could look like.
- Thank you for listening to me
