# DSO_CRC_Design_for_TBCCs
This repository implements the algorithms proposed in ISIT 2020 submissions to design DSO CRCs for TBCCs.

## Purpose of this repository
The objective of this repo is to find the distance-spectrum-optimal (DSO) CRC polynomial for a given tail-biting convolutional code (TBCC) of trellis length *N*. 


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
  
  


