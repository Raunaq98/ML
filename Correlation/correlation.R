data1 <- anscombe
library(ggplot2)
library(dplyr)


one <- ggplot(data1, aes(x=x1,y=y1))  +
         geom_point() + labs(title = "1") + xlim(0,20) + ylim(0,20)

two <- ggplot(data1, aes(x=x2,y=y2))  +
         geom_point() + labs(title = "2") + xlim(0,20) + ylim(0,20)

three <- ggplot(data1, aes(x=x3,y=y3))  +
         geom_point() + labs(title = "3") + xlim(0,20) + ylim(0,20)

four <- ggplot(data1, aes(x=x4,y=y4))  +
         geom_point() + labs(title = "4") + xlim(0,20) + ylim(0,20)

library(cowplot)
plot_grid(one,two,three,four)

## all 4 of these datasets are different to visualise but,
## have the same mean, sd, same number of points and same correlation

# this entire datasets makes clear the importance to visually inscept data
# even when COR / mean look same