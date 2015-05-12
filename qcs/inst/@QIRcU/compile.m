## Copyright (C) 2014  James Logan Mayfield
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{C} =} compile (@var{g},@var{e})
##
##  Computes an equivalent @@QIASMcNot to gate @var{g} when @var{g} is a
##  CNot gate. Otherwise a circuit that approximates @var{g} to within
##  and error of @var{e} is computed. Users should use qcc for all
##  circuit/gate compilation.
##
## @seealso{qcc}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR


function q = compile(this)

  oname = this.op{1};
  if( length(this.op) == 1 && strcmp(oname,"X"))
    q = @QIASMcNot(this.tar,this.ctrl);
  else
    qseq = cell(); # the QIASM sequence

    ## get params by kicking things over to zyzparams
    ## this probably misses some special cases
    params = zeros(1,4);
    if(length(get(this,"op")) == 1)
      params = zyzparams(circ2mat(@QIRsingle(get(this,"op"){1},0),1));
    else
      params = zyzparams(circ2mat(@QIRsingle(get(this,"op"){1},0,get(this,"op"){2}),1));
    endif

    zyzps = params(1:3);
    gp = params(4);

    ## currently not checking for special cases (lemma 5.4 and 5.5)
    ## this is optional in some cases ... also not checking
    qseq{end+1} = @QIASMsingle("ZYZ",this.tar,[(zyzps(3)-zyzps(1))/2,0,0,0]);

    ## some will need a second CNot... not checking this case
    qseq{end+1} = @QIASMcNot(this.tar,this.ctrl);

    ## all U need A,CNot,B
    qseq{end+1} = @QIASMsingle("ZYZ",this.tar,[0,-zyzps(2)/2,-(zyzps(1)+zyzps(3))/2,0]);
    qseq{end+1} = @QIASMcNot(this.tar,this.ctrl);
    qseq{end+1} = @QIASMsingle("ZYZ",this.tar,[zyzps(1),zyzps(2)/2,0,0]);

    ## c-Ph(gp) for non SU(2) Us
    if( abs(gp)  > 2^-32 )
      qseq{end+1} = @QIASMsingle("Rn",this.ctrl,[gp,0,0,1,0]);
      qseq{end+1} = @QIASMsingle("PhAmp",this.ctrl,[0,0,0,gp/2]);
    endif

    q = @QIASMseq(qseq);

  endif

endfunction

function b = iszero(dub)
  b = abs(dub) < 2^(-32);
endfunction


## here we test by comparing the matrix form of the compiled operation
## to that of the QIR operation.  The result should be 'equivalent'
%!test
%! err = 2^(-30);
%! assert(eq(compile(@QIRcU(2,5,{"X"})),@QIASMcNot(2,5)));
%! ops = {"Y","Z","S","T","T'","S'","H"};
%! for op = ops
%!    a = @QIRcU(0,1,op);
%!    assert( operr(circ2mat(compile(a),2),circ2mat(a,2)) < err, op{1});
%! endfor
%!
%! a = @QIRcU(0,1,{"PhAmp",[pi/3,pi/3,pi/3,pi/3]});
%! assert(operr(circ2mat(compile(a),2),circ2mat(a,2)) < err, op{1});
%! a = @QIRcU(0,1,{"Rn",[pi/3,sqrt(1/3),sqrt(1/6),sqrt(1/2),pi/5]});
%! assert(operr(circ2mat(compile(a),2),circ2mat(a,2)) < err, op{1});
%! a = @QIRcU(0,1,{"ZYZ",[pi/3,pi/3,pi/5,pi/7]});
%! assert(operr(circ2mat(compile(a),2),circ2mat(a,2)) < err, op{1});
