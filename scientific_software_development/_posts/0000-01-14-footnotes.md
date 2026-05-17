# Footnotes

--

> These slides contain footnotes to add further context to some points raised in previous slides.

--

> $1$: It is good practice to avoid hard-coding parameters inside functions. In this particular example, the cosmological constants in question will likely be needed for other functions and we don't ever want to copy and paste code. Therefore, here we want to abstract the constants such that they can be provided as arguements. An alernative approach would be to add the function to a class and make these constants class attributes.

[Return to slide](#/3/8)

--

> $2$: Pro tip 😎: You can combine the two previous commands using the `-b` option for `checkout`. 

```bash
git checkout -b critical_density
```

[Return to slide](#/3/12)

--

> $3$: It is good pratice to make regular focused merges with minimal changes to the code. This make things easier to maintain and reduces the chances of breaking something. Therefore, feature branches should only exist long enough to resolve the issue for which they were created. Long-lived feature branches are more likely to evolve into a conflicting state. 

[Return to slide](#/3/17)

--

> $4$: There are some limitations as to what you can do with private repositories on GitHub with a free account, however all features are fully available for public repositories.

[Return to slide](#/4/2)

--

> $5$: The the name `origin` is completely arbitrary, but this is the community standard.

[Return to slide](#/4/6)

--

> $6$: The `-u` option is short for `--set-upstream` and is only needed the first time push to a repository that you have initialised locally. In other words, if you create your repository on GitHub or GitLab and clone it, the you won't need to use this option the first time you push.

[Return to slide](#/4/7)

--

> $7$: The `-A` option is short for `--all` and adds all modified or untracked files to the staging area.

[Return to slide](#/4/12)

--

> $8$: Pro tip 😎: You can list both local and remote branches with the `-a` option.

```bash
git branch -a
```

[Return to slide](#/4/13)

--

> $9$: Both GitHub and GitLab have options for automatically deleting feature branches after a PR/MR. Local branches will always have to be managed manually.

[Return to slide](#/4/16)

--

> $10$: Pro tip 😎: You can clean the list of remote branches (see [$8$](#/14/9)) using the `prune` option.

```bash
git remote prune origin
```

[Return to slide](#/4/16)

--

> $11$: In general, we would like to get as close to 100% coverage as possible. However, just because our coverage report says we are at 100%, it doesn't mean that we have tested everything we can possibly test, or indeed that our tests are any good. A code with lower coverage but with better quality tests may well be more robust.

[Return to slide](#/5/6)

--

> $12$: Other *README* formats, such as reStructuredText (`README.rst`), are supported by most hosting platforms.

[Return to slide](#/7/2)

--

> $13$: The `sphinx-quickstart` command will only need to be run once.

[Return to slide](#/7/5)

--

> 14: The `sphinx-apidoc` command will need to be re-run every time we add or remove a module from the package. The `-M` option is short for `--module-first` and puts module documentation before submodule documentation. The `-f` option is short for `--force` and overwrites and existing files. The `-e` option is short for `--separate` and puts each module on its own page. Finally, the `-o` option is short for `--output-dir` and sets the output directory path.

[Return to slide](#/7/8)

--

> $15$: Docstrings need to adhere to reStructuredText formatting standards. The elements with backquotes(` `` `) will be rednered as *literals*.

[Return to slide](#/7/15)

--

> $16$: The `sphinx-build` option `-b` sets the builder to use, in this case `doctest`. The option `-E` ensures that all files are read for the tests.

[Return to slide](#/7/19)

--

> $17$: If the `fail-fast` option is set to `true`, then all jobs will be aborted if any of the tests fails. This can be useful if you have a large *matrix* of jobs. However, some failures will be system dependent, therefore it can also be useful to set this option to `false` and let jobs run to see on which systems the errors occur.

[Return to slide](#/8/4)

--

> $18$: We will only want to deploy one set of HTML pages. Having API documentation for every branch could be very confusing for the users. Therefore, we only want to trigger our CD workflow on the branch for which we want to deploy the documentation. In this case, the `main` branch.

[Return to slide](#/8/8)

--

> $19$: Unlike the unit tests, we don't care about system dependencies for building our API documentation. This is not something we expect the user to do. So, as long as we can get it to work on one machine, we are good.

[Return to slide](#/8/9)

--

> $20$: The `${{ "{{" }} secrets.GITHUB_TOKEN }}` token is set automatically by GitHub, but you will need to allow write permissions (see [here](#/8/13)).

[Return to slide](#/8/12)

--

> $21$: `gh-pages` is a special branch name used by GitHub to idenify where HTML content is stored that should be deployed as a website. We don't want to include any other content on the branch. The `--orphan` option for `git checkout` creates a new branch without copying the commit history of the current branch. The `reset` command ensures that the orphan branch is at an inital commit state. The `--allow-empty` option allows us to make a commit without any content.

[Return to slide](#/8/13)

--

> $22$: `.gitlab-ci.yml` is a special file name that should always be used for GitLab CI/CD.

[Return to slide](#/9/1)

--

> $23$: The crazy stuff 😵‍💫 after `coverage` simply formats the total coverage score. This just depends on which tool is used to generate the coverage score.

[Return to slide](#/9/4)

--

> $24$: It is good practice for the name of the directory that contains the Python code, `mycosmo` in this case, to match the package name, which we also call `mycosmo`. However, this is not required to make things work.

[Return to slide](#/10/2)

--

> $25$: Pro tip 😎: We can replace `dev` with any of the options we defined [previously](#/10/5) (e.g. `docs`, `tests`, etc.). We can also combine any of the optional dependencies we like when installing the package. For example, to install both testing and documentation dependendencies, we would run the following.

```bash
pip install ".[test,docs]"
```

[Return to slide](#/10/9)

--

> $26$: ⚠️ You should make sure your package name is not already taken before uploading something to PyPI.

[Return to slide](#/10/15)

--

> $27$: ⚠️ You will need to increase your package version each time you upload a new distribution to PyPI.

[Return to slide](#/10/16)

--

> $28$: Note that *pinning* (i.e. setting a version with `==`) is not always a good idea. Packages like Numpy tend to put a lot of effort into making their libraries backwards compatibile. By pinning a dependency we may make our code incompatible with other packages. This really comes down to the scope of our code, whether this is a stand-alone piece of software that should be used in a dedicated environemnt (like a pipeline) or something more flexible (like a library) that would be used in conjunction with other packages.

[Return to slide](#/11/6)

--

> $29$: This is just an example of a `Dockerfile` that is taking advantage of the predefined Conda environment. It would be just as easy to build a Docker image that does not use Conda at all. The `FROM` command defines the base Docker image on which to build. Each call to `RUN` defines a new *layer* in the image. Lower layers do not not need to be re-built if an upper layer changes. The `COPY` command copies the contents of the current working directory into the build environment. `WORKDIR` sets the defult working directory inside the container. `ENV SHELL` sets the defult environment shell. Finally, `LABEL` simply labels the image.

[Return to slide](#/11/10)

--

> $30$: The Docker `build` option `-t` is short `--tag` and sets a label for the corresponding image. The Docker `run` option `-i` is short for `--interactive` and launches an interactive container. The `-t` option is short for `--tty` and allocates a pseudo-TTY for the container.

[Return to slide](#/11/11)

--

> $31$: There are some things we simply cannot control, such as the physical architecture on which the code is run. While Docker containers are fairly universal, there is no 100% guarantee that things will work perfectly on every computer.

[Return to slide](#/11/12)