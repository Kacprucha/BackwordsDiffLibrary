# BackwordsDiffLibrary

## Overview

BackwordsDiffLibrary is a Julia library that provides backwords differentiation. It is designed to efficiently compute gradients for functions.

## Features

- **Reverse-Mode Differentiation**: Compute gradients efficiently for functions with many inputs.
- **Performance**: Optimized for speed and low memory usage.
- **Flexibility**: Suitable for both simple functions and complex models.

## Installation

Ensure you have Julia installed (version 1.11.3). Install Julia's package manager. In the Julia REPL, run:

```julia
using Pkg
Pkg.add("BackwordsDiffLibrary")
```

## Usage

Import the library in your Julia script:

```julia
using BackwordsDiffLibrary
```

Define your function using ```@diffunction``` macro. Hear is example of how to use it:

```julia
# Example function: f(x) = 2x + cos(xy + 0.5x)^2
@diffunction f(x) = 2x + cos(xy + 0.5x)^2
```

The important part is that the function has to be defined in the form of f(args...) = ...

After defining the function we can use ```grad``` function that takes as first argument function that gradient we want to calculate and as second a point in witch we want to calculate it. The point is stored as a Vector. Hear is an example of using it:

```julia
# Compute gradient at (x = 2.0, y = 5.0)
input_vals = [2.0, 5.0]
computed_gradient = grad(f, input_vals)
```

## Examples

In folder examples are 3 separate notebooks with difrent cases showing that library calculate gradient correctly. Aditionaly there is simple mlp network implementation that use this library, so you can see how the library can be used in pratice.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
