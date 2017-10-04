copy_vector(z_prev, z, 5 );
mv_mult(y,z)
vector_scale_add(t, z, lf, 5, 1, -1 );
box_clipping(z, t, 5, -1, 1);
vector_scale_add(y, z, z_prev, 5, 1.9335, -0.9335 );
