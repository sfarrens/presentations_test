## Version control I
### Introduction to Git

--

> Writing code can be hard work! This is particularly felt when things are not working as we expect.

#### 😩

--

> While we cannot guarantee that things will always go smoothly, we can make the whole process a bit easier by keeping track of all the changes we make to the code.

> With *version control* tools like [Git](https://git-scm.com/) we can label various *states* of the code so that we can see exactly what has changed and when. We can also go back to previous states, when things were (hopefully) working properly.

--

<img src="https://git-scm.com/images/logos/downloads/Git-Logo-1788C.png" alt="Git logo" width="200" class="reveal.imgblock">

> [Git](https://git-scm.com/) is a distrubted version control system developed by [Linus Torvalds](https://en.wikipedia.org/wiki/Linus_Torvalds) (of the *Linux* fame) in the mid 2000s.

> To better familiarise ourselves with Git we will go through some of the basic `git` commands.

--

> Open a terminal and create a directory called `example`.

```bash
mkdir example
cd example
```

> Let's make this a Git repository using the `init` command.

```bash
git init
```

> Now, we can check the status of this repository with the `status` command.

```bash
git status
```

> Not much going on so far. 🥱

--

> Create a file called `cosmology.py` with the following content.

```python
import numpy as np


def hubble(redshift):
    hubble_const = 0.7
    matter = 0.3 * (1 + redshift) ** 3
    curvature = 0.0 * (1 + redshift) ** 2
    dark_energy = 0.7

    return np.sqrt(hubble_const**2 * (matter + curvature + dark_energy))
```

> This file contains a very simple function to calculate the [Hubble Parameter](https://en.wikipedia.org/wiki/Hubble%27s_law) *($H(z)$)* as a function of redshift in a matter-dominated universe.*

> *We will be improving this code later on.
<!-- .element: style="font-size: 50%;" -->

--

> Now, let's check the status of this repository again.

```bash
git status
``` 

> You should see `cosmology.py` listed as an *untracked file*. So, let's add this file to the *staging* area using the `add` command.

```bash
git add cosmology.py
```

> If you check the status again, you should see this file listed as part of the *changes to be committed*.

--

> We can make our first *commit* (i.e. a labelled state of the code) using the `commit` command.

```bash
git commit --message "Added cosmology.py module."
```

> Now, we can view a list of our commit states using the `log` command.

```bash
git log
```

> We can see who authored the commit, when it was made and the message we provided above.

<mermaid>
gitGraph
       commit id: "First commit"
</mermaid>
<!-- .element: style="height: 150px;" -->

--

> Let's take another look at our `hubble` function and make some improvements.[$^1$](#/13/2) We can remove the hard-coded cosmological parameters and instead provide a dictionary object as an argument.

```python
def hubble(redshift, cosmo_dict):
    hubble_const = cosmo_dict["H0"]
    matter = cosmo_dict["omega_m_0"] * (1 + redshift) ** 3
    curvature = cosmo_dict["omega_k_0"] * (1 + redshift) ** 2
    dark_energy = cosmo_dict["omega_lambda_0"]

    return np.sqrt(hubble_const**2 * (matter + curvature + dark_energy))
```

> If you recheck the status, you should see `cosmology.py` listed as *modified*.

--

> We can redo the steps to add and commit our modified file and then check the log. 

```bash
git add cosmology.py
git commit --message "Removed hard-coded values."
git log
```

> You should now see two commits with unique 40-character identifiers.

<mermaid>
gitGraph
       commit id: "First commit"
       commit id: "Second commit"
</mermaid>
<!-- .element: style="height: 150px;" -->

--

> We can go back to our first commit state using the `checkout` command.

```bash
git checkout <GIT COMMIT ID>
```

> If you look at `cosmology.py` you will see it has reverted to the previous state with the hard-coded parameter values.

> To get back to our latest commit we simply need to checkout the `main` *branch*.

```bash
git checkout main
```

--

> If we would like to continue working on our code, it is good practice to create specific *branches* for features that we would like to implement or bugs we would like to fix.

> For example, let's say we would also like to compute the [critical density](https://en.wikipedia.org/wiki/Friedmann_equations#Density_parameter) of the Universe in our `cosmology.py` module.

> We should first create a new branch called e.g. `critical_density` using the `branch` command.

```bash
git branch critical_density
```

--

> Running the `branch` command on its own will list the available branches, where you should see a `*` next to `main` and our new `critical_density` branch. To switch to this new branch we use the `checkout` command.[$^2$](#/13/3)

```bash
git checkout critical_density
```

> The `log` command will show that this branch is at the same commit state as the `main` branch. 

<mermaid>
gitGraph
       commit id: "First commit"
       commit id: "Second commit"
       branch critical_density
       checkout critical_density
</mermaid>
<!-- .element: style="height: 150px;" -->

--

> Now, let's add our critical density function to `cosmology.py` and follow the usual steps to add and commit the changes.

```python
def critical_density(redshift, cosmo_dict):
    Mpc = 3.08568e22
    G = 6.6743e-11
    H_z_si = hubble(redshift, cosmo_dict) * 1e3 / Mpc

    return (3.0 * H_z_si**2) / (8.0 * np.pi * G)
```

```bash
git add cosmology.py
git commit --message "Added critical density function."
```

--

> The log will now show the `critical_density` branch at a different state to that of `main`.

```bash
git log
```

<mermaid>
gitGraph
       commit id: "1"
       commit id: "2"
       branch critical_density
       checkout critical_density
       commit id: "3"
</mermaid>
<!-- .element: style="height: 200px;" -->

--

> We can check the difference between branches using the `diff` command.

```bash
git diff main
```

> You should see the lines we added to `cosmology.py` highlighted in green.

--

> We could continue to work on this branch, but once our feature has been implemented we need to *merge* these changes back into the `main` branch. We can do this with the `merge` command.

```bash
git checkout main
git merge critical_density
```

<mermaid>
gitGraph
       commit id: "1"
       commit id: "2"
       branch critical_density
       checkout critical_density
       commit id: "3"
       checkout main
       merge critical_density id: "merge"
</mermaid>
<!-- .element: style="height: 200px;" -->

--

> The log will now show that both branches are at the same commit state and `diff` will show no differences between the two branches. 

> This is a good time to **clean up**! We can use the `-d` option for `branch` to delete our merged feature branch.[$^3$](#/13/4)

```bash
git branch -d critical_density
```

> The log will look the same as it would if we had always been working in the `main` branch.

<mermaid>
gitGraph
       commit id: "1"
       commit id: "2"
       commit id: "3"
</mermaid>
<!-- .element: style="height: 100px;" -->