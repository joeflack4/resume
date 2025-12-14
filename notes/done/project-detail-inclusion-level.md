# Project detail inclusion level
There's a problem with the resume. It's too long. However, it includes a lot of good information that we want to 
preserve. We'd like to update the configurability such that we can dynamically reduce the amount of information in the
résumé through the vector of project details (i.e. the bulleted `statements`).

I've added a key, `projects-importance-order-to-include-statements-blocks`, to `efaults/html-stackoverflow.yaml`. It 
contains a map of key value pairs, e.g. "1: Web platform foundation". The keys define the 'importance order' of the 
project relative to other projects, and is how we decide whether or not to include the `statements` block for that given 
project. 

The number of statements blocks to include is defined in `meta.yml`, as `top-n-projects-to-include-statements-blocks`, 
the value of which is an integer. So if it is 5, then the keys in 
`projects-importance-order-to-include-statements-blocks` which have value <= 5 should be included. Or, if it's easier, 
since I have ordered them, you could also just include the first 5 items in that key/val pair list.

Now, when we are rendering project content, how do we detemine if a given project in the iterator (
`$for(work-experience.projects.statements)$`) should be included or skipped? Well, we can determine it by the project 
`name`, which will match the value in the key/val pairs in `projects-importance-order-to-include-statements-blocks`.

To be honest though, IDK if the way I've set this up is easy / feasible for pandoc. If you find that it isn't, let me 
know, and feel fre to offer me some alternative suggestions.

I'd also like some alternative commands for rendering the current `default` phony recipe, and what it aliases 
`html-canonical` and `output/$(FILENAME_STUB).html`, as well as `html-stackoverflow--oriented-as-statements` and 
`output/$(FILENAME_STUB)-StackOverflow--oriented-as-statements.html`. If you can, update the makefile with alternative 
versions of these targets/goals/commands, with a suffix like `--top-n-projects-statements` where the user can pass a 
flag or variable when calling make `N`, where they can specify an integer, which will override the default value for 
`top-n-projects-to-include-statements-blocks` set in `meta.yml`.
