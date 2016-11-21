
Modeled after this game: http://www.cybersalt.org/games/cat-herding

## Search Algorithms

### Different Options

Breadth-first. Explores equally in all directions.

Dijkstra's. Prioritize paths for exploration, giving them costs. Since
movement costs don't vary in our game (i.e. don't have a weighted
graph), we won't use this algorithm.

A*. Dijkstra's but optimized for a single destination, prioritizing
paths which seem to lead closer to the goal.

### Breadth-First

Keep track of an expanding ring called a 'frontier'.

Here's some pythonic pseudo-code.

```
frontier = Queue()
frontier.put(start)
came_from = {}
came_from[start] = None   # came_from[loc] - where we came from. breadcrumbs.

while not frontier.empty():
   current = frontier.get()
   # if current in goals:
   #    break
   for neighbor in graph.neighbors(current):
      if neighbor not in came_from:
         frontier.put(neighbor)
         came_from[neighbor] = current
```

Keep an explicit list of all "goal" nodes (along edge of map).



### Graph Library

http://package.elm-lang.org/packages/sgraf812/elm-graph/1.1.2/


### Queue

#### Regular LIFO Queue

http://package.elm-lang.org/packages/martinsk/elm-datastructures/latest/Queue
https://github.com/imeckler/queue

#### Priority Queue Library

https://github.com/rhofour/elm-pairing-heap/blob/1.0.0/PairingHeap.elm


## Display

Board: 11 rows, each 11 hexagons wide.
Hexagons: http://package.elm-lang.org/packages/etaque/elm-hexagons/latest/Hexagons

Cat: can face 6 different directions.
Either moving in that direction, or stationary.

Pointy-topped hexagons (for horizontal grid).

Given a radius, we can compute the dimensions (height and width) of a
hex. Compute these dimensions in pixels, and you're a good way toward
drawing them.

