function [number_of_Cells] = no_cells_fn(R,A) %R is the cell radius in km / A is the city area in km^2
cell_area=1.5*power(3,0.5)*power(R,2);
number_of_Cells=ceil(A/cell_area); 
end