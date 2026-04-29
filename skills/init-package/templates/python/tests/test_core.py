"""Tests for core functionality."""

import numpy as np
from {{PACKAGE_NAME}}.core import main_function


def test_main_function():
    """Test main_function returns input unchanged."""
    x = np.array([1.0, 2.0, 3.0])
    result = main_function(x)
    np.testing.assert_array_equal(result, x)
