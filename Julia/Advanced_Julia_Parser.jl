abstract Shape

type Position
  x::Real
  y::Real
end

type Circ <: Shape
  center::Position
  radius::Real
end

type Square <: Shape
  upper_left::Position
  length::Real
end

type Rect <: Shape
  upper_left::Position
  width::Real
  height::Real
end
function area(shape::Rect)
      shape.width*shape.height
    end

function area(shape::Circ)
   shape.radius*shape.radius*pi
 end
function area(shape::Square)
  shape.length*shape.length
end
println(area(Rect(Position(1,2),1, 2)))
println(area(Circ(Position(1,2),10)))
println(area(Square(Position(1,2),10)))

function in_shape(shape::Square, position::Position)
       if shape.upper_left.x<=position.x && (shape.upper_left.x+shape.length)>=position.x
         #print("i survive the first if")
          if shape.upper_left.y<=position.y && (shape.upper_left.y+shape.length)>=position.y
            #print("and the second")
            return true
          end
      return false
      end
     return false

    end

    println(in_shape(Square(Position(1,2),10), Position(3,14)))


    function in_shape(shape::Rect, position::Position)
           if shape.upper_left.x<=position.x && (shape.upper_left.x+shape.width)>=position.x
             #print("i survive the first if")
              if shape.upper_left.y<=position.y && (shape.upper_left.y+shape.height)>=position.y
                #print("and the second")
                return true
              end
          return false
          end
         return false

        end

        function in_shape(shape::Circ, position::Position)
        xdist=shape.center.x-position.x
        ydist=shape.center.y-position.y
        temp=sqrt((xdist*xdist)+(ydist*ydist))
        if temp<=shape.radius
              return true
            end
        return false
        end

type Pixel
  r::Real
  g::Real
  b::Real
end
function greyscale(picture::Array{Pixel,2})
  for j = 1:size(picture,2)
    for i = 1:size(picture,1)
        average=(picture[i,j].r+picture[i,j].b+picture[i,j].g)/3
        picture[i,j]=Pixel(average,average, average)
    end
  end
  return picture
end
function invert(picture::Array{Pixel,2})
  for j = 1:size(picture,2)
    for i = 1:size(picture,1)
      red=255-picture[i,j].r
      green=255-picture[i,j].g
      blue=255-picture[i,j].b
      picture[i,j]=Pixel(red,green,blue)
    end
  end
  abstract TreeItem

  type Person <: TreeItem
    name::AbstractString
    birthyear::Integer
    eyecolor::Symbol
    father::TreeItem
    mother::TreeItem
  end

  type Unknown <: TreeItem
  end  
