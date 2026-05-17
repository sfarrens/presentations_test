## Version control II
### Git repositories

--

> Now that we are all familiar with the baiscs of *Git* (see [previous section](#/3)), we can look at some of the some of the cloud-based platforms that allow us to host Git repositories. In particular, we will look at [GitHub](https://github.com/) and [GitLab](https://about.gitlab.com/) and some of the tools they offer.

> We will also look at the `git` commands that allow us to interface with these platforms.

--

> Both GitHub and GitLab have their own stengths and weaknesses. For your own projects you should choose whichever platform you prefer. It is useful, however, to be familiar with both as for some projects you will have to go along with the platform chosen by the team.[$^4$](#/13/5)

|                     | GitHub | GitLab |
| ------------------- | ------ | ------ |
| Free                | ✅      | ✅      |
| Forking             | ✅      | ✅      |
| Mirroring           | ✅      | ⭐️      |
| Pages               | ✅      | ✅      |
| CI/CD               | ⭐️      | ✅      |
| Wiki                | ✅      | ⭐️      |
| Discussions         | ✅      | ❌      |
| Issue boards        | ✅      | ⭐️      |
| Pull/Merge requests | ✅      | ✅      |
| Containers          | ✅      | ✅      |
<!-- .element: style="font-size: 60%;" -->

--

> Let's go ahead and create a repository called `example` on either of the two platforms.*

> *Or both if you want.
<!-- .element: style="font-size: 50%;" -->

--

<img src="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png" alt="GitHub logo" width="200" class="reveal.imgblock">

## GitHub

<mermaid>
graph LR;
    a["Repositories"]
    b["New"]
    c["Create repository"]
    a --> b --> |"Repo name: `example` 
    Leave the rest alone"| c
</mermaid>
<!-- .element: style="height: 150px;" -->

--

<img src="https://about.gitlab.com/images/press/logo/png/gitlab-logo-500.png" alt="GitLab logo" width="200" class="reveal.imgblock">

## GitLab

<mermaid>
graph LR;
    a["Projects"]
    b["New project"]
    c["Create blacnk project"]
    d["Create project"]
    a --> b --> c -->|"Project name: `example` 
    Unclick the `README` option
    Leave the rest alone"| d
</mermaid>
<!-- .element: style="height: 150px;" -->

--

> In order to connect our local (i.e. on your computer) Git repository with a hosting platform, we will need to provide an address for our *remote* (i.e. online) repository. We can do this with the `remote` command.

```bash
git remote add origin <REPOSITORY ADDRESS>
```

> Where, `origin` is just an alias for the remote address.[$^5$](#/13/6)

> We can list the currently attached remote addresses with the `-v` option.

```bash
git remote -v
```

--

> We can use the `push` command to upload our local repository to the remote hosting platform.[$^6$](#/13/7)

```bash
git push -u origin main
```

> Now, we can see our code and the corresponding commit history on either GitHub or GitLab.

--

> Both platforms support *issues*, and these are a great way of managing a software development project. 

> Let's start by creating an issue to refactor part of our code. With our last commit we introduced some hard-coded variables into a function. Let's move these into a separate module to make things easier to maintain.

> Then we can add our issue to a *project/issue board* and/or a *milestone* to keep track of its progress.

--

> Let's now look at some more `git` commands that will allow us manage a *Git workflow*.

> We can start by trying to address the issue we just opened. First, we need to create a new feature branch, let's call it `refactor`.

```bash
git checkout -b refactor
```

--

> Let's create a directory called `mycosmo` and put our `cosmology.py` module inside.

```bash
mkdir mycosmo
mv cosmology.py mycosmo
```

> Then we can turn this directory into a Python module by adding an empty `__init__.py` file.

```bash
touch mycosmo/__init__.py
```

--

> To refactor our code, we will add a new file to `mycosmo` called `constants.py` with the following content.

```python
G = 6.6743e-11
Mpc = 3.08568e22
```

> Now, we need to add an import of these constants to `cosmology.py` as follows

```python
import numpy as np

from .constants import Mpc, G
```

--

> and to modify the `critical_density` function as follows.

```python
def critical_density(redshift, cosmo_dict):
    H_z_si = hubble(redshift, cosmo_dict) * 1e3 / Mpc

    return (3.0 * H_z_si**2) / (8.0 * np.pi * G)
```

> Now, we will add and commit our changes.[$^7$](#/13/8)

```bash
git add -A
git commit -m "Refactored code, added constants.py module"
```

--

> Instead of merging these changes locally, we will push the feature branch to our remote repository.[$^8$](#/13/9)

```bash
git push origin refactor
```

> Then we can open a *Pull Request* (PR, GitHub) or a *Merge Request* (MR, GitLab) to propose a solution to our issue. This will allow us to review the code, propose improvements and discuss the changes before merging to the `main` branch. 

--

> When working in on collaborative project, it is good practice to assign a *developer* (i.e. the person making the changes to the code) and a separate *reviewer* (i.e. the person who will check the merge/pull request) for each issue. When both parties are in a agreement, the MR/PR can be merged.


#### 👍

--

Now, we have to clean everything up! 

#### 😅

--

> Start by deleting the remote feature branch (i.e. `refactor` on GitHub/GitLab).[$^9$](#/13/10)

> Then you need use the `pull` command to download the changes to the `main` branch.

```bash
git checkout main
git pull origin main
```

> Now, we can  delete the local feature branch.[$^{10}$](#/13/11)

```bash
git branch -d refactor
```

--

We can complete the process we started by closing our issue!


#### 🥳

--

> Now, you are all set to continue your Git workflow.

<mermaid>
flowchart RL
    main_l["main"]
    main_r["main"]
    feat_l["feature"]
    feat_r["feature"]
    feat_l-->|`git push origin ...`|feat_r
    main_r-->|`git pull origin main`|main_l
    subgraph Remote
    feat_r-->|Pull/Merge Request|main_r
    end
    subgraph Local
    main_l-->|`git checkout -b ...`|feat_l
    end
</mermaid>
<!-- .element: style="height: 500px;" -->