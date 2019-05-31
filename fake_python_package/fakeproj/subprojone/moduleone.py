class Foo():
    """Foo class, you know"""

    def foo(self):
        """Returns foo, you know"""
        return 'foo'


def concat(one, two):
    """Concatenates two strings

    :param one: first string
    :type one: str
    :param two: second string
    :type two: str
    :returns: a string combinging string a and b
    :rtype: str

    Usage::

        >>> concat('a','b')
        'ab'
    """
    assert (type(one) == str) & (type(two) == str), (
        "one and two must be strings")
    return one + two
