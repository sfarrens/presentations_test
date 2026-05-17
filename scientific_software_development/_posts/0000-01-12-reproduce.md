# Reproducible research

--

> A final point to take into consideration is ensuring some backwards compatiblilty of our code for the sake of *reproducible research*. The lack of reproducibility of some key scientific results in recent years has become a serious problem. Enmourmous data sets and extensive pipelines with changing parts mean that it can be almost impossible to recreate a given result exactly.

> That doesn't mean, however, that we can't make an effort to guarantee as much reproducibility as possible. 🫡

> Some useful tools for defining consistent environments for running our code are [Conda](https://docs.conda.io/) and [Docker](https://www.docker.com/).

--

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Conda_logo.svg/2560px-Conda_logo.svg.png" alt="Conda logo" width="200" class="reveal.imgblock">

> [Conda](https://docs.conda.io/) is an open-source environment and package manager that allows the user to install pre-built binaries of specific packages.

--

> We can provide a Conda `environment.yml` file with our package that will specify the specific version of Python we require as well along with all of the dependencies and their corresponding versions (if needed).

```bash
touch environment.yml
```

--

> Inside this file we could add the following content for `mycosmo`.

```yml
name: mycosmo
channels:
  - conda-forge
dependencies:
  - python=3.11
  - numpy>=1.25
```

--

> To build this environment the user would run the `create` command.

```bash
conda env create -f environment.yml
```

> Then to activate it, the user would run the `activate` command.

```bash
conda activate mycosmo
```

> This would provide the user with an environment with everything needed to run our code. 

--

> We can use Conda to create an environment that specifies exactly which versions of the packages are working for that release.[$^{28}$](#/13/29)

```yml
name: mycosmo
channels:
  - conda-forge
dependencies:
  - python=3.11
  - numpy==1.25
```

--

> This way we can (hopefully) avoid a situation where something changes in one of the packages that we use and breaks our code or indeed changes the results. 😱

--

<img src="https://upload.wikimedia.org/wikipedia/en/thumb/f/f4/Docker_logo.svg/120px-Docker_logo.svg.png" alt="Docker logo" width="200" class="reveal.imgblock">

> [Docker](https://www.docker.com/) is a platform that provides *OS-level virtualisation* via a container system. This allows users to define a dedicated virtual operating system with all the required dependencies pre-installed.

--

> We can provide a `Dockerfile` with our package that will define a whole virtual operating system with everything set in a way that we know works with our software. 

```bash
touch Dockerfile
```

--

> Inside this file we could add the following content for `mycosmo`.[$^{29}$](#/13/30)

```dockerfile
FROM continuumio/miniconda3

LABEL Description="MyCosmo Docker Image"
WORKDIR /home
ENV SHELL /bin/bash

RUN apt-get update
RUN apt-get install build-essential -y

COPY * .

RUN conda env create -f environment.yml
RUN echo "conda activate mycosmo" >> ~/.bashrc
```

--

> To build the corresponding image, we (or the user), would simply use the `build` command.

```bash
docker build -t mycosmo .
```

> Then to launch an interactive container the user would use the `run` command.[$^{30}$](#/13/31)

```bash
docker run -it mycosmo
```

--

> This would provide the user with a stable container in which the code should work exactly as expected. If Docker images are build for each release of the code, then it should be possible to reproduce the results that were produced at any given time.

> There are some things we simply cannot control, such as the physical architecture on which the code is run. While Docker containers are fairly universal, there is no 100% guarantee that things will work perfectly on every computer.[$^{31}$](#/13/32)

> This is not guaranteed to work perfectly, but it goes a long way towards maintaining good standards of reproducible research.[$^{31}$](#/13/32)