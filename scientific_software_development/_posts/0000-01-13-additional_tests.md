## Additional Tests

--

> While unit tests are essential, there are other types of tests we can write to ensure our code works correctly. One important type is *verification tests* that compare our code against well-established libraries or analytical solutions.

--

> Let's look at an example where we verify our cosmological calculations against those provided by the [Astropy](https://www.astropy.org/) library. This is particularly useful because Astropy is a well-tested and widely-used package in the astronomical community.

--

> Here's an example of a verification test that compares our `mycosmo` calculations with Astropy's WMAP9 cosmology:

```python
import numpy as np
from astropy.cosmology import WMAP9 as cosmo

from mycosmo.cosmology import critical_density, hubble

class TestAstropy:
    """Test Astropy.
    
    Class to test ``mycosmo`` routines with respect to those provided in Astropy.
    """
    
    redshift = np.array([0.0, 0.5, 1.0])
    cosmo_dict = {
        "H0": cosmo.H0.value,
        "omega_m_0": cosmo.Om0,
        "omega_k_0": cosmo.Ok0,
        "omega_lambda_0": cosmo.Ode0,
    }

    def test_hubble(cls):
        """Test Hubble function."""
        h_mycosmo = hubble(redshift=cls.redshift, cosmo_dict=cls.cosmo_dict)
        h_astropy = cosmo.H(cls.redshift).value
        
        assert (abs(h_mycosmo - h_astropy) < 0.1).all()
```

--

> This test:

- Uses Astropy's WMAP9 cosmology as a reference
- Compares our Hubble function calculations at different redshifts
- Ensures the differences are within acceptable tolerances

--

> We can also verify our critical density calculations:

```python
    def test_critical_density(cls):
        """Test Critical Density function."""
        rho_crit_mycosmo = (
            critical_density(redshift=cls.redshift, cosmo_dict=cls.cosmo_dict) * 1e26
        )
        rho_crit_astropy = cosmo.critical_density(cls.redshift).value * 1e29
        
        assert (abs(rho_crit_mycosmo - rho_crit_astropy) < 0.01).all()
```

--

> These verification tests provide several benefits:

- They validate our code against a trusted reference implementation
- They help catch numerical precision issues
- They ensure our code produces physically meaningful results
- They make our code more trustworthy for scientific applications

--

> Other types of tests you might consider adding:

- Integration tests that verify multiple components work together
- Performance tests to ensure code runs efficiently
- Regression tests to catch previously fixed bugs
- Property-based tests that verify mathematical properties

--

## Exercise

> Add this verification test to a `scripts` directory in your repository and write a workflow (e.g. GitHub action) to implement it. Your workflow should be able to be triggered on demand (e.g. using `on: workflow_dispatch`).