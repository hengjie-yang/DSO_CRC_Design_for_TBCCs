# DSO_CRC_Design_for_TBCCs
This repository implements the algorithms proposed in ISIT 2020 submissions to design DSO CRCs for TBCCs.

## Purpose of this repository
The objective of this repo is to find the distance-spectrum-optimal (DSO) CRC polynomial for a given tail-biting convolutional code (TBCC) of trellis length *N*. 

### References
  1. H. Yang, L. Wang, V. Lau, and R. D. Wesel, "An Efficient Algorithm for Designing Optimal CRCs for Tail-Biting Convolutional Codes", [arXiv:2001.06029](https://arxiv.org/abs/2001.06029)


## How to find the DSO CRC polynomial
- Step 1: Set up the following parameters:
  - *m*: the objective CRC polynomial degree
  - *v*: the constraint length of the convolutional encoder
  - *g(x)*: the convolutional encoder represented in octal
  - *d_tilde*: the upper bound on the distance that gurantees to find the objective DSO CRC polynomial
  - *N*: the target trellis length

- Step 2: Collect all irreducible error events (IEEs) of distance up to *d_tilde* **(Skip this step if IEEs of distance up to *d_tilde* has already been created)**
  - Execute the following command in MATLAB:
    ```
    IEE = Collect_Irreducible_Error_Events(v, g(x), d_tilde)
    ```
    or if you would like to save memory:
    ```
    IEE = Collect_Irreducible_Error_Events_ms(v, g(x), d_tilde)
    ```
  - After executing, the program saves *IEE* in your local directory under the file starting with *IEEs_TBCC_... .mat*
  
- Step 3: Compute the complete weight spectrum of TBCC *g(x)* **(Skip this step if the weight spectrum of TBCC *g(x)* has already been created)**
  - Execute the following command in MATLAB:
  ```
  weight_node = Compute_TBCC_weight_spectrum(v, g(x), N)
  ```
  - After excuting, the program saves *weight_node* in your local directory under the file starting with *weight_node_... .mat* .
  
- Step 4: Reconstruct all tail-biting paths (TBPs) of distance up to *d_tilde* and of length **EQUAL TO** *N* 
  - Execute the following command in MATLAB:
  ```
  TBP_node = Reconstruct_TBPs(g(x), d_tilde, N)
  ```
  - After executing, the program saves *TBP_node* in your local directory under the name starting with *TBP_node_TBCC... .mat*.
  
- Step 5: Search the degree-*m* distance-spectrum-optimal (DSO) CRC polynomial
  - Execute the following command in MATLAB:
  ```
  Poly_node = Search_DSO_CRC(g(x), d_tilde, N, m)
  ```
  - After executing, the program saves *Poly_node* in your local directory under the name starting with *Poly_node_... .mat*
  - The command window will display whether you have successfully found the unique DSO CRC polynomial. If successful, the command window will also display if you have successfully found the **undetected minimum distance** *d_crc*.
  
  
## An example to get started
Assume we have an encoder where a length-*k* binary message is first encoded with a degree-*m* CRC polynomial *p(x)*. The resultant sequence is then fed into a convolutional encoder *g(x)* to produce a tail-biting codeword *c(x)*.

Suppose that *k=10*, *m=5*, *g(x)=(13, 17)* (which is of constraint length *v=4*). What is the corresponding degree-*5* DSO CRC polynomial *p(x)* for the TBCC *c(x)*?

***Solution:*** In this case, the trellis length *N = k+m = 15*. Since the zero-terminated convolutional code generated by *g(x)=(13, 17)* has a free distance of *6*, we will empirically select *d_tilde = 13* as our distance upper bound.

Excute the following commands sequentially,
```
IEE = Collect_Irreducible_Error_Events(4, [13, 17], 13)
weight_node = Compute_TBCC_weight_spectrum(4, [13, 17], 15)
TBP_node = Reconstruct_TBPs([13, 17], 13, 15)
Poly_node = Search_DSO_CRC([13, 17], 13, 15, 5)
```
Finally, the command window should display the following information:
```
Poly_node = 
  struct with fields:

        success_flag: 1
       crc_gen_polys: '3D'
    stopped_distance: -1
        crc_distance: 8
```
This means that if have successfully found the degree-*5* DSO CRC, which is *(3D)* in hexadecimal or 
```
p(x) = x^5 + x^4 + x^3 + x^2 + 1,
```
which is of undetected minimum distance *d_crc = 8*.


