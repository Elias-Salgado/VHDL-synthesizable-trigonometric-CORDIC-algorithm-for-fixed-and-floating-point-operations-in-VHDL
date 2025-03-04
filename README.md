# VHDL synthesizable CORDIC algorithm for cos(x) and sin(x) computation, using fixed and floating point operations
These descriptions were created for the Coordinate Rotation Digital Computer (CORDIC) execution using fixed point and floating point operations in hardware description language. The two folders contains design and test bench descriptions using fixed point arithmetics and floating point multiplications. These approaches were created as a module which can be integrated in hierarchical designs or used individually for trigonometric computations. The CORDIC algorithm can be executed using micro rotations (using lookup tables) iteratively so that, the $sin(\theta)$ and $cos(\theta)$ can be accurately computed by the minimization of the initial angle. The circular coordinate system in its matrix form is shown in (1):
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
\end{bmatrix} \quad \textbf{(1)}
```
Where $x_{R}$ and $y_{R}$ are the rotation coordinates and $x_{in}$ and $y_{in}$ are the initial coordinates, set as $1$ and $0$ respectively. The expressions that can be performed iteratively to compute trigonometric functions $cos(\theta)$ and $sin(\theta)$ are shown in (2), (3) and the micro rotations by angle decomposition is accomplished using (4).
```math
x\left[j+1\right]= x\left[j\right]-\sigma_{j}2^{-j}y\left[j\right] \quad \textbf{(2)}
```
```math
y\left[j+1\right]= y\left[j\right]+\sigma_{j}2^{-j}x\left[j\right] \quad \textbf{(3)}
```
```math
z\left[j+1\right]= z\left[j\right]-\sigma_{j}*tan^{-1}\left(2^{-j}\right) \quad \textbf{(4)}
```
Where

```math
\begin{equation}
\sigma_{j}=
    \begin{cases}
        1 & \text{if } \quad z\left[j\right] \geq \mathbb{0}\\
        -1 & \text{if } \quad z\left[j\right] < \mathbb{0}\\
    \end{cases} \quad \textbf{(5)}
\end{equation}
```


To perform the micro rotations as shown in (4), a look-up table is used in both cases, fixed and floating point operations (If you want deeper CORDIC theory, you can find a useful explanation [here](http://web.cs.ucla.edu/digital_arithmetic/files/ch11.pdf)). In the case of (2) and (3), the term $2^{-j}$ is accomplished by binary shifts in fixed point description and using multiplications and look-up tables in the floating point one. In the last micro rotation, an adjust constant is multiplied: $1/1.64676$ in order to converge to the expected outcome.

Both descriptions are enabled rising a single bit input signal called ***en***. The angle is set at the 32 bits signal ***z*** and the $sin(z)$ and $cos(z)$ are submitted to the 32 bits signals ***x*** and ***y*** respectively once the calculation has finished. The computation process takes 25 and 27 clock cycles for fixed and floating point respectively. When the computation finishes, a flag called ***data_rdy*** is raised, as shown in the waveform window below. 

<p align="center">
  <img width="840" src="https://github.com/user-attachments/assets/1334447e-e95d-4545-9ee4-c5446025d9c4">
</p>


These descriptions use sequential, and Mealy state machine based control in fixed and floating point descriptions respectively for their execution. These models can compute $$cos(\theta)$$ and $$sin(\theta)$$ for $$\frac{-\pi}{2} < \theta < \frac{\pi}{2} $$, with an error of about $1.5e-7$ for 24 iterations.
\
\
The Mealy state machine used in the floating point description is shown in the figure below.

<p align="center">
  <img width="400" src="https://github.com/user-attachments/assets/3deedb2f-ca3f-4672-959a-cb0e386e064e">
</p>

An analog plot of the outcomes in the test bench file, for floating point description is shown below.

<p align="center">
  <img width="840" src="https://github.com/user-attachments/assets/ddad31ad-317d-449a-bf09-89ee145fdd71">
</p>
