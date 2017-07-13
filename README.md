# Focus-point
Calculates coordinates of area around given point inside given container. Possible usage: retrieve parameters for image  cropping. Works similar to https://jonom.github.io/jquery-focuspoint/demos/helper/index.html.
It know how to:
- change area size ptoportionaly if container is bigger than area
- move area if it crosses image's borders
- makes area bigger if its possible. if area size < container size and gap between area border and container border present will increase area size proportionaly

Usage:
```
# img_width - container width
# img_height - container height
# frame_width - width of cropping area
# frame_height - height of cropping area
prms = {img_width: 1000, img_height: 1000, frame_height: 200, frame_width:300}
instance = FocusPoint.new(prms)
# x, y - coordinates of point(left: 50, top: 500) around which area should be built
instance.coords_for_crop_around(x: 50, y: 500) 
#{:x=>0, :y=>400, :width=>300, :height=>200}

prms = {img_width: 1500, img_height: 1000, frame_height: 250, frame_width: 250}
instance = FocusPoint.new(prms)
instance.coords_for_crop_around(x: 750, y: 500)
#{:x=>250, :y=>0, :width=>1000, :height=>1000}
```
