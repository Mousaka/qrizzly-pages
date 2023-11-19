---
title: Working on an issue 
description: "A summarized conversation between me and a colleague trying to answer the question \"How to start working with an issue?\""
published: "2023-11-19"
tags: ["soft-skills", "methodology"]
---
# How to work on an issue

## Starting

1. Run it
    1. If bug reproduce
    2. If not a bug try run the context. If it’s something visual, go to that place in the App, you might need to produce the right state to get there, get familiar with the context.
2. Try to find the most relevant part of the code
    1. If it’s a visual thing, search for some text that might lead to you the this code
3. Write a failing test, easier for bugs.
4. Just start changing something in order to learn and explore and “prove“ that you are in the right place.
5. This might lead you to a lot of dependent code that also needs to be changed. Compiler errors can help here.
6. If you changed a function or are planning to, check all places where it’s used using “Find usages” in the editor, or a text search. Maybe leave comments and bookmarks in some of the places for yourself. Later you might go back and fix something.

## Getting stuck

1. If you don’t know how to do something like “how to save an event to the event store”, can you still find something else to start on, some interesting parts, like which endpoint receives the data from the frontend. Maybe ask for help
2. Sometimes you need to step back: If you find something in the code over and over which you still don’t understand, sometimes you come to the conclusion that “I really don’t understand this thing and looking at it at different places in the code is not enough”. Then it can be worth stepping back and putting effort in to gather an understanding of this thing. There are several things that can be done to gain this understanding:
    1. Check documentation, readme files / wiki.
    2. Google the thing if it doesn't seem to be Insurello-specific
    3. Use git-blame to see who made it and maybe there is a PR that explains it.
    4. This investigation might not lead to you understanding the concept fully but might make you prepared for asking a **good question** to the one who introduced this.
    5. Ask the “good question” to those you think made this thing or knows about it. Since you have put some effort into it by investigating your good question will be quicker and easier to answer and you will be more ready to receive the knowledge since you know more about the context.
3. If you don’t understand the problem from a product perspective:
    1. Sometimes question the issue. Why is there an issue? Maybe it doesn't need to be solved in code, maybe there is a way around it? While investigating this you might start seeing “oh! I see why they need this. I understand better now”.
    2. Ask people for clarification. Ask PM, designer, users, stake holders, or other devs.