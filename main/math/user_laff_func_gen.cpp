for(i=0; i<5; i++){ 
#pragma HLS PIPELINE 
	g[i] = h[i];
	b[i] = a[i];
	d[i] = a[i] + b[i];
}