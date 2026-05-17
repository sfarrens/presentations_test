## Unit testing

--

> Once we have some working code, it is a very good idea to write some accompanying *unit tests*. This ensures that individual components of our code (e.g. functions, classes, etc.) do what we expect them to do. This also helps us avoid introducing bugs into the code, as the tests should fail if we break something.

--

> Let's write a test for our `cosmology.py` module. Start by adding a directory called `tests` to the `mycosmo` directory, then create a file called `test_cosmology.py` and add the following content.

```python
import numpy as np
import numpy.testing as npt

from mycosmo.cosmology import hubble


class TestCosmology:
    fid_cosmo = {
        "H0": 70,
        "omega_m_0": 0.3,
        "omega_k_0": 0.0,
        "omega_lambda_0": 0.7,
    }
    H_tolerance = 0.01
    z_range = np.array([0.0, 0.5, 1.0])
    H_expect = np.array([70, 91.60, 123.24])

    def test_hubble(self):
        H_vals = hubble(self.z_range, self.fid_cosmo)

        npt.assert_allclose(
            H_vals,
            self.H_expect,
            atol=self.H_tolerance,
            err_msg=(
                "The H(z) differs from expected values by more than "
                f"{self.H_tolerance} decimal places."
            ),
        )
```

--

> We can use the [pytest](https://docs.pytest.org/) package to run the unit tests.

```bash
python -m pytest --verbose mycosmo
```

> If all went well `TestCosmology::test_hubble` should have *PASSED*.

--

> Now try introducing a deliberate bug into the code. For example, try making the following change to the `hubble` function in `cosmology.py`.

```python
matter = cosmo_dict["omega_m_0"] * (1 + redshift) ** 4
```

> Now re-run `pytest`. You should see that `TestCosmology::test_hubble` has *FAILED* and explanation of why.

--

> There are various pytest plug-ins that can help us improve our code. Some good example are:

- [pytest-cov](https://github.com/pytest-dev/pytest-cov): to provide a *coverage* report
- [pytest-pydocstyle](https://github.com/henry0312/pytest-pydocstyle): to check your documentation standards
- [pytest-emoji](https://github.com/hackebrot/pytest-emoji): if you like emojis 😂

--

> We can invoke these extra features using the corresponding command line options.

```bash
python -m pytest --verbose --emoji --pydocstyle --cov=mycosmo mycosmo
```

> Note that the documentation tests will fail because we done't have any yet! 😰
<!-- .element: style="font-size: 50%;" -->

> The coverage report tells us which fraction of the code has been covered by unit tests.[$^{11}$](#/13/12)

--

## Exercise

> Add a new unit test for the `critical_density` function. Use the [Git workflow](#/4/18) that we established previously to implement the updated code via a MR/PR. 

> It is recommend that you work in pairs with each of you acting as the reviwer for each other's MR/PR.