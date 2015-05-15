## Collect some basic benchmarks on the impact of multiple samples
## Looks slow and linear

1;

pkg load qcs;


nummeas = 30;
samptime = zeros(1,nummeas);

U = QFT(16);

for i = 1:30
  tic;
  v = simulate(U,1,"samples",i);
  samptime(i) = toc;
endfor

samptime = samptime-samptime(1);

fid = fopen("samptime.csv","a");
dlmwrite(fid,samptime,",");
fclose(fid);
