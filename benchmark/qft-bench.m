## Collect some benchmark data on the construction time for QFT
## and the simulation time of QFT

1;

pkg load qcs;

## Choose maxbits wisely. The simulation time
## grows exponentially with the number of bits.
## key times on i7-4770HQ @ 2.2GHz
## 20 = ~17s, 21 = ~36s, 22= ~1m20s 23= ~3min 24 = ~6m30s
maxbits = 18;

qfttimes = zeros(1,maxbits);
simtimes = zeros(1,maxbits);

for b = 1:maxbits
  tic;
  U = QFT(b);
  qfttimes(b) = toc;
  tic;
  v = simulate(U,1);
  simtimes(b) = toc;
endfor

fid = fopen("qfttimes.csv","a");
dlmwrite(fid,qfttimes,",");
fclose(fid);

fid = fopen("simtimes.csv","a");
dlmwrite(fid,simtimes,",");
fclose(fid);
