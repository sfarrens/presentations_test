---
---
## Code example

```python
import numpy as np

def gaussian(x, mu=0.0, sigma=1.0):
    """Evaluate a normalised Gaussian."""
    norm = 1.0 / (sigma * np.sqrt(2 * np.pi))
    return norm * np.exp(-0.5 * ((x - mu) / sigma) ** 2)

x = np.linspace(-4, 4, 500)
y = gaussian(x, mu=0.5, sigma=0.8)
```

Toggle **☾ / ☀** in the top-right corner to switch themes.
