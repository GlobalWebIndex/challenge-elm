### Problem domain

The challenge reminds me of the [Faceted Search](https://en.wikipedia.org/wiki/Faceted_search). Our **data** is the list of audiences and we have three **filters** on it:

1. a hierarchical filter with the tree of folders,
2. a categorical filter with audience types, and
3. a categorical (or ordinal) filter with audience and folder names.

These filters have different representations on the screen:

1. browser (first step)
2. three buttons (second step)
3. search box (on the screenshot)

According to the faceted search, **applying filters on data** may mean:
filteredData = ⋂ filter<sub>i</sub> (data)

### Proposal

I think this is a scalable, robust technique. And so I would like to propose some changes in the requirements. I have added the proposed changes to the `FIRST_STEP.md` and the `SECOND_STEP.md`, and the Elm code is a prototype implementation of those changes.

I know that this challenge is about meeting the requirements, but perhaps my contribution may be beneficial too.

#### First step

In the implementation I have used the lazy rose tree package, and the hierarchical filter was basicly done.
The data is baked into the hierarchy itself, so applying **another hierarchical filter** would not be easy right now. I think this is the only limitation of my implementation in contrast of the faceted search technique.

#### Second step

In order to implement a (non-hierarchical) filter I have created a mutual recursive function-pair for the lazy rose tree package. With that we can decide whether an audience should be displayed or not in the `levelView` function.

Adding more filters will be straightforward, we need to implement the intersection in the `checker` helper functions.

- Two new functions in the `Lazy.Tree` called `isInTree` and `isInForest`, and
- a wrapper function in the `Lazy.Tree.Zipper` called `isInZipper`.

References for this step:

- [Wikipedia - Mutual recursion](https://en.wikipedia.org/wiki/Mutual_recursion)
- [Simply Scheme - Trees](https://people.eecs.berkeley.edu/~bh/pdf/ssch18.pdf) pp. 310 - 313

#### Design

I would like to explain my design choices using user stories (if I were a user).

As a user I want to see breadcrumbs so that I do not need to remember what path led to these audiences.
This is why I have added breadcrumbs at the top of the list.

As a user I want to open a folder with a single click so that I can reach my data quickly.
This is why the breadcrumbs are clickable. Also in order to be consistent, the user always clicks on a folder, no matter if they traverse up or down in the hierarchy.

As a user I want to know how I had filtered my audiences out so that I can easily pick up my thoughts after a coffee-break.
This is why the filters' current state is upfront. The users can capture only the red elements on the sidebar and recall all their settings.

### Potential benefits

- The browser can be extracted into its own reusable module.

- All the non-hierarchical filter types can be extracted into their own reusable modules.

- Adding new filters can be implemented with the same pattern.

- Whenever a user sees a browser+filters widget on the site, they know that it works consistently.

- The users can organize their data into folders as they want, because the folders are neutral.
