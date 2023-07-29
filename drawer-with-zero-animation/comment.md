This is good for a few reason: 
1. I tried to disable animation for the drawer, it works fine. 
2. I applied dynamic list of drawer items.
3. I use pushReplacement to replace the current page with the new one. Thus, no stacks are created.

But it has a big problem.
This not only disable the animation for the page transition, but also disable the animation for the drawer.

It turns out, flutter doc provides a more elegant solution.