# Packaging

--

> Once our code reaches a certain level of maturity we may want to share it with the rest of the world. You never know who could find it useful. 🙂

> If we would like people to use the code, we should make it easy for them to access and install. This means we need to *package* our software.

> The current community standard for Python is to write a *TOML* file called `pyproject.toml` to package the code and then distribute it via [PyPI](https://pypi.org/) (Python Package Index). This way users can simply install the code using `pip`.

--

> Let's write a `pyproject.toml` for our package, which we have called `mycosmo`.[$^{24}$](#/13/25) We need to put this file at the root level of the repository.

```bash
touch pyproject.toml
```

--

> The first section we will add to this file provides the essential package *metadata*.

```toml
[project]
name = "mycosmo"
readme = "README.md"
requires-python = ">=3.11"
authors = [{ "name" = "Samuel Farrens", "email" = "samuel.farrens@cea.fr" }]
maintainers = [{ "name" = "Samuel Farrens", "email" = "samuel.farrens@cea.fr" }]
description = "This is an example cosmology package."
dependencies = ["numpy"]
version = "0.0.1"
```

> Here we specify the name of the package, the `README.md` file, what minimum version of Python is needed to run it, who wrote/maintains the code, what the code does, what it depends on and what the current version is.

--

> Now, we can add some optional dependencies (i.e. packages that are not required to run the code but can be helpful).

> Let's start with the pakcages we would need to build the API documentation.

```toml
[project.optional-dependencies]
docs = [
    "myst-parser",
    "numpydoc",
    "sphinx",
    "sphinx-book-theme",
]
```

--

> Next, we can add the packages we would need to run the unit tests.

```toml
test = [
    "pytest",
    "pytest-cov",
    "pytest-emoji",
    "pytest-pydocstyle",
]
```

--

> Then we can add some other useful tools that check the code style and push the bundled package to PyPI.

```toml
lint = ["black", "isort"]
release = ["python-build", "twine"]
```

> And, as a little bonus, we can also add an option to install all of the optional dependencies.

```toml
dev = ["mycosmo[docs,lint,release,test]"]
```

--

> Next, we can set the convention we want to use for checking our API documentation standards.

```toml
[tool.pydocstyle]
convention = "numpy"
```

> Finally, we can set the options we want `pytest` to use.

```toml
[tool.pytest.ini_options]
addopts = ["--verbose", "--emoji", "--pydocstyle", "--cov=mycosmo"]
testpaths = ["mycosmo"]
```

--

> With our `pyproject.toml` file ready, we can now install the `mycosmo` package to make sure everything is working as expected.

```bash
pip install .
```

> We can check the metadata with the `show` option.

```bash
pip show mycosmo
```

--

> We can test our optional dependencies as follows.[$^{25}$](#/13/26)

```bash
pip install ".[dev]"
```

--

## Exercise

> Simplify the CI/CD workflows on GitHub and/or Gitlab by taking advantage of the optional dependency options we defined in the `project.toml` file. 

--

> With our packaging setup complete, we should ensure that everything on GitHub/GitLab is up to date with our local repo and working as expected. 🫡

> Once we are happy, we should *tag* the latest state of the `main` branch and create a *release* ([on GitHub](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository), [on GitLab](https://docs.gitlab.com/ee/user/project/releases/)). This way we can be sure that what we distribute is consistent with what we have tagged (i.e. a given version will have a consistent meaning both on the repo and on PyPI).

--

> Now, we are all set to bundle our package!

```bash
python -m build
```

> This will create a `dist` (distribution) directory. Inside we will find a *wheel* (`.whl`) and compressed *tarball* (`.tar.gz`) of the package. These are the files that need to be uploaded to PyPI.

> We will use [Twine](https://twine.readthedocs.io/) to do this. 

--

> First, we need to make sure the distribution is OK.

```bash
twine check dist/*
```

> If everything is good, it should say *PASSED* for both files.

--

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/PyPI_logo.svg/1200px-PyPI_logo.svg.png" alt="PyPI logo" width="200" class="reveal.imgblock">

> Next, we will need to create an account on [PyPI](https://pypi.org/) (if we have not alredy done so).

--

> Before actually uploading to the official PyPI registry, we may want to make sure the package looks OK on the [Test PyPI](https://test.pypi.org/).[$^{26}$](#/13/27)

```bash
twine upload --repository testpypi dist/*
```

--

> Once we are happy with everything, we can upload to the offical PyPI registry.[$^{27}$](#/13/28)

```bash
twine upload dist/*
```

--

> Now the world can download our package!

```bash
pip install mycosmo
```

#### 🥳