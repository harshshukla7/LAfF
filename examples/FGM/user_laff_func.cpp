
void mv_mult(data_t_laff_out_out y_out[SIZE_row],data_t_laff_out_out x_in[SIZE_col])
{
	int i, i_acc, j, k;
	long int j_offset;

	// matrix 
	static data_t_laff_out_out H[PAR][PART_SIZE*SIZE_col] = {0.7134612331243317,-0.2449772255234730,-0.2074533743834119,-0.2229739475252920,-0.1761836828001377,-0.2449772255234730,0.7197236602269881,-0.2008293502453136,-0.2231334773390344,-0.1843415884186970,-0.2074533743834119,-0.2008293502453136,0.7696156482482046,-0.1482123392806064,-0.1145828992365480,-0.2229739475252920,-0.2231334773390344,-0.1482123392806064,0.7942818470035952,-0.1548987341438808,-0.1761836828001377,-0.1843415884186970,-0.1145828992365480,-0.1548987341438808,0.8600392906712542,};
	#pragma HLS ARRAY_PARTITION variable=H complete dim=1
	static data_t_laff_out_out H_rem[REM_PART_SIZE*SIZE_col] = {};

	// local copy of the output vector
	data_t_laff_out_out y_local[PAR][PART_SIZE][ACC_SIZE];
	#pragma HLS ARRAY_PARTITION variable=y_local complete dim=1
	#pragma HLS RESOURCE variable=y_local core=RAM_2P_LUTRAM
	data_t_laff_out_out y_local_rem[REM_PART_SIZE][ACC_SIZE] ;
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
