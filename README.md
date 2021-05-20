# ActivePassivePolicy

This repository holds my work motivated by the [problem set](https://github.com/chaserileyabram/ActivePassivePolicy/blob/master/econ33820_spring2021_ftpl_exercise.pdf) given by Greg Kaplan in his Spring 2021 reading group, where we went through John Cochrane's draft of his [textbook](https://www.johnhcochrane.com/research-all/the-fiscal-theory-of-the-price-level-1).


My work here does not concern the introduction of capital or long-term debt, but instead focuses on gaining a better understanding of how monetary and fiscal policy interact. To facilitate this goal, the model used is the [simplest version of a continuous-time New Keynesian model](https://benjaminmoll.com/wp-content/uploads/2019/07/Lecture2_ECO521_web.pdf) with government debt.

## Contents
- The [note](https://github.com/chaserileyabram/ActivePassivePolicy/blob/master/Active_Passive_Note.pdf) expounds on the ideas of active and passive policies (and why this terminology is not always appropriate). This should be accessible to anyone with basic familiarity with the New Keynesian model and boundary value problems.
- The [presentation](https://github.com/chaserileyabram/ActivePassivePolicy/blob/master/Active_Passive_Presentation.pdf) was given as part of the solution to the problem set for the reading group.
- The [code](https://github.com/chaserileyabram/ActivePassivePolicy/blob/master/active_passive.jl) is a bare bones Julia implementation for solving the system as a boundary value problem, and plotting the results.
- The [plots folder](https://github.com/chaserileyabram/ActivePassivePolicy/tree/master/plots) holds a few of the basic plots I made. I encourage interested parties to download the code and make their own plots, as it requires only tweaking a few lines of parameters in the code.

## Acknowledgment
I learned an immense amount from all participants in the reading group. In particular, thanks to Greg Kaplan for organizing and John Cochrane for participating (and writing the book, of course). A massive thanks goes out to [Zhiyu Fu](https://github.com/FuZhiyu/FTPL_in_cnts_time) and [Leo Aparisi de Lannoy](https://github.com/LeoAdL/FTPL) for their many insightful discussions and complementary problem-solving. Any remaining errors are my own (but if you find them, shoot me an email at abram@uchicago.edu).

