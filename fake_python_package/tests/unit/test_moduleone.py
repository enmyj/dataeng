import pytest
from fakeproj.subprojone.moduleone import Foo


def test_foo():
    foo = Foo()
    assert foo.foo() == 'foo', "function foo should output foo"
