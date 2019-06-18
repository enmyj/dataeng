# setup
init:
	# conda install -f environment.yml --prune
	# conda activate fakepkg
	pip install -e .

install:
	pip install .

# teardown
uninstall:
	pip uninstall -y fakepkg
	rm -rf fakepkg.egg-info
	rm -rf .pytest_cache

# tests
unittest:
	pytest tests/unit

integerationtest:
	pytest tests/integration

alltests:
	pytest .

# Document
document:
	make -C docs html
