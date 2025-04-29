# ft_turing

## Objective

The goal of this project is to write a program able to simulate a single headed,
single tape Turing machine from a machine description provided in json.

## Description

The Turing machine is a mathematical model fairly easy to understand and to implement.
A formal definition is available [here](https://plato.stanford.edu/entries/turing-machine/).
The ft_turing project is functionnal implementation of a single infinite tape
Turing machine and written in Ocaml.

## Implementation

The program is able to simulate a single headed and single tape Turing machine from
a json machine description given as a parameter to the program. The json machine
description is sligthly simplier than a formal description of the same machine.

The json fields are defined as follows:

**name:** The name of the described machine

**alphabet:** Both input and work alphabet of the machine merged into a single alphabet
including the blank character.
Each character of the alphabet must be a string of length strictly equal to 1.

**blank:** The blank character, must be part of the alphabet, must NOT be part
of the input.

**states:** The exhaustive list of the machine’s states names.

**initial:** The initial state of the machine, must be part of the states list.

**finals:** The exhaustive list of the machine’s fnial states. This list must be
a sub-list of the states list.

**transitions:** A dictionnary of the machine’s transitions indexed by state name.
Each transition is a list of dictionnaries, and each dictionnary describes the transition
for a given character under the head of the machine.

A transition is defined as follows:

**read:** The character of the machine’s alphabet on the tape under the machine’s
head.

**to_state:** The new state of the machine after the transition is done.

**write:** The character of the machine’s alphabet to write on the tape before moving
the head.

**action:** Movement of the head for this transition, either LEFT, or RIGHT.

## Examples

1. **Unary Sub:** A machine able to compute an unary subtraction.

```shell
$>./ft_turing res/unary_sub.json "111-11="
  *******************************************************************************
  *                                                                             *
  *                                   unary_sub                                 *
  *                                                                             *
  *******************************************************************************
  Alphabet: [ 1, ., -, = ] States : [ scanright, eraseone, subone, skip, HALT ]
  Initial : scanright
  Finals : [ HALT ]
  (scanright, .) -> (scanright, ., RIGHT)
  (scanright, 1) -> (scanright, 1, RIGHT)
  (scanright, -) -> (scanright, -, RIGHT)
  (scanright, =) -> (eraseone, ., LEFT)
  (eraseone, 1) -> (subone, =, LEFT)
  (eraseone, -) -> (HALT, ., LEFT)
  (subone, 1) -> (subone, 1, LEFT)
  (subone, -) -> (skip, -, LEFT)
  (skip, .) -> (skip, ., LEFT)
  (skip, 1) -> (scanright, ., RIGHT)
  *******************************************************************************
  [<1>11-11=.............] (scanright, 1) -> (scanright, 1, RIGHT)
  [1<1>1-11=.............] (scanright, 1) -> (scanright, 1, RIGHT)
  [11<1>-11=.............] (scanright, 1) -> (scanright, 1, RIGHT)
  [111<->11=.............] (scanright, -) -> (scanright, -, RIGHT)
  [111-<1>1=.............] (scanright, 1) -> (scanright, 1, RIGHT)
  [111-1<1>=.............] (scanright, 1) -> (scanright, 1, RIGHT)
  [111-11<=>.............] (scanright, =) -> (eraseone, ., LEFT)
  [111-1<1>..............] (eraseone, 1) -> (subone, =, LEFT)
  [111-<1>=..............] (subone, 1) -> (subone, 1, LEFT)
  [111<->1=..............] (subone, -) -> (skip, -, LEFT)
  [11<1>-1=..............] (skip, 1) -> (scanright, ., RIGHT)
  [11.<->1=..............] (scanright, -) -> (scanright, -, RIGHT)
  [11.-<1>=..............] (scanright, 1) -> (scanright, 1, RIGHT)
  [11.-1<=>..............] (scanright, =) -> (eraseone, ., LEFT)
  [11.-<1>...............] (eraseone, 1) -> (subone, =, LEFT)
  [11.<->=...............] (subone, -) -> (skip, -, LEFT)
  [11<.>-=...............] (skip, .) -> (skip, ., LEFT)
  [1<1>.-=...............] (skip, 1) -> (scanright, ., RIGHT)
  [1.<.>-=...............] (scanright, .) -> (scanright, ., RIGHT)
  [1..<->=...............] (scanright, -) -> (scanright, -, RIGHT)
  [1..-<=>...............] (scanright, =) -> (eraseone, ., LEFT)
  [1..<->................] (eraseone, -) -> (HALT, ., LEFT)
```

## Algorithms

1. **Unary Add**: A machine able to compute an unary addition.

   [implementation](./machines/unary_add.json)

2. **Palindrome:** A machine able to check whether the input is palindrome or not.

   [implementation](./machines/palindrome.json)

3. **Power of n:** A machine able to check whether its input is a form of n zeroes and n ones.

   [implementation](./machines/0n1n.json)

4. **Power of 2n:** A machine able to check if its input has even number of zeroes.

   [implementation](./machines/binary_second.json)

5. **5th Machine:** A machine able to run another machine from its input.

   [implementation](./machines/5th_machine.json)
