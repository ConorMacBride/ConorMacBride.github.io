---
date: 2017-06-01
organisation: Humboldt University of Berlin
role: Student Intern
start: June 2017
end: August 2017
---
- Spent three months during summer 2017 working on a project involving using a convolutional neural network to detect, from videos, fish swimming on the surface of sulfur water.
- Wrote a program that takes the fish detected by the neural network and connects the fish across frames in the video. It then filters out poor quality detections by setting a minimum number of frames a chain of detections has to be present in before it is considered to be a fish.
- My program significantly improved the reliability of the output from the neural network. This was proven by comparing the filtered detections with the detections from the neural network using annotated ground truth frames.
- I also read about neural networks and retrained the existing neural network with new training data and different training parameters. I created multiple models then analysed their accuracy to find the optimal parameters.
- Used Bash extensively throughout to work with files and run programs on the computer. Created scripts to automate many tasks. Developed my skills using Vim.

#### More details:

Elliptical Gaussians are used to determine probabilities that two detections in neighbouring frames represented the same fish. Fish in adjacent frames are then connected in order of probability.

Due to the low quality of the videos all connections could not be made, therefore, more distant probabilities are then processed in a complex algorithm which prioritised high probability links and long chains of detections. This algorithm is able to evaluate previously created links and override them if it finds a better link.

Connections between long chains of detections are then made, provided their ends are physically very close.

The chains of detections are then filtered based on their length and various plots and diagrams are produced. These plots include position, orientation, density, polarisation and nematic order.

<figure class="three">
  <img src="{{ site.baseurl }}/img/trajectories.jpeg" width="196" height="180" alt="Trajectories" />
  <img src="{{ site.baseurl }}/img/density.jpeg" width="196" height="180" alt="Density" />
  <img src="{{ site.baseurl }}/img/orientation.jpeg" width="196" height="180" alt="Orientation" />
</figure>
