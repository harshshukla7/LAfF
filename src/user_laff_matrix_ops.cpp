// Simple matrix operation library

// NOTE : Add return vectors are assumed to be allocated by caller
// NOTE : No memory violation checks are made


/*************************************************************
 ********** Things to check
 *
 *1. vector norm 1 is wrong I think.
 *
 ************************************************************/
#include <math.h>
#include <string.h>
#include <stdio.h>
#include "user_matrix_ops.h"

static int i;


void proj_positive(real *xproj, const real *x, const int len)
{
#pragma HLS INLINE
    
    loop_proj_positve_matops: for(i=0; i<len; i++){
#pragma HLS PIPELINE
        
        if (x[i] < 0.0){
            xproj[i] = 0.0;
        }
        else{
            
            xproj[i] = x[i];
        }
        
    }
    
    
    
}

real norm_two(const real *x, const int len)
{ real nsqrt;
  real n = 0.0;
  loop_vec_norm_two_matops:  for(int i=0; i<len; i++) n += x[i]*x[i];
  nsqrt = sqrt(n);
  return nsqrt;
}

real sum_absolute(const real *x, const int len)
{
    real z = 0.0;
    loop_sum_absolute_mops:    for(i=0; i<len; i++){
        z = z + hls::abs(x[i]);
    }
    return z;
}


void copy_vector( real *y, const real *x, int len){
    
    loop_copy_vector_matops:   for(i=0; i<len; i++){
#pragma HLS PIPELINE
        
        y[i] = x[i];
    }
}

void box_clipping(real *xproj, const real *x, const int len, const real lb, const real ub){
    
#pragma HLS INLINE
    
    loop_clipping_matops: for(i=0; i<len; i++){
#pragma HLS PIPELINE
        
        if (x[i] < lb){
            xproj[i] = lb;
        }
        
        else if(x[i] > ub){
            
            xproj[i] = ub;
        }
        
        else{
            
            xproj[i] = x[i];
        }
        
    }
    
    
}


void vector_scale_add(real *z, real *y, real *x, const int len, const real x_scale, const real y_scale){
    
    
   #pragma HLS INLINE
    
    loop_vector_scale_add_matops: for(i=0; i<len; i++){
#pragma HLS PIPELINE
        
        
        z[i] = x_scale*x[i] + y_scale*y[i];
    }
    
    
    
    
    
}

void vector_min(real *z, real *x, real *y, const int len){
    
    #pragma HLS INLINE
    
    loop_vector_min_matops: for(i=0; i<len; i++){
#pragma HLS PIPELINE
        
        if (x[i] < y[i]){
            z[i] = x[i];
        }
        
        
        else{
            
            z[i] = y[i];
        }
        
    }
    

    
}


void vector_max(real *z, real *x, real *y, const int len){
    
    #pragma HLS INLINE
    
    loop_vector_max_matops: for(i=0; i<len; i++){
#pragma HLS PIPELINE
        
        if (x[i] < y[i]){
            z[i] = y[i];
        }
        
        
        else{
            
            z[i] = x[i];
        }
        
    }
    

    
}
