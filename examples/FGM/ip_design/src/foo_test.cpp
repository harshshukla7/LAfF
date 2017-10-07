/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"



void foo	(	
				uint32_t byte_laff_in_in_offset,
				uint32_t byte_laff_out_out_offset,
				volatile data_t_memory *memory_inout);


using namespace std;
#define BUF_SIZE 64

//Input and Output vectors base addresses in the virtual memory
#define laff_in_IN_DEFINED_MEM_ADDRESS 0
#define laff_out_OUT_DEFINED_MEM_ADDRESS (LAFF_IN_IN_LENGTH)*4


int main()
{

	char filename[BUF_SIZE]={0};

    int max_iter;

	uint32_t byte_laff_in_in_offset;
	uint32_t byte_laff_out_out_offset;

	int32_t tmp_value;

	//assign the input/output vectors base address in the DDR memory
	byte_laff_in_in_offset=laff_in_IN_DEFINED_MEM_ADDRESS;
	byte_laff_out_out_offset=laff_out_OUT_DEFINED_MEM_ADDRESS;

	//allocate a memory named address of uint32_t or float words. Number of words is 1024 * (number of inputs and outputs vectors)
	data_t_memory *memory_inout;
	memory_inout = (data_t_memory *)malloc((LAFF_IN_IN_LENGTH+LAFF_OUT_OUT_LENGTH)*4); //malloc size should be sum of input and output vector lengths * 4 Byte

	FILE *stimfile;
	FILE * pFile;
	int count_data;


	float *laff_in_in;
	laff_in_in = (float *)malloc(LAFF_IN_IN_LENGTH*sizeof (float));
	float *laff_out_out;
	laff_out_out = (float *)malloc(LAFF_OUT_OUT_LENGTH*sizeof (float));


	////////////////////////////////////////
	//read laff_in_in vector

	// Open stimulus laff_in_in.dat file for reading
	sprintf(filename,"laff_in_in.dat");
	stimfile = fopen(filename, "r");

	// read data from file
	ifstream input1(filename);
	vector<float> myValues1;

	count_data=0;

	for (float f; input1 >> f; )
	{
		myValues1.push_back(f);
		count_data++;
	}

	//fill in input vector
	for (int i = 0; i<count_data; i++)
	{
		if  (i < LAFF_IN_IN_LENGTH) {
			laff_in_in[i]=(float)myValues1[i];

			#if FLOAT_FIX_LAFF_IN_IN == 1
				tmp_value=(int32_t)(laff_in_in[i]*(float)pow(2,(LAFF_IN_IN_FRACTIONLENGTH)));
				memory_inout[i+byte_laff_in_in_offset/4] = *(uint32_t*)&tmp_value;
			#elif FLOAT_FIX_LAFF_IN_IN == 0
				memory_inout[i+byte_laff_in_in_offset/4] = (float)laff_in_in[i];
			#endif
		}

	}


	/////////////////////////////////////
	// foo c-simulation
	
	foo(	
				byte_laff_in_in_offset,
				byte_laff_out_out_offset,
				memory_inout);
	
	
	/////////////////////////////////////
	// read computed laff_out_out and store it as laff_out_out.dat
	pFile = fopen ("laff_out_out.dat","w+");

	for (int i = 0; i < LAFF_OUT_OUT_LENGTH; i++)
	{

		#if FLOAT_FIX_LAFF_OUT_OUT == 1
			tmp_value=*(int32_t*)&memory_inout[i+byte_laff_out_out_offset/4];
			laff_out_out[i]=((float)tmp_value)/(float)pow(2,(LAFF_OUT_OUT_FRACTIONLENGTH));
		#elif FLOAT_FIX_LAFF_OUT_OUT == 0
			laff_out_out[i]=(float)memory_inout[i+byte_laff_out_out_offset/4];
		#endif
		
		fprintf(pFile,"%f \n ",laff_out_out[i]);

	}
	fprintf(pFile,"\n");
	fclose (pFile);
		

	return 0;
}
