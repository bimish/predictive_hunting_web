module RgeoHelper

	def rgeo_get_bounds(geometry)
		# envelope returns a polygon representing the bounding box
		# [(MINX, MINY), (MAXX, MINY), (MAXX, MAXY), (MINX, MAXY), (MINX, MINY)].
		bottomLeft = geometry.envelope().exterior_ring().point_n(0)
		upperRight = geometry.envelope().exterior_ring().point_n(2)
		{
			sw: {
				lat: bottomLeft.y(),
				lng: bottomLeft.x()
				},
			ne: {
				lat: upperRight.y(),
				lng: upperRight.x()
				}
		}
	end

end