# CORDIC-Algorithm-using-floating-point-operations-in-VHDL
These descriptions were created as a proposal for the Coordinate Rotation Digital Computer (CORDIC) execution using floating point operations in hardware description language.
The two files are design and testbench respetively. This algorithm uses a Mealy state machine for the sequential execution.
Originally this algorithm is performed using lookup tables and binary shifts. This philosophy was modified in order to perform only floating point operations, replacing binary shifts by multiplications using an aditional lookup table. 
The outcomes takes 27 clock cycles and can compute $$cos(\theta)$$ and $$sin(\theta)$$ for $$\frac{-\pi}{2} < \theta < \frac{\pi}{2} $$.
```math
\begin{bmatrix}
x_{R}\\
y_{R}
\end{bmatrix} =
\begin{bmatrix}
cos(\theta)& -sin(\theta)\\
sin(\theta)& cos(\theta)
\end{bmatrix} 
\begin{bmatrix}
x_{in}\\
y_{in}
\end{bmatrix} =
\large{ROT(\theta)}
\begin{bmatrix}
x_{in}\\
y_{in}
\end{bmatrix}
```
\
![CORDIC_state_machine_page-0001](https://github.com/user-attachments/assets/3deedb2f-ca3f-4672-959a-cb0e386e064e)

![CORDIC](https://github.com/user-attachments/assets/ddad31ad-317d-449a-bf09-89ee145fdd71)
