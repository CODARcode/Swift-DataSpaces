/* simple.c
 *
 * Philip Davis 
 *
 * Simple example of DataSpaces usage with MPI. Rank 0 reads an input file and
 * places it in DataSpaces staging. Each rank reads the file and writes a copy
 * to its own output file.
 *////////////////////////////////////////////////////////////////////////////

#include "dataspaces.h"

#include <mpi.h>

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    int err = 0;
    int nprocs, rank;
    MPI_Comm gcomm;
    FILE *input, *output;
    int fsize;
    int i;
    uint64_t lb, ub; // lower-bound, upper-bound
    char *fbuf = NULL;
    char ofname[50];

    MPI_Init(NULL, NULL);

    gcomm = MPI_COMM_WORLD;
    MPI_Comm_size(gcomm, &nprocs);
    MPI_Comm_rank(gcomm, &rank);

    dspaces_init(nprocs, 1, &gcomm, NULL);

    dspaces_lock_on_write("client", &gcomm);

    // Rank 0 reads 'input' file and performs two puts:
    //  - A single int, which is the size of 'input'
    //  - The contents of 'input', as a 1-D array of chars
    if(rank == 0) {
        input = fopen("input", "r");
        if(!input) {
            perror("Error input");
            err = errno;
            //This is a bug, as rank 0 will bypass the write unlock,
            // and so dspaces_finalize will hang if 'input' is not
            // found
            goto finalize;
        }
        fseek(input, 0L, SEEK_END);
        fsize = ftell(input);
        rewind(input);
        fbuf = malloc(fsize);
        for(i = 0; i < fsize; i++) {
            fbuf[i] = fgetc(input);
        }
        lb = ub = 0; // the range from 0 to 0 (a single element)
        //DataSpaces doesn't parse the variable names, this format
        // for metadata is just convenient:
        dspaces_put("SIZE@INPUT", 0, sizeof(fsize), 1, &lb, &ub, &fsize);
        ub = fsize-1;
        dspaces_put("INPUT", 0, sizeof(char), 1, &lb, &ub, fbuf);
        dspaces_put_sync();
    }
    
    dspaces_unlock_on_write("client", &gcomm); 

    dspaces_lock_on_read("client", &gcomm);
    lb = ub = 0;
    // Read the size metadata so non-zero ranks can allocate a buffer.
    dspaces_get("SIZE@INPUT", 0, sizeof(fsize), 1, &lb, &ub, &fsize);
    if(rank != 0) {
        fbuf = malloc(fsize);
    }
    ub = fsize-1;
    dspaces_get("INPUT", 0, sizeof(char), 1, &lb, &ub, fbuf); 
    dspaces_unlock_on_read("client", &gcomm);

    //Each rank creates an ouput file. All output file should be identical.
    sprintf(ofname, "output.%i", rank);
    output = fopen(ofname, "w");
    if(!output) {
        perror(ofname);
        err = errno;
        goto finalize;
    } 
    for(i = 0; i < fsize; i++) {
        if(rank != 0) printf("%c", fbuf[i]);
        fputc(fbuf[i], output);
    }
    
finalize:
    dspaces_finalize();

    MPI_Finalize();

    if(fbuf) {
        free(fbuf);
    }

    return(err);	

}
