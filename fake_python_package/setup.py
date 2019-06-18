import os
from setuptools import find_packages, setup


def main():
    def read(fname):
        with open(os.path.join(os.path.dirname(__file__), fname)) as _in:
            return _in.read()

    setup(
        name="fakepkg",
        version="1.0",
        author="author",
        author_email="xyz@gmail.com",
        url="url.com",
        description="",
        packages=find_packages(),
        entry_points={
            'console_scripts': [
                'fakepkg = fakepkg.main:main']}
    )

if __name__ == "__main__":
    main()
