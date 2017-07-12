class FocusPoint

  attr_reader  :frame_data, :frame_width, :frame_height

  def initialize params
    @img_width = params[:img_width]
    @img_height = params[:img_height]
    # - if frame size > img size change frame size proportionaly
    frame_params(params[:frame_width].to_f, params[:frame_height].to_f)
  end

  def coords_for_crop_around params
    @point_x = params[:x]
    @point_y = params[:y]
    validate_point()

    x1, y1, x2, y2 = draw_frame()
    @frame_data = { 
      x:x1, 
      y:y1, 
      width:(x2 - x1), 
      height:(y2 - y1)
    }
    enlarge_frame(x1, y1, x2, y2)

    frame_data
  end

  def draw_frame
    frame_half_w = (frame_width/2).to_i
    frame_x_left = point_x - frame_half_w
    frame_x_right = point_x + frame_half_w 

    # - if frame border dont fit in image adjust it 
    if frame_x_left < 0
      frame_x_right += -(frame_x_left) 
      frame_x_left = 0
    end

    if frame_x_right > img_width
      diff = frame_x_right - img_width
      frame_x_left -= frame_x_right - img_width 
      frame_x_right = img_width
    end


    frame_half_h = (frame_height/2).to_i
    frame_y_top = point_y - frame_half_h
    frame_y_bottom = point_y + frame_half_h

    if frame_y_top < 0
      frame_y_bottom += -(frame_y_top) 
      frame_y_top = 0
    end

    if frame_y_bottom > img_height
      frame_y_top -= frame_y_bottom - img_height 
      frame_y_bottom = img_height
    end

    return frame_x_left, frame_y_top, frame_x_right, frame_y_bottom
  end

  def enlarge_frame x1, y1, x2, y2
    # - if frame size < img size and gap between frame border and image border present increase frame size proportionaly
    if x1 > 0 && x2 < img_width && y1 > 0 && y2 < img_height 
      values = [
        x1.to_f/frame_data[:width], 
        y1.to_f/frame_data[:height], 
        (img_width - x2).to_f/frame_data[:width], 
        (img_height - y2).to_f/frame_data[:height]
      ]
      ratio = values.min
      pixels_x = (frame_data[:width].to_f * ratio).to_i
      pixels_y = (frame_data[:height].to_f * ratio).to_i
      
      frame_data[:x] -= pixels_x
      frame_data[:width] += pixels_x*2

      frame_data[:y] -= pixels_y
      frame_data[:height] += (pixels_y*2).to_i 
    end
  end

  private

  attr_accessor :img_width, :img_height, :point_x, :point_y, :frame_data

  def validate_point
    raise "Point outside the map." if !point_x || !point_y || point_x < 0 || point_x > img_width || point_y < 0 || point_y > img_height
  end

  def frame_params width, height
    if width > img_width
      w_ratio = width/img_width
      width = img_width
      height = height/w_ratio
    end

    if height > img_height
      h_ratio = height/img_height
      height = img_height
      width = width/h_ratio
    end

    @frame_width = width.to_i
    @frame_height = height.to_i    
  end

end