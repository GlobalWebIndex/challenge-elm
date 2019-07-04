# 1 - Browser Implementation

This is **the required step** for completing application on position.
Your job is to implement parsing of data from `JSON` format and fully usable interactive UI of audiences browser.

## Requirements

This is required for successful implementation:

- [x] You must use data and type (aliases) provided.
- [x] You must use provided `JSON` fixtures in your app (*these are returned by API in production app*)
- [x] You must not change any of pre-defined types and fixtures.
    - However you can use existing files for your implementation.
- [x] You must successfully resolve all relations in data set.
- [x] By default component should display root level (items without any parent folder)
- [x] Only items from current level are shown (in UI) at any given time.
- [x] Folders are displayed before audiences in any level.
- [x] Click on any folder opens its content.
- [x] `Go up` button is not visible in root level.
- [x] `Go up` button is visible in any sub-level.
    - You can use name of parent folder if you want.
- [x] `Go up` button opens parent level on click.
- [x] Final solution should be compilable to html app or should contain HTML and source compilable to JavaScript included in HTML.

## Hints

These are the things you might consider thinking about before you start with your implementation:

- How to make `JSON` parsing scalable?
    - Do you know about [applicatives](https://toast.al/posts/2016-08-12-elm-applicatives-and-json-decoders.html)?
- Is there any clever transformation of data that can be used as input of browser itself?
    - What data-structures can be helpful if any?
    - Do you prefer working with RoseTree or List? Why? (you can leave comment in your code)
- Which parts can be decoupled for possible re-use?
    - Do you like to put those in separate module? Why yes or no?

## Final Words

Please don't be afraid to ask (using email or by opening issue in this repository) if anything is not clear,
can be improved in this documents or if you're just simply stuck with anything.
We are happy to provide any help to degree we are able to. Also have in mind that there are no time restrictions for completing this challenge.
Take as much time as you wish for completing this. *In the end the most important bit is to challenge your problem solving thinking*.
And of course **good luck with this**! :rocket:
