# parking-reachability

## Overview

This repository contains MATLAB scripts for reachability analysis by Team 1 in EL2425 course, HT21. For more details, please refer to the documentation of our project.

## Requirements

The scripts are tested in MATLAB 2020b and Windows 10, with some dependencies below. 

Download these libraries and add the path of them in MATLAB.

[ToolboxLS](https://www.cs.ubc.ca/~mitchell/ToolboxLS/)

[helperOC](https://github.com/HJReachability/helperOC
) 

[YAMLMatlab](https://code.google.com/archive/p/yamlmatlab/downloads) (0.4.3)

## Usage

First, `addpath` of util functions, `.yaml` data and `run` the script with basic parameters in your matlab script.

You can tune some parameters in `param.m`. They are consistent for different parking jobs. You can also design some parameters in `parking_param.m`. They vary according to the type of parking jobs.

### Data processing

We extract and plot map data by `run('obs_tf.m');`. Unfortunately, this module has not been properly incorporated into main code yet. Some variables below will be initialized in workspace.

`ps`: Each element is a parking spot, including several surrounding obstacles. e.g.,

get a spot:

```matlab
    >> ps{1}
```

get an obstacle: (size: 2 x n)

```matlab    
    >> ps{1}{1}
```

`type`: Type of parking jobs. e.g.,

```matlab
    >> type{1}
```

`marker`: Each element is a struct {x, y, yaw}. e.g.,

```matlab
    >> marker{1}.x
```

`spot_dim`: A struct {width, depth} for a spot. e.g.,

```matlab
    >> spot_dim{1}.width
```

### Feasibility check

With function `feasibilityTest`, we check if the vehicle fits the size of the parking spots. We get `possible_task_idx`, containing the indices of feasible parking jobs.

```matlab
[possible_task, possible_task_idx] = feasibilityTest(parking_spots, LENGTH, WIDTH);
```

### Dynamics

Our model is a simple bicycle model, which is explained in model section. Four states are `(x, y, yaw, velocity)`. Two inputs are `(steering_angle, acceleration)`. The continuous model is given here.

$$
    \dot{x_1} = v * cos(x_3) + d1
$$

$$
    \dot{x_2} = v * sin(x_3) + d2
$$

$$
    \dot{x_3} = (v/L) * tan(\delta) + d2
$$

$$
    \dot{x_4} = a
$$

$$
    u = [\delta, a]
$$

### Reachability analysis

In our code, a marker pose is denoted as `(CX, CY, CZ)` and a parking spot as `(SX, SY, SZ)`. Based on some geometric relationships in different parking cases, we get `(SX, SY, SZ)` from `(CX, CY, CZ)`. This is done in `parking_param.m`. First, the boundary of a parking spot is 10 centimeters away from the corresponding marker. Then we can calculate the center of parking spot according to the size of the spot. Finally, we move the parking spot to the reference point (center of the rear axle) instead of the center of the vehicle.

For each parking spot, we make a new grid, which means we `run('parking_reachability.m')` for each spot.

Obstacles can be inflated and collected into a cell in this way:

```matlab 
for i = 1:numObs
    obstacles{i} = arbitraryObstacle(g, allObs{i}, rInflate);
end
```

In `arbitraryObstacle`, we sample some points on the edges of an obstacle and place some cylinders at each sample. Thus, we build the walls and expand it by the radius of the cylinders. If more obstacles are needed, you can extend the cell `obstacles`. 

In accordance with the model dynamics, we check the reachability in a 4D space. But in the end, we get a projection in `(x, y)` space with predefined yaw angle and velocity.

Furthermore, there may be problems for negative velocity in the toolbox. Consequently, we do a forward parking task, and then reverse the yaw angle to get the result of reverse parking and parallel parking.

### Example results

![](figure/example.png)
<center> Map </center><br>

![](figure/forward.bmp)
<center> Forward parking </center><br>

![](figure/reverse.bmp)
<center> Reverse parking </center><br>

![](figure/parallel.bmp)
<center> Parallel parking </center><br>
