
facts("Pruebas del método matricial") do
	nn = 10 ; neighs = 1; p = 0.
	w = SmallWorldNet(nn, neighs, p)

	@fact meanFPmatrix(w)[1:6] --> roughly( [0.0, 9.0, 16.0, 21.0, 24.0, 25.0] ; atol=1e-1)

end
