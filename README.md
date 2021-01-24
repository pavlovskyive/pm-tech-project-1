# Parimatch Tech Academy

## Project 1

### Task:

#### The structure is taken as a basis:

1. Universe

2. Galaxies

- Type

- Age

3. Star-planetary systems

- Host star

- Planets orbiting the star

4. Stars

- Type

- Stage of evolution

- Mass

- Temperature

- Radius

- Luminosity

5. Planets

- Type

- Weight

- Temperature

- Radius

- Sattelites
 
#### Requirements (Functional)

1. The universe is a set of galaxies

- Every 10 seconds a new galaxy appears in the universe (the type of galaxy is set randomly)

- Every 30 seconds, 2 randomly selected galaxies over 3 minutes old collide
 
2. Galaxy - a set of star-planetary systems
 
- Every 10 seconds, a new star-planetary system with a host star appears in the galaxy

- When galaxies collide, they merge into a new galaxy with the loss of 10% of star-planetary systems (systems are destroyed randomly). The type and age of the new galaxy is the same as the type and age of the heavier galaxy upon collision.
 
3. Star-planetary systems - a set of stars and planets
 
- Every 10 seconds a new planet appears in the system (up to 9 planets in the system)
 
4. Stars

- The star is initialized with random values of its numeric parameters (from 1 to 100) and a random type

- Stages of evolution of a star: young star, old star, final stage: dense dwarf or black hole, depending on the mass and radius (the boundaries of mass and radius for transformation into a black hole are created during the initialization of the universe)

- Every 60 seconds, the star moves to the next stage of its evolution

- When a star turns into a black hole, the star-planetary system ceases to exist. In this case, the black hole remains in the galaxy and stops evolving.
 
5. Planets

- When a planet appears, a random number of satellites is created for it (from 0 to 5)

- When a black hole appears in the star-planetary system, its planets (and their satellites) cease to exist
 
#### Requirements (Non-functional)

App must use 1 centralized timer to count time

To transmit the current time, the universe uses a principle similar to Chain Of Responsibility

Implement lifecycle management of systems using a state machine

Changes to any subsystem must synchronize with the state of the parent system

Using multithreading

Using SOLID principles
 
#### Requirements (UI)


Use UICollectionView to display all entities with custom layout (at the developer's choice)

Each level of the hierarchy -- separate screen (UIViewController)

Implement processing of the life cycle of the current level of the hierarchy (for example, deleting it). One example: the user is on the screen of a star-planetary system and at the same time the parent galaxy collides with another galaxy, as a result of which the current star-planetary system is randomly selected for destruction. It is necessary to correctly implement this state from the point of view of the UI (for example, a placeholder or an alert with a return to a higher level of the hierarchy).

#### Bonus

Implementation of the function of accelerating the flow of time in the Universe

Implementation of the function of time reversal in the Universe
