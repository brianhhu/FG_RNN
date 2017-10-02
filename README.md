# FG_RNN
**F**igure-**G**round Organization with a Biologically Plausible **R**ecurrent **N**eural **N**etwork

## Demo
To run the model, ...
1) Run Setup.m for instructions on how to run model.
2) Model parameters can be adjusted in mfiles/makeDefaultParams.m

## Paper
For more details about the model and/or experiments, please see our paper:

## Model Results and Evaluation
Model results can be found in the **output** directory. The results are separated by type:

* edge (contour detection)
* ori (figure-ground assignment)
* group (segmentation)

Evaluation code for the contour detection task can be found [here](https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/resources.html).

Evaluation code for the figure-ground assignment task can be found [here](http://www.umiacs.umd.edu/~cteo/BOWN_SRF/).

We refer the reader to the authors' original papers detailing the datasets and benchmarks:

    @article{Arbeleaz_etal11,
      Author = {Arbelaez, Pablo and Maire, Michael and Fowlkes, Charless and Malik, Jitendra},
      Title = {Contour Detection and Hierarchical Image Segmentation},
      Journal = {IEEE Trans. Pattern Anal. Mach. Intell.},
      Volume = {33},
      Number = {5},
      Year = {2011},
      Pages = {898--916},
      doi = {10.1109/TPAMI.2010.161},
      Publisher = {IEEE Computer Society},
    } 

    @inproceedings{Teo_etal15,
      Title={Fast 2D border ownership assignment},
      Author={Teo, Ching and Fermuller, Cornelia and Aloimonos, Yiannis},
      Booktitle={Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition},
      Pages={5117--5125},
      Year={2015}
    }

## Experimental Data
The data used to compare our model results with experimental results can be found [here](http://dx.doi.org/10.7281/T1C8276W). If you use this data for your own research, please cite the following paper:

    @article{Williford_vonderHeydt16,
      Title={Figure-ground organization in visual cortex for natural scenes},
      Author={Williford, Jonathan R and von der Heydt, R{\"u}diger},
      Journal={eNeuro},
      Volume={3},
      Number={6},
      Pages={ENEURO--0127},
      Year={2016},
      Publisher={Society for Neuroscience}
    }
