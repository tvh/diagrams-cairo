import Graphics.Rendering.Diagrams
import Graphics.Rendering.Diagrams.Transform

import Diagrams.Backend.Cairo.CmdLine

import Diagrams.TwoD
import Diagrams.Combinators
import Diagrams.Path
import Diagrams.Segment

import Data.VectorSpace

type D = Diagram Cairo R2

p = stroke $ fromSegments [Linear (1.0,0.0),Linear (0.0,1.0)]
bez = stroke $ fromSegments [Cubic (1.0,0.0) (0.0,1.0) (1.0,1.0)]
ell = scaleX 2 $ scaleY 0.5 circle

b1 = runBoundsTest square
b2 = runBoundsTest circle
b3 = runBoundsTest p
b4 = runBoundsTest bez
b5 = runBoundsTest ell
b6 = runBoundsTest (scale 2 square)
b7 = runBoundsTest (scale 2 circle)
b8 = runBoundsTest (scale 2 p)
b9 = runBoundsTest (scale 2 bez)
b10 = runBoundsTest (scale 2 ell)
b11 = runBoundsTest (rotate (pi/6) square)
b12 = runBoundsTest (scaleX 3 $ scaleY 2 $ bez)
b13 = runBoundsTest (translate (1,0) square)
b14 = runBoundsTest (rotate (2*pi/3) ell)

runBoundsTest :: D -> D
runBoundsTest = sampleBounds2D 10

sampleBounds2D :: Int -> D -> D
sampleBounds2D n d = foldr atop d bs
    where b  = getBounds (bounds d)
          bs = [stroke $ mkLine (P $ s *^ v) (perp v) | v <- vs, let s = b v]
          vs = [(2 * cos t, 2 * sin t) | i <- [0..n]
                                       , let t = ((fromIntegral i) * 2.0 * pi) / (fromIntegral n)]
          mkLine a v = setStart a $ fromSegments [Linear v]
          perp (x,y) = (-y,x)
          getBounds (Bounds f) = f

main = defaultMain b12
