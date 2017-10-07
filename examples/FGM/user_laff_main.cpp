#include "user_laff_main.h" 
 
 
 
void laff_main_func(real laff_in_in[10], real laff_out_out[10]){
 
    int main_loop_counter;
main_loop: for(main_loop_counter = 0; main_loop_counter < 1000; main_loop_counter++){ 
 
copy_vector(z_prev, z, 5 );
mv_mult(z,y);
vector_scale_add(t, z, lf, 5, 1, -1 );
box_clipping(z, t, 5, -1, 1);
vector_scale_add(y, z, z_prev, 5, 1.9106, -0.91063 );
} 
 
int jj;
printf("z_prev, z, t, y is \n");

for(jj = 0; jj<5; jj++){
 
    printf("%f, %f, %f, %f \n",z_prev[jj], z[jj], t[jj], y[jj]);
}
 
} 
 
 
