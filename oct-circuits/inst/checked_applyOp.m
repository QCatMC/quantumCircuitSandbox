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

## Usage: y = checked_applyOp(x,A,t,n)
##
## apply the m<=n qubit operator A to bits [t-m+1,t] of 
## the n qubit pure state x. This version checks arguments for the 
## following preconditions: A should be a 2^m x 2^m matrix
## where m <= n. The target qubit t should be one of [t-m+1,n). x should be 
## a 2^n column vector. 
##
## see applyOp for an unchecked version
##
## based on "Improving the Performance of Tensor Matrix Vector 
## Multiplication in Cumulative Reaction Probability Based Quantum 
## Chemistry Codes" by Kaushik, Gropp, Minkoff, and Smith

## Author: Logan Mayfield
## Keyword: Circuits

function y = checked_applyOp(x,A,t,n)
  m = log2(rows(A)); # operator size in qubits
  
  ## error checking
  if( rows(A) != columns(A) || m!=n || log2(columns(A)) != n ) # bad operator size
    error("Operator must be square and order = 2^m for 0<=m<=n.n=%d and A is %dx%d", ...
  	   n,rows(A),columns(A));      
  elseif ( t>=n || (t+1)-m<0) # bad target
    error("bad target. target not in [m-1,n) : t=%d n=%d m=%d",t,n,m); 
  elseif ( length(x) != 2^n ) #bad vector size
    error("vector size must be 2^n: n=%d |x|=%d",n,length(x));
  endif
  
  ## 
  y = applyOp(x,A,t,n);

endfunction


## Test for error checking here
%!test
%! fail('checked_applyOp(stdBasis(1,2),eye(3),0,2)')
%! fail('checked_applyOp(stdBasis(1,2),eye(2),0,2)')
%! fail('checked_applyOp(stdBasis(1,2),eye(4),3,2)')
%! fail('checked_applyOp(stdBasis(1,2),eye(4),-1,2)')
%! fail('checked_applyOp(stdBasis(1,2),eye(4),0,2)')
%! fail('checked_applyOp(stdBasis(1,1),eye(4),1,2)')



