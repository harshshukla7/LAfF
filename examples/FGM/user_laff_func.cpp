#include "user_laff_func.h" 
 
 
 

void mv_mult(data_t_laff_in_in y_out[SIZE_row],data_t_laff_in_in x_in[SIZE_col])
{
	int i, i_acc, j, k;
	long int j_offset;

	// matrix 
	static data_t_laff_in_in H[PAR][PART_SIZE*SIZE_col] = {0.8321581346858451,-0.1579429412369132,-0.1137389961749690,-0.1560320538061785,-0.2100666397800313,-0.1579429412369132,0.7003204965122961,-0.1877272512666818,-0.2650637381250781,-0.2319038748311171,-0.1137389961749690,-0.1877272512666818,0.8228208268628170,-0.1240638046257332,-0.1522102329502322,-0.1560320538061785,-0.2650637381250781,-0.1240638046257332,0.6572786346361010,-0.1634230726379047,-0.2100666397800313,-0.2319038748311171,-0.1522102329502322,-0.1634230726379047,0.6511130888992536,};
	#pragma HLS ARRAY_PARTITION variable=H complete dim=1
	static data_t_laff_in_in H_rem[REM_PART_SIZE*SIZE_col] = {};

	// local copy of the output vector
	data_t_laff_in_in y_local[PAR][PART_SIZE][ACC_SIZE];
	#pragma HLS ARRAY_PARTITION variable=y_local complete dim=1
	#pragma HLS RESOURCE variable=y_local core=RAM_2P_LUTRAM
	data_t_laff_in_in y_local_rem[REM_PART_SIZE][ACC_SIZE] ;
	#pragma HLS RESOURCE variable=y_local_rem core=RAM_2P_LUTRAM

	// reset local output vectors
	reset_local_1: for(i = 0; i < PART_SIZE; i++)
	{
		reset_local_2: for(j = 0; j < ACC_SIZE; j++)
		{
			#pragma HLS PIPELINE
			#pragma HLS LOOP_FLATTEN
			reset_local_3: for(k = 0; k < PAR; k++)
			{
				#pragma HLS UNROLL skip_exit_check
				y_local[k][i][j] = 0;
			}
		}
	}
	reset_local_rem_1: for(i = 0; i < REM_PART_SIZE; i++)
	{
		reset_local_rem_2: for(j = 0; j < ACC_SIZE; j++)
		{
			#pragma HLS PIPELINE
			#pragma HLS LOOP_FLATTEN
			#if REM_PART_SIZE
			y_local_rem[i][j] = 0;
			#endif
		}
	}

	// matrix vector multiplication
	mv_1: for(i = 0, i_acc = 0; i < SIZE_col; i++, i_acc++)
	{
		mv_2: for(j = 0, j_offset = 0; j < PART_SIZE; j++, j_offset+=SIZE_col)
		{
			#pragma HLS DEPENDENCE variable=y_local inter distance=8 true
			#pragma HLS DEPENDENCE variable=y_local_rem inter distance=8 true
			#pragma HLS PIPELINE
	
			if (i_acc == ACC_SIZE)
			{
				i_acc = 0;
			}
			mv_3: for(k = 0; k < PAR; k++)
			{
				#pragma HLS UNROLL skip_exit_check
				y_local[k][j][i_acc] += H[k][j_offset+i]*x_in[i];
			}
			if(j < REM_PART_SIZE)
			{
				y_local_rem[j][i_acc] += H_rem[j_offset+i]*x_in[i];
			}
		}
	}

	// fill the output vector from the local output vector
	output_1: for(i = 0; i < ACC_SIZE; i++)
	{
		output_2: for(j = 0; j < PART_SIZE; j++)
		{
			output_3: for(k = 0; k < PAR + !(!(REM_PART_SIZE)); k++)
			{
				#pragma HLS PIPELINE
				#pragma HLS DEPENDENCE variable=y_out inter distance=5 true
				if(i == 0)
				{
					if(k == PAR)
					{
						if(j < REM_PART_SIZE)
						{
							y_out[k*PART_SIZE + j] = y_local_rem[j][i];
						}
					}
					else
					{
						y_out[k*PART_SIZE+j] = y_local[k][j][i];
					}
				}
				else
				{
					if(k == PAR)
					{
						if(j < REM_PART_SIZE)
						{
							y_out[k*PART_SIZE + j] += y_local_rem[j][i];
						}
					}
					else
					{
						y_out[k*PART_SIZE+j] += y_local[k][j][i];
					}
				}
			}
		}
	}


}
