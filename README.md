# Challenge: Elm

Hello! Wellcome to Elm Challenge.

This repository contains requirements definition of project used for job applications
on **position of [Elm](elm-lang.org)/[JavaScript](https://www.javascript.com/) developer**.
This includes two parts test where **only the first part is required**.
Whole assignment is based on real part of our production app.
However since there is a lot of domain specific knowladge required for most parts of our system
and we are aware of the fact that most of this logic might be confusing for newcomers we've tried to
pick task which doesn't require any specific insight and removed all parts which might be possibly confusing to pick up.
Thanks to this this project can be used as general challenge to build HTML app in Elm.

## Position Description

In its essence, GlobalWebIndex is a data company and our primary way how we deliver all our datasets to clients is PRO Platform – our proprietary web interface for our analytical engine.

Praised and used by the world largest organizations, PRO Platform enables our clients to cut through our data using custom audiences, segmentations and modular charting library.

You will sit within our PRO Platform team and will be jointly responsible to push the development of the platform forward.
Day-to-day this involves new feature engineering, reviewing and discussing code of your colleagues and discussing the design decisions with the wider technical leadership team.

- Ideate, brainstorm and implement new components and features using JavaScript, Elm or Ruby, if you fancy getting your hands on backend code
- Develop the project codebase, with the focus on long-term maintenance – we look for people who really care about the quality as a day-to-day routine
- Think forward and propose innovative approaches, which can push the project to the next level.
We like to discuss things so you’ll be expected to demonstrate conclusive arguments and get a buy in from the whole team
- Evaluate external solutions (databases, frameworks, libraries) which might be beneficial to our platform

## Basic Instructions

You are required to provide an implementation of component for browsing `Audience`s and `AudienceFolder`s in hierarchical structure.
Every `Audience` might have or have not `folder` and every `Folder` might have (but not necessary) its `parent` folder.
This mean component should display `n` level deep tree. Always one level at the time.
User can open any sub-folder or go pack to parent of current level.
All data are provided in JSON format.

**This is how similar component looks in our production system:**

![screenshot](media/screenshot.png)

## Introduction

There are two models `Audience` and `AudeinceFodlder` defined each with its own API endpoint.
You'll find all necessary data inside [/src/Data](/src/Data) folder. There are data in plain `JSON` format witch represts what API returns.
Also you will find coresponding type definitions of each model. Your job is to serialize this data to collection and build interactive browser.

## General Acceptance Criteria

- Implementation must be done in `Elm` language.
- You can use any 3rd library you want to.
- `elm-lang/html` must be used for rendering UI.
- You are free use `ports` and `subscribtions` in case you want to.
- You can use [screenshot](/media/screenshot.png) as inspiration for UI or come with any own layout if it's satisfy requirements.
- All naming including comments and additional documentation must be in english language.
- Final result must be in form of full git repository with your own implementation.
- There are **no time restrictions** for completing this challenge.
- **(Only) First part is required.**
- **In case you want to apply for the job but have no time finishing first step soon let us know you're interested anyway.** (We are people too)

## Where to Start

If you are interested in applying for this possition or just want to challenge yourself (which is also 100% OK for us)
please continue in following steps:

- Fork this repository under your Github account.
- Complete implementation inside your fork.
- Open pull request to [original](https://github.com/GlobalWebIndex/challenge-elm/) repository with your own implementation.
- Comment your pull request with message containing `READY` or `RDY` to let us know that we can review your code.
- Comment your PR with any question in case you will need any help (or send us email - see bellow).

**You can also open pull request before you're finished with implementation in case you are willing to discuss anything!**

## Parts

- [First part](FIRST_STEP.md) - Browser Implementation
- [Second part](SECOND_STEP.md) - Filters Implementation

## Goal

The goal is to test your ability to come up with solution for real world problem which will be part of your day to day responsibility.
Obviously the first thing what we will look at is to what degree your implmentation satisfy original requirements.
Also we want to see your ability to come up with robust solution and will look on over all code quality.

## Contacts

In case you want to apply for position in our team please contact `petr@globalwebindex.net`.
If you have any questions about implementation itself you can send me mail to `marek@globalwebindex.net`
or open issue/PR in this repository so we can discuss any part together.

## License

MIT
