# Compare the two methods
[slow](slow-enlarge-animation-profile.PNG)
[less slow](less-slow-enlarge-animation-profile.PNG)

I don't really know how to optimize this. I can think of one of the following reasons. 
1. shape transform is a demanding animation, especially if it involves transforming between different shapes, like cornered rect.
2. too many rebuilds. I have tried to minimize it with const classes.

The second approach seems to need a few seconds to warm up while the first doesn't. 
I will look into this later.