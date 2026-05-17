## Documentation

--

> Now that we have a stable and tested code, we need to make sure users understand how to run it and developers understand how to contribute to it.

> There are two main places this needs to be done: a *README* file and *API* documentation.

--

> The *README* is usually a *Markdown* file (`README.md`)[$^{12}$](#/13/13) and serves as the entry point for the repository. It should provide concise details on how to install and run the code along with the scope it covers. A good `README.md` could be the difference between someone using your code or not.

> GitHub and GitLab both offer the option to initialise a repository with a `README.md`.

--

> The *API* (Application Programming Interface) documention explains how to use the various components that make up your code (i.e. functions, classes, and other objects). This is extremely useful for other developers, but also for users if your code acts as a library (like e.g. [Numpy](https://numpy.org/)).

--

<img src="https://www.jetbrains.com/guide/assets/sphinxdoc-ca1beff5.png" alt="Sphinx logo" width="200" class="reveal.imgblock">

> [Sphinx](https://www.sphinx-doc.org/) is a package that automatically generates API documentation from *docstrings* in Python code written in *reStructuredText* syntax.

--

> We can start building our API documentation by running the following.[$^{13}$](#/13/14)

```bash
mkdir docs
sphinx-quickstart docs
```

> This will add some content to a `docs` directory. 

--

> Inside `docs/source` we can find a file called `conf.py`, where the configuration options for Sphinx can be set. In particular, various [Sphinx extensions](https://www.sphinx-doc.org/en/master/usage/extensions/index.html). My personal preference is to set the following:

```python
extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.doctest",
    "sphinx.ext.intersphinx",
    "sphinx.ext.napoleon",
    "sphinx.ext.viewcode",
    "numpydoc",
]
```

> We will go through each of these extensions as they come up.

<!-- .element: style="font-size: 50%;" -->

--

> If we have enabled the `sphinx.ext.autodoc` option, we can automatically generate API documentation for all of the modules in our Python package, but first we have to tell Sphinx where to find them. To do so we will need to update the system path for `conf.py` by adding the following to the top of the file.

```python
import sys
import os


sys.path.insert(0, os.path.abspath('../..'))
```

--

> Then we can run the following command to generate source `.rst` files for each of the Python modules.[$^{14}$](#/13/15)

```bash
sphinx-apidoc -Mfeo docs/source mycosmo
```

--

> Finally, we can build the HTML containing our API documentation.

```bash
sphinx-build docs/source docs/build
```

> If we open `docs/build/index.html` we can see the results. 

> Not very useful so far. 😑

--

> We need to add some docstrings to our modules and functions! Open `cosmology.py` and add the following to the very top of the file.

```python
"""Cosmology.

This module implements various cosmology routines.

"""
```

> Now rebuild the HTML files.

> You should see the information we added for the corresponding module, which lets the user know what this module contains.

--

> Now, let's add a more detailed docstring to our `hubble` function (right after `def hubble(redshift, cosmo_dict):`).

> Let's start by giving our function a name and a short description of what it does.

```python
    """Hubble Parameter.

    Calculate the Hubble parameter at a given redshift using the cosmological parameter values provided.

    """
```

--

> This is a good start, but we could help the users and other developers better understand how to use this function by explicitly detailing what the expected inputs and outputs of this function are.

> There are various different formatting standards for doing this. My personal preference is [numpydoc](https://numpydoc.readthedocs.io/en/latest/format.html).

> To use this standard we will need to enable the `sphinx.ext.napoleon` and `numpydoc` extensions.

--

> Let's update our function's docstring with the expected inputs according to the `numpydoc` standard.

```python
    """
    Parameters
    ----------
    redshift : float or numpy.ndarray
        Redshift(s) at which the Hubble parameter should be calculated
    cosmo_dict : dict
        Dictionary of cosmological constants. 
    """
```

--

> This lets the user know what the input variable names are, what the expected data types for those variables are and some additional information to better understand what these variables represent.

> We might also find this useful ourselves if we come back to the code after a long break and forget what we have done. 😅
<!-- .element: style="font-size: 50%;" -->

--

> We can actually add more detail. For example, the user doesn't know what the `cosmo_dict` dictionary should contain. Let's fix that.[$^{15}$](#/13/16)

```python
    """
    cosmo_dict : dict
        Dictionary of cosmological constants. Must contain the following keys:

        * ``H0``: The Hubble parameter value at redshift zero.
        * ``omega_m_0``: The matter density at redshift zero.
        * ``omega_k_0``: The curvature density at redshift zero.
        * ``omega_lambda_0``: The dark energy density at redshift zero.
    """
```

--

> Let's do the same thing for the outputs of the function.

```python
"""
Returns
-------
float or numpy.ndarray
    Value of the Hubble parameter (km/s/Mpc) at the specified redshift(s) for a given cosmology.
"""
```

> Now the user should know what to expect in terms of the output object type and how to interpret the values.

--

> We can take this one step further and add some notes that provide more context for our function.

```python
"""
Notes
-----
This function implements the calculation of the Hubble parameter as follows:

.. math::
    H(z) = \sqrt{H_0^2 (\Omega_{m,0}(1+z)^3 + \Omega_{k,0}(1+z)^2 +
        \Omega_{\Lambda,0})}
"""
```

> If we rebuild the docs again, we should see some nice rendered *LaTeX*! 🤓

--

> At this stage we have some pretty decent API documentation for this function, however we can always do more.

> Let's add an example of how to use this function.

```python
"""
Example
-------
>>> from mycosmo.cosmology import hubble
>>> cosmo_dict = {"H0": 70, "omega_m_0": 0.3, "omega_k_0": 0.0, "omega_lambda_0": 0.7}
>>> hubble(0.0, cosmo_dict)
70.0
"""
```

--

> This will make it significantly easier for someone to use this function for the first time.

> If we enable `sphinx.ext.doctest`, we can even test that the example provided works as expected.[$^{16}$](#/13/17)

```bash
sphinx-build -b doctest -E docs/source docs/build
```

--

> Now that we have some comprehensive documentation for this function, let's make things a bit easier to navigate.

> We can enable the `sphinx.ext.viewcode` extension so that users and other developers can see the actual code implementation within the API documentation.

--

> We can add another useful feature by taking advantage of the `sphinx.ext.intersphinx` extension to link to the core Python API documentation and to other third-party packagies we are using in our project. We just need to provide the appopriate URLs for the packages. 

```python
intersphinx_mapping = {
    "python": ("http://docs.python.org/3", None),
    "numpy": ("https://numpy.org/doc/stable/", None),
}
```

> Now users can look up any of the data types we expect as inputs or outputs to our own functions.

--

> We have significantly improved the content of our documentation.  Hoever, The default look is still quite... 🤮

> We can fix this by choosing a new [theme](https://sphinx-themes.org/) in `conf.py`

```python
html_theme = "sphinx_book_theme"
```

> and rebuilding the HTML.  

> Much better! 🤩

--

> Finally, we can also add custom pages to our `docs/source` directory to include infomation about how to install the package, which paper should be cited if the code is used, etc.

> The `myst_parser` plug-in makes it possible to add content in *Markdown* instead of *reStructuredText*.

> To view the pages we simply need to make sure they are included under the `toctree` in `index.rst`.

--

## Exercise

> Add docstrings to the `critical_density` function and the remaining modules (`constants.py`, `__init__.py`). Rebuild the HTML to make sure everything renders correctly and make sure all the `PYDOCSTYLE` tests are passing when you run `pytest`.

> As with the [previous exercise](#/5/7), use the [Git workflow](#/4/18) you learned to implement the changes via a MR/PR. Again it is recommended to work in pairs.