import pylib


def test_pylib():
    pass


def test_osf_fetch():
    cache_path = pylib.osf_fetch("pvq7w")
    assert cache_path.exists()
    assert cache_path.stat().st_size > 0
