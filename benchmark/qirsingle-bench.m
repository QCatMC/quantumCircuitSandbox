## Collect some benchmark data on the simulation of QIR single (H) for
## increasing number of qubits

1;

pkg load qcs;

## Things get dicey around 14 bits on my laptop
##  The computed matrix is ~2GB in size so...
bits = 16;

simtimes = zeros(1,bits);

for b = 0:(bits-1)
  U = [QIR,QIR("H",[0:b])];
  tic;
  v = simulate(U,1);
  simtimes(b+1) = toc;
endfor

fid = fopen("H-simtimes.csv","a");
dlmwrite(fid,simtimes,",");
fclose(fid);
