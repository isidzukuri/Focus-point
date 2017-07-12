# Focus-point
Calculates coordinates of area around given point inside given container. Possible usage: retrieve parameters for image crop cropping. Works similar to https://jonom.github.io/jquery-focuspoint/demos/helper/index.html. Returns
It know how to:
- change area size ptoportionaly if container is bigger than area
- move area if it crosses image's borders
- makes area bigger if its possible. if area size < container size and gap between area border and container border present will increase area size proportionaly

Usage:
`
prms = {img_width: 1500, img_height: 1000, frame_height: 250, frame_width: 250}
instance = FocusPoint.new(prms)
instance.coords_for_crop_around(x: 750, y: 500)
#{:x=>250, :y=>0, :width=>1000, :height=>1000}
`
