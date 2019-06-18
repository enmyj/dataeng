# import inspect


def dingus(phrase):
    """
    Appends the string 'dingus' to anything passed to the function
    """
    assert type(phrase) in [int, float, str], (
        'phrase should be a string, float, or integer. '
        'The phrase passed was {}'.format(type(phrase))
    )

    return str(phrase) + 'dingus'
