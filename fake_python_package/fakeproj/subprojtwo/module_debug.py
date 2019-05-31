"""
Test Module Documentation

Example
-------

Run the bar function as a module::

    $ python -m module_debug.py


"""

import pandas as pd
from IPython.core.debugger import set_trace


def bar(a):
    """a man walks into a bar...

    Parameters
    ----------
    a : int
        An integer

    Returns
    -------
    list
        a list containing a number

    Example
    -------

        >>> bar('foo')
        ['foo']
    """
    return list(a)


def data_science():
    """ Practice using a the ipdb debugger """
    df = pd.DataFrame({'a': [1, 2], 'b': [3, 4]})
    df_summed = df.sum()
    # set_trace
    return df_summed


def bad_function():
    """ Not implemented """
    # This is a really long and dumb line and I'm hoping my linter will catch
    # it because it's going to be impossible to read on any other screen
    raise NotImplementedError

if __name__ == "__main__":
    bar('a')
