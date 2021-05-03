# AdobeHexGame

Hexagonal grids are fun!

To try it out, I did most of my development/testing in iPhone simulators (e.g. iPhone 12 Pro, iPhone SE, etc.); iPad simulators work but if I hadn't disallowed iPads in the project settings, the circles come out looking like pillows :smiley:

The meat and potatoes of this project can be found in [HexGrid.swift](https://github.com/dautermann/AdobeHexGame/blob/main/AdobeHexGame/Model/HexGrid.swift).  

## The process of the app vs
The view controller is essentially a placeholder (because if I'm feeling ambitous, I could actually turn this demo app into an open source version of the actual game that was screenshotted in the exercise), but the flow of the app is essentially as follows:
* The view controller instantiates the HexGrid model, 
* HexGrid assigns columns and rows to the 19 HexCells (or circles), 
* runs a neighbor determining algorithm on these cells, 
* then comes up with tiles of three circles (which I originally named Triplets).
* In the meantime, a "random" class comes up with random x & y's to derive Z's, plus one bonus number for the non-tiled left over circle.
* And then this collection is applied to the tiles!

## the process of solving the problem

I realized pretty quickly this was going to be a fun puzzle to solve when coming up with a non-brute-force algorithm for determining circle neighbors in a hex grid turned out to be suprisingly tricky.  I started by referring to StackOverflow (where I do [a lot of participation on my own](https://stackoverflow.com/users/981049/michael-dautermann)) and Googling, and quickly settled on a coordinate philosophy.  
The kind of coordinate system I'm using can be referred to as [offset coordinates](https://www.redblobgames.com/grids/hexagons/#coordinates-offset). The odd rows are offset (and shoved right).  The [neighbor finding algorithm can be found here](https://www.redblobgames.com/grids/hexagons/#neighbors-offset).

To come up with the adjacent neighbor algorithm, I referred to this [extremely useful documentation](https://www.redblobgames.com/grids/hexagons/).  

Added some tests, too!
