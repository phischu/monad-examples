# Example uses of monads

What are monads and why should I care? This repository answers this question by showcasing a selection of examples.

Each example is in a `...-example` subfolder. For example the example for software transactional memory (STM) is in [`stm-example/Main.hs`](stm-example/Main.hs).

See also my [related blog post](https://haskellexists.blogspot.com/2017/02/ten-example-uses-of-monads.html).

## Installation

Tested with cabal-install-2.2, GHC 8.2 and GHC 8.4 and Stackage lts-12.13 on Ubuntu 16.04.

Install with cabal

```
git clone https://github.com/phischu/monad-examples
cd monad-examples
cabal sandbox init
cabal install
cabal configure
cabal build
```

or with stack

```
git clone https://github.com/phischu/monad-examples
cd monad-examples
stack install
```

## Featured

The ticked examples are camera-ready. The others are in progress.

- [x] [STM](https://hackage.haskell.org/package/stm/docs/Control-Monad-STM.html#t:STM): Software transactional memory for concurrency.
- [ ] [Resource](https://hackage.haskell.org/package/resourcet/docs/Control-Monad-Trans-Resource.html#t:ResourceT): Automatic resource management.
- [x] [(Build) Action](https://hackage.haskell.org/package/shake/docs/Development-Shake.html#t:Action): GNU make embedded in Haskell.
- [x] [Pipe](https://hackage.haskell.org/package/pipes/docs/Pipes.html#t:Pipe): Stream processing.
- [ ] [Process](https://hackage.haskell.org/package/distributed-process/docs/Control-Distributed-Process.html#t:Process): Distributed programming.
- [x] [Probability](https://hackage.haskell.org/package/probability/docs/Numeric-Probability-Distribution.html#t:T): Probability distributions.
- [x] [Scotty](https://hackage.haskell.org/package/scotty/docs/Web-Scotty.html#t:ScottyM): Web server framework.
- [ ] [Relation](https://hackage.haskell.org/package/relational-query/docs/Database-Relational-Query-Monad-BaseType.html#t:Relation): SQL embedded in Haskell.
- [x] [ST](https://hackage.haskell.org/package/base/docs/Control-Monad-ST.html#t:ST): Mutable references.
- [x] [Logic](https://hackage.haskell.org/package/logict/docs/Control-Monad-Logic.html#t:Logic): Backtracking search.
- [x] [Spec](https://hackage.haskell.org/package/hspec-core/docs/Test-Hspec-Core-Spec.html#t:Spec): Test specification.
- [x] [Parser](https://hackage.haskell.org/package/attoparsec/docs/Data-Attoparsec-ByteString.html#t:Parser): Parse binary and textual data.
- [x] [Canvas](https://hackage.haskell.org/package/blank-canvas/docs/Graphics-Blank.html#t:Canvas): Draw on HTML 5 Canvas.

Contributions welcome!
