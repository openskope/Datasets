_The modeling service is unavailable at this time. The PaleoCAR model 
is available as an R package and from the repository._


`paleocar` is an R package implementing functions to perform spatio-temporal paleoclimate reconstruction from tree-rings using the CAR (Correlation Adjusted corRelation) approach of Zuber and Strimmer as implemented in the care package for R. It is optimized for speed and memory use.

This is based on the approach used in Bocinsky and Kohler (2014):

Bocinsky, R. K. and Kohler, T. A. (2014). A 2,000-year reconstruction of the rain-fed maize agricultural niche in the US Southwest. Nature Communications, 5:5618. doi: 10.1038/ncomms6618.

The primary difference between the latest version of paleocar and that presented in Bocinsky and Kohler (2014) is, here, model selection is performed by minimizing the corrected Akaike's Information Criterion.

The package is currently available from its [GitHub repository](https://github.com/bocinsky/paleocar). Interested users 
will find instructions for installing and running the model. In the future,
users will be able to execute the model using the SKOPE web interface.

This package has been built and tested on a source (Homebrew) install of R on macOS 10.12 (Sierra), and has been successfully run on Ubuntu 14.04.5 LTS (Trusty), Ubuntu 16.04.1 LTS (Xenial) and binary installs of R on Mac OS 10.12 and Windows 10.
