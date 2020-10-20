# Statistics and Machine Learning in OCaml

## Motivation

I absolutely love statistics and want to gain more experience with hands-on machine learning. Functional programming is also a difficult (being self-taught), but extremely rewarding challenge. 

## Installation

1. `apt-get install opam m4`

2. `opam init` For WSL, include `--disable-sandboxing`

3. `eval $(opam env)` to update shell environment

4. (_Optional_) `opam switch create 4.11.1` to change switch (version)

5. (_Optional_) `opam switch set-description "<desc>"` to add a description to existing switch

6. `opam install core dune utop merlin owl owl-base owl-top owl-zoo` to install packages (I think these are all the necessary ones)

## Basic Opam/Dune Commands

```shell
eval $(opam env)
```

```shell
opam list

opam switch
```

```shell
dune clean

dune build

dune exec ./<EXECUTABLE>
```

## Utop Commands

```ocaml
#require <library> ;;

open <library> ;;
```

## Build

Dune can build libraries or executables for OCaml via the `dune` file. This file creates executables for each of the examples and includes the `owl` package. Individual executables can be run in the above code block. The `dune` file also silences certain warnings. The ones commented (33 = unused openings, 35 = unused for loop indices) I ran into while testing and the rest are copied from the [Jane Street workshop](https://github.com/ryanluk4/learn-ocaml-workshop).

## Examples

### Coins

This example simulates flipping a coin `num_trials` number of times to estimate probability. The code keeps track of the number of heads (or tails) over time, representing the Frequentist probability (Monte Carlo). Thus, the probability may deviate from the expected value, but the long-term probability will be the familiar `p = 0.50`. This method can be useful if you do not know the distribution for the outcomes (like a weighted situation, see `dice.ml`).

The expected value can be derived from the Pascal-Fermat definition of probability, where the number of successes is compared to the number of elemental outcomes. In a single coin flip, you can label one success (either heads or tails) out of two elemental outcomes (heads and tails).

This expected value or distribution for binary outcomes can also be modeled by the Bernoulli distribution:

`P(X) = mu^x * (1 - mu)^{1-x} where P(X = 1) = mu and X in {0, 1}`

To run:

```shell
dune clean

dune build coins.exe

dune exec ./coins.exe
```

### Dice

This example simulates rolling a weighted dice `num_trials` number of times to estimate the average value. The code keeps track of the rolled value over time, representing a Frequentist approach (Monte Carlo). This method can be useful if you do not know the distribution for the outcomes.

The code itself is similar to `coins.ml`, except for how the roll values are calculated. In Python, this can easily be achived using NumPy's `np.random.choice(<choices>, <probabilities>)` command. To produce this from scratch, I created some saving values via reference. The "roll" portion of the code comes from a random [0,1] float value. The random value relates to the weights in an additive sense, similar to a cumulative probability. The weights and roll value are summed until the weights reach the random value. Because of the random process, all values are equally likely, except certain values can have larger ranges (corresponding to the increased weight).

The expected value can be found by taking the dot product of the weights and values [1,2,3,4,5,6]:

`E(X) = theta \dot X`

To run:

```shell
dune clean

dune build dice.exe

dune exec ./dice.exe
```

### CNN

This example simulates images recognition on a CNN for the CIFAR-10 dataset, using the `Neural.S` module from the `owl` library. This is a replication of a machine learning class I took, so it includes different layers (convolution, fully-connected, max pooling, dropout, softmax), parameters (learning rate, batch, activation functions), and CNN concepts (layer sizes, filter sizes, padding).

One network is the exact CNN I made for the class, converted from Python (Tensorflow/Keras). This model achieved around 0.76 accuracy and validation on the Python dataset. I only changed the optimizer/learning rate to Adagrad, from SGD.

The other network is more straightforward, with more even convolution layers, less dense layers, and less dropout. This model achieves lower loss values than the one above, which is most likely due to the structure and how the data is evaluated (I am not sure how the training works on the backend). 

```shell
dune clean

dune build cnn.exe

dune exec ./cnn.exe
```

### Gradient Descent

This example simulates the gradient descent algorithm to find a local minimum via recursion. The gradient is calculated on each iteration with included paramters. The algorithm is given by:

`x <- x - eta * gradient`

A more general format for weights:

`theta_j <- theta_j - alpha * gradient * cost function`

To run:

```shell
dune clean

dune build gradient_descent.exe

dune exec ./gradient_descent.exe
```

### Linear Algebra

This example is a very small collection of linear algebra commands via the `Linalg.D` module. There are also some matrix types and functions in the comments.

```shell
dune clean

dune build linear_algebra.exe

dune exec ./linear_algebra.exe
```

### Dataframe

This example is a very very small collection of dataframe commands via the `Dataframe` module. This is similar to the pandas package in Python.

```shell
dune clean

dune build dataframe.exe

dune exec ./dataframe.exe
```

### Extras

`train.csv` and `test.csv` are basic, one-feature datasets for linear regression - not currently being used