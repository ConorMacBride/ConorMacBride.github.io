---
date: 9999-08-01
start: 2021-11-24
organisation: SunPy
role: Continuous Integration Maintainer
noexpand: true
---
- Maintaining the CI/CD pipelines across various platforms including Azure Pipelines, GitHub Actions and CircleCI, and investigating and recommending new CI services.
- Configuring Python testing environments and ensuring unit tests are sufficient.
- Implementing new functionality, as well as fixing bugs and optimising existing code.
- Reviewing pull requests to maintain a high-quality, well-tested codebase.

### Contributions to the ecosystem
- Being involved since the project's inception, I developed most of the OpenAstronomy [GitHub Actions workflows](https://github.com/OpenAstronomy/github-actions-workflows) for testing, building, and publishing Python packages.
  - These CI workflows are used extensively by the astrophysics community, including [Astropy](https://github.com/astropy/astropy), [SunPy](https://github.com/sunpy/sunpy), and the [Space Telescope Science Institute](https://github.com/spacetelescope) who operate the Hubble Space Telescope and the next generation JWST. Notably, the workflows are used for testing the software pipeline which calibrates the raw images captured by the JWST.
  - Maintaining other OpenAstronomy projects including [Azure Pipelines templates](https://github.com/OpenAstronomy/azure-pipelines-templates) and [`build-python-dist` action](https://github.com/OpenAstronomy/build-python-dist).
  - Advising projects on how to configure their testing and publishing infrastructure.
- Maintaining Matplotlib's [`pytest-mpl`](https://github.com/matplotlib/pytest-mpl) plugin, with my significant development work including,
    - a new test suite, and infrastructure, to validate the internal state of the plugin across a wide range of configurations, and
    - [HTML summary reports](https://matplotlib.org/pytest-mpl/latest/sample/test_html/fig_comparison.html) with interactive filtering of the image comparison test results. These reports are used by popular Python packages including [NetworkX](https://github.com/networkx/networkx) and [Cartopy](https://github.com/SciTools/cartopy).
