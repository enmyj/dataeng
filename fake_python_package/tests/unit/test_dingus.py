import pytest
from fakepkg.subpkgone.dingus import dingus


def test_dingus_string():
    assert dingus('foo') == 'foodingus', "Should be 'foodingus'"


def test_dingus_num():
    assert dingus(1) == '1dingus', "Should be '1dingus'"
    assert dingus(1.23) == '1.23dingus', "Should be 1.23dingus"


def test_dingus_func():
    with pytest.raises(AssertionError):
        dingus(sum)
