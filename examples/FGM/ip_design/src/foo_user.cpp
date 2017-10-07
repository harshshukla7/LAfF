/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"


void foo_user(  data_t_laff_in_in laff_in_in_int[LAFF_IN_IN_LENGTH],
				data_t_laff_out_out laff_out_out_int[LAFF_OUT_OUT_LENGTH])
{

	///////////////////////////////////////
	//ADD USER algorithm here below:
	//(this is an example)
	alg_0 : for(int i = 0; i <LAFF_OUT_OUT_LENGTH; i++)
	{
		laff_out_out_int[i]=0;
		loop_0_laff_in : for(int i_laff_in = 0; i_laff_in <LAFF_IN_IN_LENGTH; i_laff_in++)
		{
			laff_out_out_int[i]=laff_out_out_int[i] + (data_t_laff_out_out)laff_in_in_int[i_laff_in];
		}
	}

}
