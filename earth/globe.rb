require "matrix"

class Globe

  def initialize

    @camera = Vector[-30,30,15]
    @camera_forward = Vector[-1 * @camera[0], -1 * @camera[1], -1 * @camera[2]]
    @camera_perpendicular = Vector[@camera_forward[1], -1 * @camera_forward[0], 0]
    @pi = 3.14159
    @focal_length = 1000
    @camera_distance_square = sum_of_squares(@camera)
    @radius = 11
    @dnear = nil
    @dfar = nil

  end

  def sum_of_squares vector
    return vector[0]**2 + vector[1]**2 + vector[2]**2
  end

  def magnitude vector
    return Math.sqrt(sum_of_squares(vector))
  end

  # projects u onto v
  def project_vector u, v
    return v.inner_product(u)/magnitude(v)
  end

  # get normalized vector
  def unit_vector vector
    vector_mag = magnitude(vector)
    return [
      vector[0]/vector_mag,
      vector[1]/vector_mag,
      vector[2]/vector_mag
      ]
  end

  #Calculates vector from two points, dictionary form
  def get_vector origin, point
    return point - origin
  end

  #Calculates horizon plane vector (points upward)
  def cam_horizon
    return Vector[
      @camera_forward.cross_product( @camera_perpendicular)[0],
      @camera_forward.cross_product( @camera_perpendicular)[1],
      @camera_forward.cross_product( @camera_perpendicular)[2]
    ]
  end

  def physical_projection point
    #pointVector is a vector starting from the camera and ending at a point in question
    pointVector = get_vector(@camera, point)
    return [
      project_vector( pointVector, @camera_perpendicular), 
      project_vector( pointVector, cam_horizon), 
      project_vector( pointVector, @camera_forward)
    ]
  end

  # draws points onto camera sensor using xDistance, yDistance, and zDistance
  def perspective_projection coords
    scaleFactor = @focal_length / coords[2]
    return [
      coords[0] * scaleFactor,
      coords[1] * scaleFactor
    ]
  end

  #converts spherical coordinates to rectangular coordinates
  def sphere_to_rect r, a, b
    a_rad = a*@pi/180
    b_rad = b*@pi/180
    r_sin_b = r * Math.sin(b_rad)
    return Vector[
      (r_sin_b * Math.cos(a_rad)),
      (r_sin_b * Math.sin(a_rad)), 
      (r * Math.cos(b_rad))
    ]
  end

  #functions for plotting points
  def rect_plot coordinate
    return perspective_projection( physical_projection( coordinate ))
  end

  def sphere_plot coordinate, s_radius
    return rect_plot( sphere_to_rect( s_radius, coordinate[0], coordinate[1]))
  end

  def distance_to_point sphere_point
    point = sphere_to_rect(@radius, spherePoint[0], spherePoint[1])
    ray = get_vector(@camera,point)
    return project_vector(ray, @camera_forward)
  end

  def occlude sphere_point
    point = sphere_to_rect(@radius, sphere_point[0], sphere_point[1])
    ray = get_vector(@camera,point)
    d1 = magnitude(ray) # distance from camera to point
    dot_l = ray.normalize.inner_product(@camera)
        #dot product of unit vector from camera to point and camera vector
 
    determinant = Math.sqrt((dot_l**2 - @camera_distance_square + @radius**2).abs)
    dnear = dot_l * -1 + determinant
    dfar = dot_l * -1 - determinant

    if d1 - 0.0000000001 <= dnear && d1 - 0.0000000001 <= dfar
      return true
    else
      return false
    end
  end

end