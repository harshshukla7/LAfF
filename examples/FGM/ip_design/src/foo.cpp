/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"


void foo_user(  data_t_laff_in_in laff_in_in_int[LAFF_IN_IN_LENGTH],
				data_t_laff_out_out laff_out_out_int[LAFF_OUT_OUT_LENGTH]);


void foo	(
				uint32_t byte_laff_in_in_offset,
				uint32_t byte_laff_out_out_offset,
				volatile data_t_memory *memory_inout)
{

	#ifndef __SYNTHESIS__
	//Any system calls which manage memory allocation within the system, for example malloc(), alloc() and free(), must be removed from the design code prior to synthesis. 

	data_t_interface_laff_in_in *laff_in_in;
	laff_in_in = (data_t_interface_laff_in_in *)malloc(LAFF_IN_IN_LENGTH*sizeof(data_t_interface_laff_in_in));
	data_t_interface_laff_out_out *laff_out_out;
	laff_out_out = (data_t_interface_laff_out_out *)malloc(LAFF_OUT_OUT_LENGTH*sizeof(data_t_interface_laff_out_out));

	data_t_laff_in_in *laff_in_in_int;
	laff_in_in_int = (data_t_laff_in_in *)malloc(LAFF_IN_IN_LENGTH*sizeof (data_t_laff_in_in));
	data_t_laff_out_out *laff_out_out_int;
	laff_out_out_int = (data_t_laff_out_out *)malloc(LAFF_OUT_OUT_LENGTH*sizeof (data_t_laff_out_out));

	#else
	//for synthesis

	data_t_interface_laff_in_in  laff_in_in[LAFF_IN_IN_LENGTH];
	data_t_interface_laff_out_out  laff_out_out[LAFF_OUT_OUT_LENGTH];

	static data_t_laff_in_in  laff_in_in_int[LAFF_IN_IN_LENGTH];
	data_t_laff_out_out  laff_out_out_int[LAFF_OUT_OUT_LENGTH];

	#endif

	#if FLOAT_FIX_LAFF_IN_IN == 1
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_laff_in_in_offset & (1<<31)))
	{
		memcpy(laff_in_in,(const data_t_memory*)(memory_inout+byte_laff_in_in_offset/4),LAFF_IN_IN_LENGTH*sizeof(data_t_memory));

    	//Initialisation: cast to the precision used for the algorithm
		input_cast_loop_laff_in:for (int i=0; i< LAFF_IN_IN_LENGTH; i++)
			laff_in_in_int[i]=(data_t_laff_in_in)laff_in_in[i];

	}
	

	#elif FLOAT_FIX_LAFF_IN_IN == 0
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_laff_in_in_offset & (1<<31)))
	{
		memcpy(laff_in_in_int,(const data_t_memory*)(memory_inout+byte_laff_in_in_offset/4),LAFF_IN_IN_LENGTH*sizeof(data_t_memory));
	}

	#endif



	///////////////////////////////////////
	//USER algorithm function (foo_user.cpp) call
	//Input vectors are:
	//laff_in_in_int[LAFF_IN_IN_LENGTH] -> data type is data_t_laff_in_in
	//Output vectors are:
	//laff_out_out_int[LAFF_OUT_OUT_LENGTH] -> data type is data_t_laff_out_out
	foo_user_top: foo_user(	laff_in_in_int,
							laff_out_out_int);


	#if FLOAT_FIX_LAFF_OUT_OUT == 1
	///////////////////////////////////////
	//store output vectors to memory (DDR)

	if(!(byte_laff_out_out_offset & (1<<31)))
	{
		output_cast_loop_laff_out: for(int i = 0; i <  LAFF_OUT_OUT_LENGTH; i++)
			laff_out_out[i]=(data_t_interface_laff_out_out)laff_out_out_int[i];

		//write results vector y_out to DDR
		memcpy((data_t_memory *)(memory_inout+byte_laff_out_out_offset/4),laff_out_out,LAFF_OUT_OUT_LENGTH*sizeof(data_t_memory));

	}
	#elif FLOAT_FIX_LAFF_OUT_OUT == 0
	///////////////////////////////////////
	//write results vector y_out to DDR
	if(!(byte_laff_out_out_offset & (1<<31)))
	{
		memcpy((data_t_memory *)(memory_inout+byte_laff_out_out_offset/4),laff_out_out_int,LAFF_OUT_OUT_LENGTH*sizeof(data_t_memory));
	}

	#endif




}
