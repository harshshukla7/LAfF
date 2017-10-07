/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include <vector>
#include <iostream>
#include <stdio.h>
#include "math.h"
#include "ap_fixed.h"
#include <stdint.h>
#include <cstdlib>
#include <cstring>
#include <stdio.h>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <hls_math.h>


// Define FLOAT_FIX_VECTOR_NAME=1 to enable  fixed-point (up to 32 bits word length) arithmetic precision or 
// FLOAT_FIX_VECTOR_NAME=0 to enable floating-point single arithmetic precision.
#define FLOAT_FIX_LAFF_IN_IN 0
#define FLOAT_FIX_LAFF_OUT_OUT 0

//Input vectors INTEGERLENGTH:
#define LAFF_IN_IN_INTEGERLENGTH 0
//Output vectors INTEGERLENGTH:
#define LAFF_OUT_OUT_INTEGERLENGTH 0


//Input vectors FRACTIONLENGTH:
#define LAFF_IN_IN_FRACTIONLENGTH 0
//Output vectors FRACTIONLENGTH:
#define LAFF_OUT_OUT_FRACTIONLENGTH 0


//Input vectors size:
#define LAFF_IN_IN_LENGTH 10
//Output vectors size:
#define LAFF_OUT_OUT_LENGTH 10




typedef float data_t_memory;


#if FLOAT_FIX_LAFF_IN_IN == 1
	typedef ap_fixed<LAFF_IN_IN_INTEGERLENGTH+LAFF_IN_IN_FRACTIONLENGTH,LAFF_IN_IN_INTEGERLENGTH,AP_TRN,AP_WRAP> data_t_laff_in_in;
	typedef ap_fixed<32,32-LAFF_IN_IN_FRACTIONLENGTH,AP_TRN,AP_WRAP> data_t_interface_laff_in_in;
#endif
#if FLOAT_FIX_LAFF_IN_IN == 0
	typedef float data_t_laff_in_in;
	typedef float data_t_interface_laff_in_in;
#endif
#if FLOAT_FIX_LAFF_OUT_OUT == 1 
	typedef ap_fixed<LAFF_OUT_OUT_INTEGERLENGTH+LAFF_OUT_OUT_FRACTIONLENGTH,LAFF_OUT_OUT_INTEGERLENGTH,AP_TRN,AP_WRAP> data_t_laff_out_out;
	typedef ap_fixed<32,32-LAFF_OUT_OUT_FRACTIONLENGTH,AP_TRN,AP_WRAP> data_t_interface_laff_out_out;
#endif
#if FLOAT_FIX_LAFF_OUT_OUT == 0 
	typedef float data_t_laff_out_out;
	typedef float data_t_interface_laff_out_out;
#endif
